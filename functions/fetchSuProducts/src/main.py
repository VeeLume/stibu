import hashlib
import json
import os
from datetime import datetime, timezone

import httpx
from appwrite.client import Client
from appwrite.query import Query
from appwrite.services.databases import Databases
from pydantic import BaseModel, Field, ValidationError

# -------------------------
# Config: your DB/Collection
# -------------------------
DB_ID = "68aa3101001363c8ad54"
COLLECTION_ID = "68aa31c30013def4afe7"


# -------------------------
# Models (mutable; lists, not frozensets)
# -------------------------


class Product(BaseModel):
    suId: int = Field(alias="id")
    itemPrice: int
    qtyLimit: int
    originalItemPrice: int
    hasSalePrice: bool
    launchDate: str  # ISO 8601
    endSaleDate: str
    beginSaleDate: str
    slug: str
    images: list[str] = Field(default_factory=list)
    title: str
    description: str
    inventoryStatus: str | None = None
    culture: str
    colors: list[str] = Field(
        default_factory=list, alias="color"
    )  # API field is "color"
    canBePurchased: bool
    exclusiveTo: list[str] = Field(default_factory=list)
    categorySlugs: list[str] = Field(default_factory=list)
    alternateId: str | None = None
    replacementForItemId: int | None = None
    hoverImage: str | None = None
    metaDescription: str | None = None
    metaTitle: str | None = None
    isCommissionable: bool
    excludeFrom: list[str] = Field(default_factory=list)
    languages: list[str] = Field(default_factory=list)
    qualifier: list[str] = Field(default_factory=list)
    lifeCycleStates: list[str] = Field(default_factory=list)
    offeringType: str

    # computed per run
    revision: int = 0
    fingerprint: str = ""
    seenAt: str = ""


# -------------------------
# Helpers
# -------------------------


def _now_iso() -> str:
    try:
        return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")
    except Exception:
        return "1970-01-01T00:00:00Z"


def _to_cents(x) -> int:
    try:
        return int(round(float(x) * 100))
    except Exception:
        return 0


def _fp(product: Product) -> str:
    """
    Stable hash across persisted fields (ignores seenAt, revision).
    Lists are sorted to make the hash order-independent.
    """
    body = {
        "suId": product.suId,
        "itemPrice": product.itemPrice,
        "qtyLimit": product.qtyLimit,
        "originalItemPrice": product.originalItemPrice,
        "hasSalePrice": product.hasSalePrice,
        "launchDate": product.launchDate,
        "endSaleDate": product.endSaleDate,
        "beginSaleDate": product.beginSaleDate,
        "slug": product.slug,
        "images": sorted(product.images),
        "title": product.title,
        "description": product.description,
        "inventoryStatus": product.inventoryStatus,
        "culture": product.culture,
        "colors": sorted(product.colors),
        "canBePurchased": product.canBePurchased,
        "exclusiveTo": sorted(product.exclusiveTo),
        "categorySlugs": sorted(product.categorySlugs),
        "alternateId": product.alternateId,
        "replacementForItemId": product.replacementForItemId,
        "hoverImage": product.hoverImage,
        "metaDescription": product.metaDescription,
        "metaTitle": product.metaTitle,
        "isCommissionable": product.isCommissionable,
        "excludeFrom": sorted(product.excludeFrom),
        "languages": sorted(product.languages),
        "qualifier": sorted(product.qualifier),
        "lifeCycleStates": sorted(product.lifeCycleStates),
        "offeringType": product.offeringType,
    }
    s = json.dumps(body, separators=(",", ":"), ensure_ascii=False, sort_keys=True)
    return hashlib.sha256(s.encode("utf-8")).hexdigest()


def _chunk(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i : i + n]


# -------------------------
# External fetch
# -------------------------


def get_current_products(context) -> list[Product]:
    context.log("Fetching products from Stampin’ Up…")
    try:
        with httpx.Client(
            base_url="https://az-api.stampinup.de",
            headers={
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/116.0"
            },
            timeout=httpx.Timeout(connect=5.0, read=25.0, write=10.0, pool=5.0),
        ) as client:
            r = client.get(
                "/de-de/products",
                params={"page": 1, "pageSize": 9999, "category": "/shop-products"},
            )
            if r.status_code != 200:
                context.error(f"Fetch failed: {r.status_code} {r.text[:160]}")
                return []

            raw_products = r.json().get("products", []) or []
            products: list[Product] = []
            now_iso = _now_iso()

            for raw in raw_products:
                # price → cents
                raw["itemPrice"] = _to_cents(raw.get("itemPrice", 0))
                raw["originalItemPrice"] = _to_cents(raw.get("originalItemPrice", 0))

                # cap description length (DB limit) to 7000 chars
                if "description" in raw and raw["description"]:
                    raw["description"] = raw["description"][:7000]

                # normalize listy fields (pydantic defaults handle missing)
                for key in (
                    "images",
                    "color",
                    "exclusiveTo",
                    "categorySlugs",
                    "excludeFrom",
                    "languages",
                    "qualifier",
                    "lifeCycleStates",
                ):
                    if key in raw and raw[key] is None:
                        raw[key] = []

                try:
                    p = Product(**raw)
                except ValidationError as ve:
                    context.error(
                        f"Validation error for id={raw.get('id')}: {str(ve).splitlines()[0]}"
                    )
                    continue

                p.fingerprint = _fp(p)
                p.seenAt = now_iso
                p.revision = 0
                products.append(p)

            context.log(f"Fetched & normalized {len(products)} products.")
            return products

    except Exception as e:
        context.error(f"Fetch crashed: {e}")
        return []


# -------------------------
# DB lookups (latest-per-id using composite index suId ASC, seenAt DESC)
# -------------------------


def list_latest_for_ids(
    databases: Databases, context, su_ids: list[int]
) -> dict[int, dict]:
    """
    Returns suId -> latest document (by seenAt desc).
    Requires key index on suId and composite (suId ASC, seenAt DESC).
    """
    latest: dict[int, dict] = {}
    remaining = set(su_ids)
    cursor = None
    page_size = 300  # tune as you like

    while remaining:
        queries = [
            Query.equal("suId", list(remaining)),
            Query.order_desc("seenAt"),
            Query.limit(page_size),
        ]
        if cursor:
            queries.append(Query.cursor_after(cursor))

        try:
            resp = databases.list_documents(DB_ID, COLLECTION_ID, queries)
        except Exception as e:
            context.error(f"list_documents failed: {e}")
            break

        docs = resp.get("documents", [])
        if not docs:
            break

        for doc in docs:
            sid = doc.get("suId")
            if sid in remaining:
                latest[sid] = doc
                remaining.remove(sid)

        cursor = docs[-1]["$id"]
        if len(docs) < page_size:
            break

    if remaining:
        context.log(
            f"Latest lookup: {len(remaining)} ids have no prior docs (new items)."
        )
    return latest


# -------------------------
# Main
# -------------------------


def main(context):
    context.log(f"Run started @ {_now_iso()}")

    # Appwrite client
    try:
        client = (
            Client()
            .set_endpoint(os.environ["APPWRITE_FUNCTION_API_ENDPOINT"])
            .set_project(os.environ["APPWRITE_FUNCTION_PROJECT_ID"])
            .set_key(context.req.headers["x-appwrite-key"])
        )
        databases = Databases(client)
        context.log("Appwrite client ready.")
    except Exception as e:
        context.error(f"Client init failed: {e}")
        return context.res.json(
            {"success": False, "message": "client init failed"}, 200
        )

    # 1) Fetch external products
    api_products = get_current_products(context)
    if not api_products:
        context.error("No products fetched; aborting gracefully.")
        return context.res.json(
            {"success": False, "message": "no products fetched"}, 200
        )

    # 2) Get latest docs for these suIds in batches
    su_ids = [p.suId for p in api_products]
    latest_by_id: dict[int, dict] = {}
    for batch in _chunk(su_ids, 250):
        part = list_latest_for_ids(databases, context, batch)
        latest_by_id.update(part)

    # 3) Decide what to insert (append-only)
    to_insert: list[dict] = []
    skipped = 0
    now_iso = _now_iso()

    for p in api_products:
        last = latest_by_id.get(p.suId)
        last_fp = last.get("fingerprint") if last else None
        next_rev = (last.get("revision", 0) + 1) if last else 1

        if last_fp == p.fingerprint:
            skipped += 1
            continue

        d = p.model_dump(by_alias=False)  # we already mapped aliases on input
        d["revision"] = next_rev
        d["seenAt"] = now_iso
        # ensure correct field names for your collection (you used "colors" in schema)
        # pydantic already mapped API "color" → model "colors"

        to_insert.append(d)

    context.log(f"Prepared {len(to_insert)} inserts; skipped unchanged: {skipped}.")

    # 4) Bulk insert in chunks (no exceptions leak)
    inserted = 0
    for chunk in _chunk(to_insert, 100):
        try:
            databases.create_documents(
                database_id=DB_ID,
                collection_id=COLLECTION_ID,
                documents=chunk,
            )
            inserted += len(chunk)
        except Exception as e:
            context.error(f"Bulk insert failed for {len(chunk)} docs: {e}")

    context.log(f"Inserted {inserted} new revisions. Run finished @ {_now_iso()}")

    return context.res.json(
        {
            "success": True,
            "fetched": len(api_products),
            "inserted": inserted,
            "skippedUnchanged": skipped,
        },
        200,
    )

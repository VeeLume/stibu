# index.py
def main(context):
    context.log("function reached runtime")
    return context.res.json({"ok": True})

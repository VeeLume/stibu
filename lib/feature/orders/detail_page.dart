import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:open_filex/open_filex.dart';
import 'package:result_type/result_type.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/common/show_result_info.dart';
import 'package:stibu/feature/orders/list_detail.dart';
import 'package:stibu/feature/pdf_creation/typst.dart';
import 'package:stibu/feature/router/router.dart';
import 'package:stibu/main.dart';
import 'package:stibu/widgets/command_bar_print_button.dart';
import 'package:stibu/widgets/custom_page_header.dart';

@RoutePage()
class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    super.key,
    @PathParam('id') required this.id,
  });

  final String id;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Future<bool> markInvoiceReadOnly(Invoices invoice) async {
    if (invoice.canUpdate) {
      final appwrite = getIt<AppwriteClient>();
      final user = await appwrite.account.get();

      try {
        await appwrite.databases.updateDocument(
          databaseId: Invoices.collectionInfo.databaseId,
          collectionId: Invoices.collectionInfo.$id,
          documentId: invoice.$id,
          permissions: [Permission.read(Role.user(user.$id))],
        );
      } catch (e) {
        if (mounted) {
          await showResultInfo(context, Failure(e.toString()));
        }
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        // ignore: discarded_futures
        future: Orders.get(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ProgressBar());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data!.isFailure) {
            return Center(child: Text('Error: ${snapshot.data!.failure}'));
          }
          final order = snapshot.data!.success;

          return ScaffoldPage(
            header: CustomPageHeader(
              title: BreadcrumbBar(
                items: [
                  const BreadcrumbItem(label: Text('Orders'), value: 0),
                  BreadcrumbItem(
                    label: Text(order.invoice?.name ?? order.$id),
                    value: 1,
                  ),
                ],
                onItemPressed: (item) async {
                  if (item.value == 0) {
                    await context.navigateTo(OrderTab());
                  }
                },
              ),
              commandBar: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: CommandBar(
                  mainAxisAlignment: MainAxisAlignment.end,
                  primaryItems: [
                    if (order.canDelete)
                      CommandBarButton(
                        icon: const Icon(FluentIcons.delete),
                        onPressed: () async {
                          final result = await order.delete();
                          if (!context.mounted) return;
                          if (result.isFailure) {
                            await displayInfoBar(
                              context,
                              builder: (context, close) => InfoBar(
                                title: const Text('Error'),
                                content: Text(result.failure),
                                severity: InfoBarSeverity.error,
                              ),
                            );
                          } else {
                            await displayInfoBar(
                              context,
                              builder: (context, close) => const InfoBar(
                                title: Text('Success'),
                                content: Text('Order deleted'),
                                severity: InfoBarSeverity.success,
                              ),
                            );
                            if (!context.mounted) return;
                            await context.router.maybePop();
                          }
                        },
                      ),
                    if (order.invoice != null)
                      CommandBarPrintButton(
                        title: const Text('Print Invoice'),
                        type: PrintTemplatesType.invoiceWithOrder,
                        onPressed: (template) async {
                          final invoice = (await Invoices.get(
                            order.invoice!.$id,
                          ))
                              .success;

                          final isOK = await markInvoiceReadOnly(invoice);
                          if (!isOK) return;

                          final result = await createPdf(template, invoice);

                          if (result.isFailure && context.mounted) {
                            await showResultInfo(context, result);
                          } else {
                            await OpenFilex.open(result.success.path);
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
            content: Column(
              children: [
                OrderInfoCard(order: order),
                Expanded(
                  child: OrderProductsList(
                    order: order,
                  ),
                ),
              ],
            ),
          );
        },
      );
}

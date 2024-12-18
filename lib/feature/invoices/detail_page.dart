import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/feature/invoices/list_page.dart';
import 'package:stibu/feature/router/router.dart';
import 'package:stibu/widgets/custom_page_header.dart';

@RoutePage()
class InvoiceDetailPage extends StatefulWidget {
  const InvoiceDetailPage({
    super.key,
    @PathParam('id') required this.id,
  });

  final String id;

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        // ignore: discarded_futures
        future: Invoices.get(widget.id),
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
          final invoice = snapshot.data!.success;

          return ScaffoldPage(
            header: CustomPageHeader(
              title: BreadcrumbBar(
                items: [
                  const BreadcrumbItem(label: Text('Invoices'), value: 0),
                  BreadcrumbItem(label: Text(invoice.name), value: 1),
                ],
                onItemPressed: (item) async {
                  if (item.value == 0) {
                    await context.navigateTo(InvoiceTap());
                  }
                },
              ),
              commandBar: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: CommandBar(
                  mainAxisAlignment: MainAxisAlignment.end,
                  primaryItems: [
                    CommandBarButton(
                      icon: const Icon(FluentIcons.edit),
                      onPressed: () async {
                        // TODO: Implement edit
                      },
                    ),
                    CommandBarButton(
                      icon: const Icon(FluentIcons.delete),
                      onPressed: () async {
                        final result = await invoice.delete();
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
                              content: Text('Invoice deleted'),
                              severity: InfoBarSeverity.success,
                            ),
                          );
                          if (!context.mounted) return;
                          await context.router.maybePop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            content: InvoiceListDetail(invoice: invoice),
          );
        },
      );
}

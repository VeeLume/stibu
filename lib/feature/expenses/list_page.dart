import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/common/datetime_formatter.dart';
import 'package:stibu/common/is_large_screen.dart';
import 'package:stibu/common/models_extensions.dart';
import 'package:stibu/common/new_ids.dart';
import 'package:stibu/common/scroll_to_index.dart';
import 'package:stibu/feature/app_state/realtime_subscriptions.dart';
import 'package:stibu/feature/expenses/input.dart';
import 'package:stibu/main.dart';

Future<Expenses?> _showExpenseCreateDialog(BuildContext context) async {
  final expense = await showDialog<Expenses>(
    context: context,
    builder: (context) => const ExpenseInputDialog(
      title: 'Create Expense',
    ),
  );

  if (expense != null) {
    final expenseNumber = await newExpenseNumber(expense.date);
    if (expenseNumber.isFailure && context.mounted) {
      await displayInfoBar(
        context,
        builder: (context, close) => InfoBar(
          title: const Text('Error'),
          content: Text(expenseNumber.failure),
          severity: InfoBarSeverity.error,
        ),
      );
      return null;
    }

    final user = await getIt<AppwriteClient>().account.get();

    final result = await expense
        .copyWith(
          expenseNumber: () => expenseNumber.success,
      $permissions: [
        Permission.read(Role.user(user.$id)),
        Permission.write(Role.user(user.$id)),
      ],
        )
        .create();
    if (!context.mounted) return null;

    if (result.isFailure) {
      await displayInfoBar(
        context,
        builder: (context, close) => InfoBar(
          title: const Text('Error'),
          content: Text(result.failure),
          severity: InfoBarSeverity.error,
        ),
      );
      return null;
    }

    return result.success;
  }

  return null;
}

Future<Expenses?> _showExpenseEditDialog(
  BuildContext context,
  Expenses expense,
) async {
  final newExpense = await showDialog<Expenses>(
    context: context,
    builder: (context) => ExpenseInputDialog(
      title: 'Edit Expense',
      expense: expense,
    ),
  );

  if (newExpense != null) {
    final result = await newExpense.update();
    if (!context.mounted) return null;

    if (result.isFailure) {
      await displayInfoBar(
        context,
        builder: (context, close) => InfoBar(
          title: const Text('Error'),
          content: Text(result.failure),
          severity: InfoBarSeverity.error,
        ),
      );
      return null;
    }

    return result.success;
  }

  return null;
}

@RoutePage()
class ExpensesListPage extends StatefulWidget {
  const ExpensesListPage({super.key});

  @override
  State<ExpensesListPage> createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  int? _selectedIndex;
  Expenses? _selectedExpense;
  final _expenses = <Expenses>[];
  int _totalExpenses = 0;
  StreamSubscription? _expensesSubscription;
  final _scrollController = ScrollController();

  Future<void> _loadExpenses() async {
    late final (int, List<Expenses>) result;
    if (_expenses.isEmpty) {
      result = (await Expenses.page(offset: 0)).success;
    } else {
      result = (await Expenses.page(last: _expenses.last)).success;
    }

    setState(() {
      _totalExpenses = result.$1;
      _expenses.addAll(result.$2);
    });
  }

  @override
  void initState() {
    super.initState();
    unawaited(_loadExpenses());
    _expensesSubscription =
        getIt<RealtimeSubscriptions>().expensesUpdates.listen((update) {
      switch (update.type) {
        case RealtimeUpdateType.create:
          setState(() {
            _totalExpenses++;
            _expenses.add(update.item);
          });
        case RealtimeUpdateType.update:
          setState(() {
            final index = _expenses.indexWhere((e) => e.$id == update.item.$id);
            if (index != -1) {
              _expenses[index] = update.item;
            }
          });
        case RealtimeUpdateType.delete:
          final index = _expenses.indexWhere((e) => e.$id == update.item.$id);
          setState(() {
            _totalExpenses--;
            _expenses.removeAt(index);
          });
      }
    });
  }

  @override
  Future<void> dispose() async {
    await _expensesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final largeScreen = isLargeScreen(context);
    _selectedIndex = largeScreen ? _selectedIndex : null;

    if (_selectedExpense != null) {
      final index = _expenses.indexWhere((e) => e.$id == _selectedExpense!.$id);
      if (index != -1) {
        _selectedIndex = index;
        _selectedExpense = null;
      }
    }

    if (_selectedIndex != null && _selectedIndex! >= _expenses.length) {
      _selectedIndex = null;
    }

    if (_selectedIndex != null) {
      unawaited(scrollToIndex(_selectedIndex!, controller: _scrollController));
    }

    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Expenses'),
        commandBar: CommandBar(
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('New expense'),
              onPressed: () async => _showExpenseCreateDialog(context),
            ),
            if (_selectedIndex != null && _expenses[_selectedIndex!].canUpdate)
              CommandBarButton(
                icon: const Icon(FluentIcons.edit),
                label: const Text('Edit expense'),
                onPressed: () async {
                  final expense = _expenses[_selectedIndex!];
                  await _showExpenseEditDialog(context, expense);
                },
              ),
          ],
        ),
      ),
      content: Row(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemExtent: 58,
              itemCount: _totalExpenses > _expenses.length
                  ? _expenses.length + 1
                  : _expenses.length,
              itemBuilder: (context, index) {
                if (index >= _expenses.length) {
                  unawaited(_loadExpenses());
                  return const Center(
                    child: ProgressBar(),
                  );
                }

                final expense = _expenses[index];
                return ExpenseListEntry(
                  expense: expense,
                  selected: _selectedIndex == index,
                  onPressed: () {
                    if (_selectedIndex == index) return;
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseListEntry extends StatelessWidget {
  final Expenses expense;
  final bool selected;
  final VoidCallback? onPressed;

  const ExpenseListEntry({
    super.key,
    required this.expense,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(2.5),
        child: ListTile.selectable(
          selected: selected,
          onPressed: onPressed,
          tileColor: WidgetStateProperty.resolveWith((states) {
            if (states.isHovered) {
              return FluentTheme.of(context).accentColor.withValues(alpha: .1);
            }
            return FluentTheme.of(context)
                .resources
                .cardBackgroundFillColorDefault;
          }),
          leading: Container(
            height: 40,
            decoration: BoxDecoration(
              color: FluentTheme.of(context).accentColor.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(expense.expenseNumber),
              ),
            ),
          ),
          title: Text(expense.name),
          subtitle: Text(expense.date.formatDate()),
          trailing: Text(expense.amount.currency.format()),
        ),
      );
}

import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/feature/app_state/auth_provider.dart';
import 'package:stibu/main.dart';

class PrintTemplatesProvider extends ChangeNotifier {
  final List<PrintTemplates> _templates = [];

  List<PrintTemplates> get templates => _templates;

  PrintTemplatesProvider() {
    unawaited(_loadPrintTemplates());

    getIt<AuthProvider>().addListener(() async {
      if (getIt<AuthProvider>().isAuthenticated) {
        await _loadPrintTemplates();
      } else {
        _templates.clear();
        notifyListeners();
      }
    });
  }

  Future<void> _loadPrintTemplates() async {
    _templates.clear();
    late (int, List<PrintTemplates>) result;

    result = (await PrintTemplates.page(offset: 0)).success;
    _templates.addAll(result.$2);

    while (result.$1 > _templates.length) {
      result = (await PrintTemplates.page(last: _templates.last)).success;
      _templates.addAll(result.$2);
    }

    log.info('Loaded ${_templates.length} print templates');
    notifyListeners();
  }

  Future<void> reload() async {
    await _loadPrintTemplates();
  }
}

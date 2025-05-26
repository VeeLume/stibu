import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';

class AdaptiveInputDialog extends StatelessWidget {
  final List<Widget> content;
  final String title;
  final bool Function() onSave;

  const AdaptiveInputDialog({
    super.key,
    required this.content,
    required this.title,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    if (smallLayout(context)) {
      return Dialog.fullscreen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text(title),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      if (onSave()) {
                        context.pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to save changes.'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              ...content,
            ],
          ),
        ),
      );
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...content,
              TextButton(child: Text('Cancel'), onPressed: () => context.pop()),
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  if (onSave()) {
                    context.pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to save changes.')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

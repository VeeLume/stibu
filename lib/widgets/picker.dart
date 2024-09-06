import 'package:fluent_ui/fluent_ui.dart';
import 'package:stibu/common/datetime_formatter.dart';

class FormTimePicker extends StatefulWidget {
  final String header;
  final DateTime? selected;
  final void Function(DateTime?)? onChanged;
  final void Function(DateTime?)? onSaved;
  final String? Function(DateTime?)? validator;
  final AutovalidateMode? autovalidateMode;

  const FormTimePicker({
    super.key,
    required this.header,
    required this.selected,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
  });

  @override
  State<FormTimePicker> createState() => _FormTimePickerState();
}

class _FormTimePickerState extends State<FormTimePicker> {
  late DateTime? _selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: _selected,
      autovalidateMode: widget.autovalidateMode,
      onSaved: (value) {
        widget.onSaved?.call(_selected);
      },
      validator: widget.validator,
      builder: (formState) {
        return Column(
          children: [
            TimePicker(
              hourFormat: HourFormat.HH,
              minuteIncrement: 5,
              header: widget.header,
              selected: _selected,
              onChanged: (time) {
                time = time.stripDate();
                setState(() {
                  _selected = time;
                });
                widget.onChanged?.call(time);
              },
            ),
            if (formState.hasError)
              Text(
                formState.errorText ?? '',
                style: FluentTheme.of(context).typography.caption!.copyWith(
                      color: Colors.red,
                    ),
              ),
          ],
        );
      },
    );
  }
}

class FormDatePicker extends StatefulWidget {
  final String header;
  final DateTime? selected;
  final void Function(DateTime?)? onChanged;
  final void Function(DateTime?)? onSaved;
  final String? Function(DateTime?)? validator;
  final AutovalidateMode? autovalidateMode;

  const FormDatePicker({
    super.key,
    required this.header,
    required this.selected,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
  });

  @override
  State<FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<FormDatePicker> {
  late DateTime? _selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: _selected,
      autovalidateMode: widget.autovalidateMode,
      onSaved: (value) {
        widget.onSaved?.call(_selected);
      },
      validator: widget.validator,
      builder: (formState) {
        return Column(
          children: [
            DatePicker(
              header: widget.header,
              selected: _selected,
              onChanged: (date) {
                date = date.stripTime();
                setState(() {
                  _selected = date;
                });
                widget.onChanged?.call(date);
              },
            ),
            if (formState.hasError)
              Text(
                formState.errorText ?? '',
                style: FluentTheme.of(context).typography.caption!.copyWith(
                      color: Colors.red,
                    ),
              ),
          ],
        );
      },
    );
  }
}
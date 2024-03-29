import 'package:app_babershop/src/core/ui/constants.dart';
import 'package:flutter/material.dart';

class WeekDaysPanel extends StatelessWidget {
  final List<String>? enabledDays;

  final ValueChanged<String> onDayPressed;

  const WeekDaysPanel({
    super.key,
    required this.onDayPressed,
    this.enabledDays,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione os dias da semana',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 16,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonDay(
                  label: 'Seg',
                  onDayPressed: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Ter',
                  onDayPressed: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Qua',
                  onDayPressed: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Qui',
                  onDayPressed: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Sex',
                  onDayPressed: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Sab',
                  onDayPressed: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Dom',
                  onDayPressed: onDayPressed,
                  enabledDays: enabledDays,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ButtonDay extends StatefulWidget {
  final String label;
  final ValueChanged<String> onDayPressed;
  final List<String>? enabledDays;

  const ButtonDay({
    super.key,
    required this.label,
    required this.onDayPressed,
    this.enabledDays,
  });

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  var selected = false;
  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brown : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brown : ColorsConstants.grey;

    final ButtonDay(:enabledDays, :label) = widget;
    final disableDay = enabledDays != null && !enabledDays.contains(label);

    if (disableDay) {
      buttonColor = Colors.grey[400]!;
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: disableDay
            ? null
            : () {
                widget.onDayPressed(widget.label);
                setState(() {
                  selected = !selected;
                });
              },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 56,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: buttonBorderColor,
            ),
          ),
          child: Center(
            child: Text(widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                )),
          ),
        ),
      ),
    );
  }
}

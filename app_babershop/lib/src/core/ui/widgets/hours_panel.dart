import 'package:flutter/material.dart';

import '../constants.dart';

class HoursPanel extends StatefulWidget {
  final List<int>? enabledTimes;

  final int startTime;
  final int endTime;
  final ValueChanged<int> onHourPressed;
  final bool singleSelection;

  const HoursPanel({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enabledTimes,
  }) : singleSelection = false;

  const HoursPanel.singleSelection({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enabledTimes,
  }) : singleSelection = true;

  @override
  State<HoursPanel> createState() => _HoursPanelState();
}

class _HoursPanelState extends State<HoursPanel> {
  int? lastSetection;
  @override
  Widget build(BuildContext context) {
    final HoursPanel(:singleSelection) = widget;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione os horários de atendimento',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (int i = widget.startTime; i <= widget.endTime; i++)
              TimeButton(
                enabledTimes: widget.enabledTimes,
                label: '${i.toString().padLeft(2, '0')}:00 ',
                value: i,
                timeSelected: lastSetection,
                singleSelection: singleSelection,
                onPressed: (timeSelected) {
                  setState(() {
                    if (singleSelection) {
                      if (lastSetection == timeSelected) {
                        lastSetection = null;
                      } else {
                        lastSetection = timeSelected;
                      }
                    }
                  });
                  widget.onHourPressed(timeSelected);
                },
              ),
          ],
        )
      ],
    );
  }
}

class TimeButton extends StatefulWidget {
  final List<int>? enabledTimes;
  final String label;
  final int value;
  final ValueChanged<int> onPressed;
  final bool singleSelection;
  final int? timeSelected;

  const TimeButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.value,
    this.enabledTimes,
    required this.singleSelection,
    this.timeSelected,
  });

  @override
  State<TimeButton> createState() => _TimeButtonState();
}

class _TimeButtonState extends State<TimeButton> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final TimeButton(
      :value,
      :label,
      :enabledTimes,
      :onPressed,
      :singleSelection,
      :timeSelected
    ) = widget;

    if (singleSelection) {
      if (timeSelected != null && timeSelected == value) {
        selected = true;
      } else {
        selected = false;
      }
    }

    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brown : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brown : ColorsConstants.grey;

    final disabledTime = enabledTimes != null && !enabledTimes.contains(value);

    if (disabledTime) {
      buttonColor = Colors.grey[400]!;
    }
    return InkWell(
      onTap: disabledTime
          ? null
          : () {
              setState(() {
                onPressed(value);
                selected = !selected;
              });
            },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 64,
        height: 36,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: buttonBorderColor,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

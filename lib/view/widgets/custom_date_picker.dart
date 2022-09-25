import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utilities/style.dart';

class CustomDatePicker extends StatefulWidget {
  final String title;
  final double height;
  final Function selectDate;
  const CustomDatePicker({
    super.key,
    required this.title,
    required this.height,
    required this.selectDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }
      setState(() {
        // using state so that the UI will be rerendered when date is picked
        _selectedDate = pickedDate;
      });
      widget.selectDate(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: kTextStyle1(widget.height * 1.1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _presentDatePicker,
              child: Text(
                "Select Date",
                style: kTextStyle7(widget.height),
              ),
            ),
            // display the selected date

            Text(
              _selectedDate != null
                  ? DateFormat.yMMMd().format(_selectedDate!)
                  // _selectedDate!.toIso8601String()
                  : 'No date selected!',
              style: kTextStyle7(widget.height),
            ),
          ],
        )
      ],
    );
  }
}

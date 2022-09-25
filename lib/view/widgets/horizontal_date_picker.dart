import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../utilities/color.dart';
import 'package:provider/provider.dart';

import '../../view_model/tasks.dart';
import '../utilities/style.dart';

// ignore: must_be_immutable
class HorizontalDatePicker extends StatelessWidget {
  HorizontalDatePicker({Key? key}) : super(key: key);

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double height1 = MediaQuery.of(context).size.height;
    double width1 = MediaQuery.of(context).size.width;
    double height = height1 > width1 ? height1 : width1;
    double width = height1 > width1 ? width1 : height1;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: width * 0.025,
      ),
      child: Column(
        children: [
          DatePicker(
            DateTime.now(),
            height: height / 8,
            width: height / 12,
            initialSelectedDate: _selectedDate,
            selectionColor: kPinkColor,
            selectedTextColor: Colors.white,
            deactivatedColor: Colors.black,
            dateTextStyle: kTextStyle5(height),
            dayTextStyle: kTextStyle5(height),
            monthTextStyle: kTextStyle5(height),
            onDateChange: (date) {
              _selectedDate = date;
              Provider.of<Tasks>(context, listen: false).date = date;
              Provider.of<Tasks>(context, listen: false).getTasks();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../model/task_model.dart';
import '../utilities/color.dart';
import '../utilities/style.dart';

class TodoTile extends StatelessWidget {
  final TaskModel task;
  const TodoTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    double height1 = MediaQuery.of(context).size.height;
    double width1 = MediaQuery.of(context).size.width;
    double height = height1 > width1 ? height1 : width1;
    double width = height1 > width1 ? width1 : height1;
    return SizedBox(
      child: Card(
        margin: EdgeInsets.only(
          bottom: width * 0.02,
          left: width * 0.02,
          right: width * 0.02,
        ),
        color: task.isCompleted == 1 ? kPinkColor : kBlueColor,
        child: ListTile(
          // leading:
          //     Checkbox(value: task.isCompleted == 1, onChanged: (value) {}),
          title: Text(
            task.title.toUpperCase(),
            style: kTileStyle(height),
          ),
          subtitle: Text(
            task.note,
            style: kTileStyle1(height),
          ),
          trailing: Text(
            task.isCompleted == 1 ? "Completed" : "Not Completed",
            style: kTextStyle4(height),
          ),
        ),
      ),
    );
  }
}

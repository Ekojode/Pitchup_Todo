import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../screen/add_task__by_category_screen.dart';
import '../widgets/snack_bar.dart';
import 'package:provider/provider.dart';
import '../../model/task_model.dart';
import '../utilities/style.dart';
import 'package:intl/intl.dart';
import '../widgets/horizontal_date_picker.dart';
import '../widgets/custom_button.dart';
import '../../view_model/tasks.dart';
import '../utilities/color.dart';
import '../screen/add_task_screen.dart';
import '../widgets/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<Tasks>(context, listen: false).getTasks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Tasks tasks = Provider.of<Tasks>(context);
    List<TaskModel> taskList = tasks.taskList;
    double height1 = MediaQuery.of(context).size.height;
    double width1 = MediaQuery.of(context).size.width;
    double height = height1 > width1 ? height1 : width1;
    double width = height1 > width1 ? width1 : height1;
    List<TaskModel> pageList = [];

    Map<String, List<TaskModel>> pageMap = {};
    void pageAlgorithm() {
      for (int index = 0; index < taskList.length; index++) {
        if (taskList[index].date == DateFormat.yMd().format(tasks.date)) {
          pageList.add(taskList[index]);

          String key = taskList[index].category;
          if (pageMap.containsKey(key)) {
            List<TaskModel>? c = pageMap[key];
            c!.add(taskList[index]);
            pageMap[key] = c;
          } else {
            pageMap[key] = [taskList[index]];
          }
        }
      }
    }

    pageAlgorithm();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text(
          'MyPitchHub TODO',
          style: kTextStyle1(height),
        ),
        elevation: 0.5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: width * 0.02, right: width * 0.02, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(
                        DateTime.now(),
                      ),
                      style: kTextStyle2(height / 1.05),
                    ),
                    Text(
                      "Welcome!",
                      style: kTextStyle3(height),
                    ),
                  ],
                ),
              ],
            ),
          ),
          HorizontalDatePicker(),
          taskList.isEmpty
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Categories:",
                    style: kTextStyle1(height * 1.11),
                    textAlign: TextAlign.start,
                  ),
                ),
          taskList.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        "You have no tasks yet 😞, Click the button below to add a new task",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ExpandablePanel(
                        collapsed: ExpandableButton(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: width * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  pageMap.keys.elementAt(index),
                                  style: kTextStyle1(height),
                                ),
                                Icon(
                                  Icons.expand_more,
                                  size: height / 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ExpandableButton(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: width * 0.02,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      pageMap.keys.elementAt(index),
                                      style: kTextStyle1(height),
                                    ),
                                    Icon(
                                      Icons.expand_less,
                                      size: height / 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            for (int i = 0;
                                i <
                                    pageMap[pageMap.keys.elementAt(index)]!
                                        .length;
                                i++)
                              GestureDetector(
                                onTap: () {
                                  modalBottomSheet(
                                    context: context,
                                    category: pageMap[
                                            pageMap.keys.elementAt(index)]![i]
                                        .category,
                                    tasks: tasks,
                                    taskModel: pageMap[
                                        pageMap.keys.elementAt(index)]![i],
                                    height: height,
                                    pageMap: pageMap,
                                  );
                                },
                                child: TodoTile(
                                    task: pageMap[
                                        pageMap.keys.elementAt(index)]![i]),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: TextButton(
                                    child: Text(
                                      '+  Add a new task to this category',
                                      style: kTextStyle9(height * 1.05),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddTaskScreenByCategory(
                                                  category: pageMap.keys
                                                      .elementAt(index)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height / 30,
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: pageMap.length,
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPinkColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

delete(
    {required BuildContext context,
    required double height,
    required Tasks tasks,
    required TaskModel task}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text("Delete Task", style: kTextStyle4(height)),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  tasks.deleteTask(id: task.id);
                  //     Navigator.pop(context);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ))
          ],
        );
      });
}

modalBottomSheet({
  required context,
  required String category,
  required Tasks tasks,
  required Map<String, List<TaskModel>> pageMap,
  required TaskModel taskModel,
  required double height,
}) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: height / 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomButton1(
              title: 'Mark Task as Completed',
              onTap: () {
                int a = pageMap[category]!.indexOf(taskModel);
                if (taskModel.date != DateFormat.yMd().format(DateTime.now())) {
                  ShowSnackBar.showSnackBar(
                    'Not ${taskModel.date} yet',
                    height,
                  );
                } else {
                  if (a == 0) {
                    tasks.updateCompletedStatus(id: taskModel.id);
                  } else {
                    bool bar = true;
                    for (int i = 0; i < a; i++) {
                      if (pageMap[category]![i].isCompleted == 0) {
                        bar = false;
                        ShowSnackBar.showSnackBar(
                          'You have to complete previous task(s) in this category',
                          height,
                        );
                        break;
                      }
                    }
                    if (bar == true) {
                      tasks.updateCompletedStatus(id: taskModel.id);
                    }
                  }
                }

                Navigator.pop(context);
              },
              color: kPinkColor,
            ),
            CustomButton1(
              title: 'Delete Task',
              onTap: () {
                tasks.deleteTask(id: taskModel.id);
                Navigator.pop(context);
              },
              color: Colors.redAccent,
            ),
          ],
        ),
      );
    },
  );
}

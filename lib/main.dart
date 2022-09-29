import 'package:flutter/material.dart';
import 'package:pitch_todo/view/screen/auth_screen.dart';
import 'package:pitch_todo/view/screen/home_screen.dart';
import 'package:pitch_todo/view_model/auth.dart';
import 'package:provider/provider.dart';

import 'model/database/database_helper.dart';
import './view/widgets/snack_bar.dart';
import './view_model/tasks.dart';
//import './view/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, Tasks>(
            create: (context) => Tasks('', '', []),
            update: (context, auth, previous) =>
                Tasks(auth.token!, auth.userId!, previous!.taskList),
          )
        ],
        builder: (context, child) {
          return Consumer<Auth>(
            builder: (context, Auth auth, child) => MaterialApp(
              home: auth.isAuth ? const HomeScreen() : const AuthScreen(),
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: messengerKey,
            ),
          );
        });
  }
}

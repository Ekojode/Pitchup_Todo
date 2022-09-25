import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/database/database_helper.dart';
import './view/widgets/snack_bar.dart';
import './view_model/tasks.dart';
import './view/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Tasks(),
      child: MaterialApp(
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: messengerKey,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pitch_todo/view/screen/password_verify.dart';
import 'package:pitch_todo/view/widgets/custom_text_field.dart';
import 'package:pitch_todo/view/widgets/snack_bar.dart';
import 'package:provider/provider.dart';
import '../../view_model/auth.dart';

import '../utilities/color.dart';
import '../utilities/style.dart';

class PasswordResetRequest extends StatelessWidget {
  PasswordResetRequest({super.key});
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height1 = MediaQuery.of(context).size.height;
    double width1 = MediaQuery.of(context).size.width;
    double height = height1 > width1 ? height1 : width1;
    double width = height1 > width1 ? width1 : height1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Password Reset Request",
          style: kTextStyle1(height),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                title: "Email",
                controller: emailController,
                height: height,
                hintText: "Enter your email",
              ),
              SizedBox(
                height: height / 25,
              ),
              ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  passwordRecovery(context, height);
                },
                style: ElevatedButton.styleFrom(backgroundColor: kPinkColor),
                child: Text(
                  "Send Password Recovery Mail",
                  style: kTileStyle(height),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void passwordRecovery(context, double height) {
    if (emailController.text.trim().isEmpty) {
      ShowSnackBar.showSnackBar("Enter an email address", height);
    } else {
      final auth = Provider.of<Auth>(context, listen: false);
      auth.requestPasswordRecovery(emailController.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyPassword(),
        ),
      );
    }
  }
}

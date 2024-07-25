import 'package:flutter/material.dart';
// import 'package:uber_josh/views/rider_main_page.dart';
import 'package:kenorider_driver/common/colormanager.dart';
import 'package:kenorider_driver/common/textcontent.dart';
import 'package:kenorider_driver/common/styles.dart';
import 'package:kenorider_driver/services/api_servies.dart';
import 'package:kenorider_driver/view_models/driver_view_model.dart';
// import 'package:kenorider_driver/views/auth/passwordpage.dart';
// import 'package:kenorider_driver/views/auth/registerdonepage.dart';
import 'package:kenorider_driver/views/mainpage.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  final String loginMethod;
  PasswordPage({Key? key, required this.loginMethod}) : super(key: key);
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  bool isPasswordVisible = false;
  bool isFocused = false;
  bool isNext = false;

  @override
  void initState() {
    super.initState();
    passwordFocusNode.addListener(() {
      setState(() {
        isFocused = passwordFocusNode.hasFocus;
      });
    });

    passwordController.addListener(() {
      setState(() {
        isNext = passwordController.text.isNotEmpty;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(passwordFocusNode);
    });
  }

  void onForgotPasswordPressed() {}
  Future<void> onNextButtonPressed(BuildContext context) async {
    final driverViewModel = context.read<DriverViewModel>();
    driverViewModel.setPassword(passwordController.text);
    String? credential;
    if (widget.loginMethod == 'email') {
      credential = driverViewModel.driver.email;
    } else {
      credential = driverViewModel.driver.phoneNumber;
    }

    if (credential == null || credential.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email or phone number')),
      );
      return;
    }

    final result = await ApiService.loginDriver(
      credential,
      passwordController.text,
      widget.loginMethod,
    );

    if (result == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder defaultBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(20),
    );

    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide:
          BorderSide(color: ColorManager.button_mainuser_left_color, width: 1),
      borderRadius: BorderRadius.circular(20),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(Apptext.backIconImage),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              Apptext.passwordpagetitletext,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              focusNode: passwordFocusNode,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(
                  color: isFocused
                      ? ColorManager.button_login_background_color
                      : Colors.black,
                ),
                border: defaultBorder,
                focusedBorder: focusedBorder,
                suffixIcon: IconButton(
                  icon: Image.asset(
                    isPasswordVisible
                        ? 'assets/images/password_icon.png' // Change this to an 'eye' open icon if you have one
                        : 'assets/images/password_icon.png', // 'eye' closed icon
                  ),
                  padding: EdgeInsets.only(right: 15),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onForgotPasswordPressed,
                child: Text(
                  Apptext.forgotbuttontext,
                  style: TextStyle(
                    color: ColorManager.button_login_background_color,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Bottom Buttons
            // Padding(
            SizedBox(
              width: double
                  .infinity, // Make the button fill the width of the screen
              height: 50, // Set the fixed height of the button
              child: ElevatedButton(
                onPressed: () async {
                  await onNextButtonPressed(context);
                },
                style: continueButtonStyle(),
                child: Ink(
                  decoration: isNext
                      ? continueButtonGradientDecoration()
                      : nocontinueButtonGradientDecoration(),
                  child: Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        maxWidth: double.infinity, minHeight: 50),
                    child: Text(
                      Apptext.nextbuttontext,
                      style: continueButtonTextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

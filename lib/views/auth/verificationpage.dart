import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kenorider_driver/common/colormanager.dart';
import 'dart:ui';
import 'package:kenorider_driver/common/textcontent.dart';
import 'package:kenorider_driver/views/auth/passwordpage.dart';
import 'package:kenorider_driver/views/auth/registerhomepage.dart';

class Verificationpage extends StatefulWidget {
  final String phoneNumber;
  final String beforevalue;
  Verificationpage(
      {Key? key, required this.phoneNumber, required this.beforevalue})
      : super(key: key);

  @override
  _VerificationpageState createState() => _VerificationpageState();
}

class _VerificationpageState extends State<Verificationpage> {
  bool isCheckCode = false;
  late String enteredCode;
  final TextEditingController verificationController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;
  bool isLoading = false;

  int _start = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });

    verificationController.addListener(() {
      if (verificationController.text.length == 6) {
        setState(() {
          isLoading = true;
        });
        Future.delayed(Duration(seconds: 3), () {
          _onNextPage();
        });
      }
    });

    // Request focus for the text field when the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _onNextPage() {
    if (widget.beforevalue == "login") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PasswordPage(
                    loginMethod: "phone",
                  )));
    } else
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterHomePage()));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    verificationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void resendCode() {
    // Reset the timer
    setState(() {
      _start = 30;
    });
    startTimer();

    // Implement the resend code logic here
  }

  String formatAndSanitizePhoneNumber(String rawNumber) {
    String sanitizedNumber = rawNumber.replaceAll(RegExp(r'\D'), '');

    // Assuming the sanitized number is for US/Canada and should be 10 digits long
    if (sanitizedNumber.length != 10) {
      return 'Invalid phone number length'; // Handle as appropriate
    }

    // Split the number into its components
    String countryCode = '+1';
    String areaCode = sanitizedNumber.substring(0, 3);
    String prefix = sanitizedNumber.substring(3, 6);
    String lineNum = sanitizedNumber.substring(6);

    // Return the formatted phone number
    return '$countryCode ($areaCode) $prefix-$lineNum';
  }

  @override
  Widget build(BuildContext context) {
    String cleanPhoneNumber = formatAndSanitizePhoneNumber(widget.phoneNumber);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(Apptext.backIconImage),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Text(
            Apptext.verificationPageTitleText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24, // Set text to bold
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Apptext.verificationPageDescriptionText,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "$cleanPhoneNumber",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            "by ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "SMS Services",
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorManager.primary_color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: verificationController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: Apptext.verificationTextFieldLabeltext,
                    labelStyle: TextStyle(
                      color:
                          isFocused ? ColorManager.primary_color : Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: ColorManager.primary_color,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: ColorManager.primary_color,
                        width: 2.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 20),
                Spacer(),
                Center(
                  child: Text(
                    Apptext.receiveButtonText,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _start == 0 ? resendCode : null,
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: ColorManager.primary_50_color,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(
                            maxWidth: double.infinity, minHeight: 50),
                        child: Text(
                          _start > 0
                              ? 'Resend the Code in ($_start) s'
                              : 'Resend the Code',
                          style: TextStyle(
                            color: ColorManager.primary_color,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          if (isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

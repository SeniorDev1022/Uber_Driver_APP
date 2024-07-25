import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kenorider_driver/common/colormanager.dart';
import 'package:kenorider_driver/common/textcontent.dart';
import 'package:kenorider_driver/common/styles.dart';
import 'package:kenorider_driver/view_models/driver_view_model.dart';
import 'package:kenorider_driver/views/auth/verificationpage.dart';
import 'package:kenorider_driver/views/auth/emailaddresspage.dart';
import 'package:provider/provider.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'CA');
  String? errorMessage;
  bool isValid = false;
  bool showError = false;
  bool emptyError = false;
  String? emptyerrorMessage;

  void checkPhoneNumber(String value) {
    if (value.length == 10 && RegExp(r'^\d{10}$').hasMatch(value)) {
      setState(() {
        isValid = true;
        showError = false;
        emptyError = false;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Add listener to controller to handle phone number changes
    phoneNumberController.addListener(() {
      checkPhoneNumber(phoneNumberController.text);
    });
  }

  void onContinueButtonPressed() {
    if (isValid) {
      String numbers = phoneNumberController.text;
      context.read<DriverViewModel>().setPhoneNumber(numbers);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Verificationpage(
                  phoneNumber: numbers, beforevalue: "login")));
      // if(isGopage == "signup"){
      //   Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => PhoneOtpPage(phoneNumber: numbers, frompage: widget.frommain_value)));
      // } else{
      //   Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => PhoneOtpPage(phoneNumber: numbers, frompage: widget.frommain_value)));
      // }
    } else if (phoneNumberController.text.length == 0) {
      setState(() {
        emptyError = true;
        showError = false;
        emptyerrorMessage = 'Please enter your phone number!';
      });
    } else {
      setState(() {
        showError = true;
        emptyError = false;
        errorMessage =
            'Double-check the number for any missing or extra digits.';
      });
    }
  }

  void onWithMailButtonPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EmailAddressPage(beforePageValue: 'login')));
  }

  // void onWithMailButtonPressed(String isGopage) {
  //   print("email====>");
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => EmailAddressPage(beforePageValue: isGopage)));
  // }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration = InputDecoration(
      labelText: Apptext.phoneLabelText,
      labelStyle: TextStyle(
        color: Colors.black, // Set the initial label text color here
      ),
      floatingLabelStyle: TextStyle(
        color:
            ColorManager.primary_color, // Set the label text color when focused
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color:
              ColorManager.primary_color, // Set the focused border color here
          width: 1.0, // Set the border width if needed
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: showError || emptyError
              ? Colors.red
              : Colors.transparent, // Conditionally set the error border color
          width: 1.0, // Set the border width if needed
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: showError || emptyError
              ? Colors.red
              : Colors
                  .transparent, // Conditionally set the focused error border color
          width: 1.0, // Set the border width if needed
        ),
      ),
    );
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
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26, // Set text to bold
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              Apptext.loginDescriptionText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 20),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber value) {
                setState(() {
                  number = value;
                });
              },
              onInputValidated: (bool value) {
                print(value ? 'Valid' : 'Invalid');
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
                showFlags: true,
                leadingPadding: 16.0,
                trailingSpace: false,
                setSelectorButtonAsPrefixIcon: false,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: phoneNumberController,
              formatInput: false,
              maxLength:
                  15, // Limit overall length if no country code is considered
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputDecoration: inputDecoration,
              onSaved: (PhoneNumber value) {
                print('On Saved: $value');
              },
            ),
            if (showError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 140),
                child: Text(
                  errorMessage ?? '',
                  style: TextStyle(
                    color: Colors.red, // Set the error text color here
                    fontSize: 13,
                  ),
                ),
              ),
            if (emptyError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 140),
                child: Text(
                  emptyerrorMessage ?? '',
                  style: TextStyle(
                    color: Colors.red, // Set the error text color here
                    fontSize: 13,
                  ),
                ),
              ),
            SizedBox(height: 20),
            SizedBox(
              width: double
                  .infinity, // Make the button fill the width of the screen
              height: 50, // Set the fixed height of the button
              child: ElevatedButton(
                onPressed: () => onContinueButtonPressed(),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        ColorManager.dark_primary_color,
                        ColorManager.primary_color
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        maxWidth: double.infinity, minHeight: 50),
                    child: Text(
                      Apptext.continueButtonText,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical:
                      20.0), // Add some vertical space before and after the divider
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0), // Add space around the "or" text
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager
                      .primary_gery_color, // Background color of the button
                  foregroundColor: Colors.black, // Text and icon color
                  shape: RoundedRectangleBorder(
                    // Rounded Rectangle Border
                    borderRadius:
                        BorderRadius.circular(30), // Custom radius size
                  ),
                ),
                onPressed: () => onContinueButtonPressed(),
                icon: Image.asset(
                  Apptext.facebookIconImage, // The icon data
                  width: 20.0,
                  height: 20.0,
                ),
                // The icon data
                label: Text(Apptext.facebookButtontext,
                    style: TextStyle(fontSize: 18)), // The text label
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              width: double.infinity, // Make the button fill the width
              height: 50.0,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager
                      .primary_gery_color, // Background color of the button
                  foregroundColor: Colors.black, // Text and icon color
                  shape: RoundedRectangleBorder(
                    // Rounded Rectangle Border
                    borderRadius:
                        BorderRadius.circular(30), // Custom radius size
                  ),
                ),
                onPressed: () => onWithMailButtonPressed(),
                icon: Image.asset(
                  Apptext.mailIconImage, // The icon data
                  width: 20.0,
                  height: 20.0,
                ),
                // The icon data
                label: Text(Apptext.mailButtontext,
                    style: TextStyle(fontSize: 18)), // The text label
              ),
            ),
            Padding(
              padding:
                  dividerPadding(), // Add some vertical space before and after the divider
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: dividerStyle(),
                  ),
                  Padding(
                    padding:
                        dividerTextPadding(), // Add space around the "or" text
                    child: Text(
                      'or',
                      style: dividerTextStyle(),
                    ),
                  ),
                  Expanded(
                    child: dividerStyle(),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10), // Add padding around the container
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: ColorManager.primary_color,
                  ),
                  SizedBox(width: 8), // Spacing between the icon and text
                  Text(
                    Apptext.findAccountText,
                    style: TextStyle(
                        fontSize: 18, color: ColorManager.primary_color),
                  ),
                ],
              ),
            ),
            Text(
              Apptext.findAccountDecsription,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

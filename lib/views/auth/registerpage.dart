import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kenorider_driver/common/colormanager.dart';
import 'package:kenorider_driver/common/textcontent.dart';
import 'package:kenorider_driver/views/auth/verificationpage.dart';
import 'package:kenorider_driver/view_models/driver_view_model.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmFocusNode = FocusNode();

  PhoneNumber number = PhoneNumber(isoCode: 'CA');
  final List<String> cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix'
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedCity;
  bool isEmailFocused = false;
  bool isNameFocused = false;
  bool isPhoneFocused = false;
  bool isPasswordFocused = false;
  bool isConfirmFocused = false;
  bool isChecked = false;
  bool isFormValid = false;
  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      setState(() {
        isEmailFocused = emailFocusNode.hasFocus;
      });
    });

    nameFocusNode.addListener(() {
      setState(() {
        isNameFocused = nameFocusNode.hasFocus;
      });
    });

    phoneFocusNode.addListener(() {
      setState(() {
        isPhoneFocused = phoneFocusNode.hasFocus;
      });
    });

    passwordFocusNode.addListener(() {
      setState(() {
        isPasswordFocused = passwordFocusNode.hasFocus;
      });
    });

    confirmFocusNode.addListener(() {
      setState(() {
        isConfirmFocused = confirmFocusNode.hasFocus;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(emailFocusNode);
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  void _onPressedNextButton() {
    String numbers = phoneNumberController.text;
    context.read<DriverViewModel>().setEmail(emailController.text);
    context.read<DriverViewModel>().setFullName(nameController.text);
    context.read<DriverViewModel>().setPhoneNumber(phoneNumberController.text);
    context.read<DriverViewModel>().setPassword(passwordController.text);
    context
        .read<DriverViewModel>()
        .setPasswordConfirmation(confirmController.text);
    context.read<DriverViewModel>().setCity(selectedCity!);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Verificationpage(
                  phoneNumber: numbers,
                  beforevalue: "register",
                )));
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder defaultBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(20),
    );

    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ColorManager.primary_color, width: 1),
      borderRadius: BorderRadius.circular(20),
    );

    final OutlineInputBorder enabledInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(20),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Apptext.registerPageTitleText),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(Apptext.backIconImage),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: _validateForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about yourself.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                focusNode: emailFocusNode,
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: TextStyle(
                    color: isEmailFocused
                        ? ColorManager.primary_color
                        : Colors.black,
                  ),
                  hintText: 'name@example.com',
                  border: defaultBorder,
                  focusedBorder: focusedBorder,
                  enabledBorder: enabledInputBorder,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: passwordFocusNode,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            color: isPasswordFocused
                                ? ColorManager.primary_color
                                : Colors.black),
                        hintText: 'Input your password',
                        border: defaultBorder,
                        focusedBorder: focusedBorder,
                        enabledBorder: enabledInputBorder,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16), // Spacing between the two fields
                  Expanded(
                    child: TextFormField(
                      focusNode: confirmFocusNode,
                      controller: confirmController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                            color: isConfirmFocused
                                ? ColorManager.primary_color
                                : Colors.black),
                        hintText: 'Input your confirm password',
                        border: defaultBorder,
                        focusedBorder: focusedBorder,
                        enabledBorder: enabledInputBorder,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your confirm password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                focusNode: nameFocusNode,
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(
                    color: isNameFocused
                        ? ColorManager.primary_color
                        : Colors.black,
                  ),
                  hintText: 'Input your full name',
                  border: defaultBorder,
                  focusedBorder: focusedBorder,
                  enabledBorder: enabledInputBorder,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              InternationalPhoneNumberInput(
                focusNode: phoneFocusNode,
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
                maxLength: 15,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputDecoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(
                    color: ColorManager.primary_color,
                  ),
                  border: defaultBorder,
                  focusedBorder: focusedBorder,
                  enabledBorder: enabledInputBorder,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length != 10) {
                    return 'Phone number must be 10 digits long';
                  }
                  return null;
                },
                onSaved: (PhoneNumber value) {
                  print('On Saved: $value');
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                items: cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue ?? false;
                      });
                      _validateForm();
                    },
                    activeColor: ColorManager
                        .primary_color, // Customize the active color here
                    checkColor: Colors.white, // Customize the check color here
                  ),
                  Expanded(
                    child: Text(
                      'By proceeding, I agree that KenoRide can collect, use and disclose the information provided by me in accordance with the Privacy Policy and Terms & Condition.',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isChecked && isFormValid
                      ? () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Form is valid, proceed to the next step
                            // print("Form is valid and ready to proceed");
                            _onPressedNextButton();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor:
                        isChecked ? ColorManager.primary_color : Colors.grey,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isFormValid && isChecked
                            ? [
                                ColorManager.dark_primary_color,
                                ColorManager.primary_color
                              ]
                            : [
                                ColorManager.primary_10_color,
                                ColorManager.primary_10_color
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
                        Apptext.nextButtonText,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

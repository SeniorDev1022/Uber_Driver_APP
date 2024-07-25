import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kenorider_driver/common/colormanager.dart';
import 'package:kenorider_driver/common/textcontent.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenorider_driver/views/auth/getlicenceimagepage.dart';
import 'package:kenorider_driver/views/auth/registervehiclepage.dart';
import 'package:kenorider_driver/view_models/driver_view_model.dart';
import 'package:provider/provider.dart';

class RegisterLicencePage extends StatefulWidget {
  RegisterLicencePage(XFile? driverImage);

  @override
  _RegisterLicencePageState createState() => _RegisterLicencePageState();
}

class _RegisterLicencePageState extends State<RegisterLicencePage> {
  XFile? _driverImage;

  Future<void> _navigateToGetDriverImagePage() async {
    final XFile? image = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GetLicenceImagePage()),
    );

    if (image != null) {
      setState(() {
        _driverImage = image;
      });
    }
  }

  Future<void> _onPressedNextButton() async {
    final bytes = await _driverImage!.readAsBytes();
    final base64Image = base64Encode(bytes);
    context.read<DriverViewModel>().setLicenseVerification(base64Image);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RegisterVchiclePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          color: ColorManager.primary_color,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(130),
                            bottomRight: Radius.circular(130),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Container(
                              child: AppBar(
                                backgroundColor: Colors
                                    .transparent, // Make AppBar transparent
                                elevation: 0, // Remove AppBar shadow
                                leading: IconButton(
                                  icon: Image.asset(Apptext.backWhiteIconImage),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                title: Center(
                                  child: Text(
                                    Apptext.registerPageTitleText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                automaticallyImplyLeading: false,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                'assets/images/registration_back.png',
                                width: 300,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: Offset(0, -60),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20), // Adjust the border radius as needed
                      child: _driverImage == null
                          ? Image.asset(
                              Apptext
                                  .emptyLicenceImage, // Replace with your asset path
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_driverImage!.path),
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -60),
                    child: Text(
                      'Submit your',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -60),
                    child: Text(
                      'Driver Licence',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -40),
                    child: SizedBox(
                      width: 180,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: _navigateToGetDriverImagePage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: Colors.grey),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _driverImage == null ? 'Upload' : "Retake",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                  width: 8.0), // Space between text and icon
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      height: 50, // Set the fixed height of the button
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement save functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                                color: _driverImage == null
                                    ? ColorManager.primary_50_color
                                    : ColorManager.primary_color,
                                width: 2), // Set the border color and width
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: _driverImage == null
                                ? ColorManager.primary_50_color
                                : ColorManager.primary_color,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 50, // Set the fixed height of the button
                      child: ElevatedButton(
                        onPressed: () {
                          if (_driverImage != null) _onPressedNextButton();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary_10_color,
                          padding: EdgeInsets.zero, // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _driverImage == null
                            ? Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            : Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      ColorManager.dark_primary_color,
                                      ColorManager.primary_color,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

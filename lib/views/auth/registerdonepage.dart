import 'package:flutter/material.dart';
import 'package:kenorider_driver/common/colormanager.dart';
import 'package:kenorider_driver/common/textcontent.dart';
import 'package:kenorider_driver/views/auth/loginpage.dart';

class RegisterDonePage extends StatefulWidget {
  @override
  _RegisterDonePageState createState() => _RegisterDonePageState();
}

class _RegisterDonePageState extends State<RegisterDonePage> {
  @override
  void initState() {
    super.initState();
    
  }

  void _onPressedDoneButton () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Loginpage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 110),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                    width: 250,
                    height: 250,
                    color: Colors.grey[200],
                    child: Image.asset(Apptext.registerDoneImage),
                  )
            ),
            SizedBox(height: 20),
            Text(
              'Registration Completed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Congratulatoins! You just registered as a",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54
              ),
            ),
            Text(
              "Driver just now.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity, // Make the button fill the width of the screen
              height: 50, // Set the fixed height of the button
              child: ElevatedButton(
                onPressed: _onPressedDoneButton,
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
                    constraints: BoxConstraints(maxWidth: double.infinity, minHeight: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Let the journey begin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
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
    );
  }
}

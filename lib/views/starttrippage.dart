import 'package:flutter/material.dart';
import 'package:kenorider_driver/common/colormanager.dart';
import 'package:kenorider_driver/view_models/request_view_model.dart';
import 'package:kenorider_driver/views/arriveddestinationpage.dart';
import 'package:provider/provider.dart';


class StartTripPage extends StatefulWidget {
  @override
  _StartTripPageState createState() => _StartTripPageState();
}

class _StartTripPageState extends State<StartTripPage> {

  void _onPressedTripButton() async{
    final response = await context.read<RequestViewModel>().tripRequest();
    if(response == 200) {
     Navigator.push(context, MaterialPageRoute(builder: (context) => ArriveDestinationPage()));
    } else if (response == 404) {
      print("This is not found request");
    } else {
      print('Internal server error');
    }
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/car_with_rider.png', // Replace with your actual asset path
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),
            const Text(
              'You arrived at the Pickup Point!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Make sure the rider is inside the vehicle and then you can start the trip.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onPressedTripButton,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
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
                        ColorManager.primary_color,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(
                      maxHeight: 50,
                      minHeight: 50,
                      maxWidth: double.infinity,
                    ),
                    child: const Text(
                      'Start the Trip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

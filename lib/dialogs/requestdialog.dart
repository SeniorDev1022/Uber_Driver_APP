import 'package:flutter/material.dart';
import 'package:kenorider_driver/common/Global_variable.dart';
// import 'package:kenorider_driver/view_models/driver_view_model.dart';
import 'package:kenorider_driver/view_models/request_view_model.dart';
import 'package:kenorider_driver/views/arrivedpickuppage.dart';
import 'package:provider/provider.dart';
class RideRequestDialog extends StatefulWidget {
  const RideRequestDialog({super.key});

  @override
  _RideRequestDialogState createState() => _RideRequestDialogState();
}

class _RideRequestDialogState extends State<RideRequestDialog> {

void _onRequestPress(BuildContext context) async {
  final response = await context.read<RequestViewModel>().acceptRequest();
  if(response == 200) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArrivePickupPointPage()),
        );    
  } else if (response == 404) {
    print("This is not found request");
  } else {
    print('Internal server error');
  }
  }

  @override
  Widget build(BuildContext context) {
    final requestmodel = Provider.of<RequestViewModel>(context);
    String? period = requestmodel.request.period;
    String? start = requestmodel.request.startLocation;
    String? end = requestmodel.request.endLocation;
    String? cost = requestmodel.request.cost;
    String? riderName = requestmodel.request.riderName;
    double? rating = requestmodel.request.rating;
    String? distance = requestmodel.request.distance;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ride Request!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '\$$cost',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow),
                    Text('$rating',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Estimated time: $period',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Distance: $distance',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '$riderName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'From',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '$start',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.pink),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'To',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '$end',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      GlobalVariables.flag = false;
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                    child: const Text('Decline',style: TextStyle(
                                    color:Colors.black,
                                    fontSize: 16,
                                  ),),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _onRequestPress(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Color.fromARGB(255, 63, 140, 157),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                    child: const Text('Accept',  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

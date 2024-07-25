import 'package:flutter/material.dart';
import 'package:kenorider_driver/common/textcontent.dart';
import 'models/earningmodel.dart';


class EarningHistoryPage extends StatefulWidget {
  @override
  _EarningHistoryPageState createState() => _EarningHistoryPageState();
}

class _EarningHistoryPageState extends State<EarningHistoryPage> {

  List<Earning> earnings = [
  Earning(
    from: "Spe Ornamental Corp",
    to: "Miami Senior High School",
    date: "8 Jun 2024",
    time: "15:42",
    amount: 12.08,
  ),
  Earning(
    from: "Miami Senior High School",
    to: "Bayside Marketplace",
    date: "8 Jun 2024",
    time: "12:35",
    amount: 27.82,
  ),
  Earning(
    from: "Miami Design District",
    to: "Spe Ornamental Corp",
    date: "8 Jun 2024",
    time: "09:57",
    amount: 20.65,
  ),
];

  @override
  Widget build(BuildContext context) {
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
            Apptext.earningHistoryPageTitleText,
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 26,// Set text to bold
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Colors.grey, width: 0.5)
              ),
              elevation: 5,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Apptext.totalEarningText,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '\$60.55',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: earnings.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust padding as needed
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Apptext.carIconImage, width: 44, height: 44),
                        SizedBox(width: 10), // Space between icon and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${earnings[index].from} ',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: 'to ',
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '${earnings[index].to}',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4), // Space between title and subtitle
                              Text(
                                '${earnings[index].date} - ${earnings[index].time}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                           SizedBox(height: 35,), 
                            Text(
                              '\$${earnings[index].amount.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ) // Space between text and trailing
                        
                      ],
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

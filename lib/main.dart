import 'package:flutter/material.dart';
import 'package:kenorider_driver/view_models/request_view_model.dart';
import 'firebase_options.dart';
import 'package:kenorider_driver/views/splashpage.dart';
import 'package:kenorider_driver/view_models/driver_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:kenorider_driver/common/Global_variable.dart';
// import 'package:localstorage/localstorage.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();    
  await Firebase.initializeApp();
  

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print("User granted permission: ${settings.authorizationStatus}");
  final fcmToken = await messaging.getToken();
  print("fcm=>$fcmToken");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DriverViewModel()),
        ChangeNotifierProvider(create: (_) => RequestViewModel()), // Add RequestModel
      ],
      child: MyApp(fcmToken: fcmToken),
    ),
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');

      final driverViewModel = navigatorKey.currentContext!.read<DriverViewModel>();
      
      final requestModel = navigatorKey.currentContext!.read<RequestViewModel>();
      if(message.data.containsKey("decline")){
        GlobalVariables.flag = false;
      }
      if(GlobalVariables.flag == false){
        GlobalVariables.flag = true;
      requestModel.setData(message.data);
      if(message.data.containsKey("riderLat")){
        GlobalVariables.riderLat = double.parse(message.data['riderLat']);
      }
      if(message.data.containsKey("riderLng")){
        GlobalVariables.riderLng = double.parse(message.data['riderLng']);
      }
      if(message.data.containsKey("desLat")){
        GlobalVariables.desLat = double.parse(message.data['desLat']);
      }
      if(message.data.containsKey("desLng")){
        GlobalVariables.desLng = double.parse(message.data['desLng']);
      }
      driverViewModel.setFlag(true);
    }
      print(message.data);
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final String? fcmToken;
  MyApp({this.fcmToken});

  @override
  Widget build(BuildContext context) {
    if (fcmToken != null) {
      GlobalVariables.deviceToken = fcmToken;
    }
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: SplashScreen(), // Set HomePage as the initial screen
    );
  }
}
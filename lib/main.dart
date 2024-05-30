import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:v_doctor/Screen/SplashScreen/SplashScreen.dart';
import 'package:v_doctor/apikeys/apikeys.dart';
import 'package:v_doctor/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = APIKey.PUBLISHABLEkEY;
  Stripe.instance.applySettings();
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: 'AIzaSyDX_7yYCIu6lOpi1h9JZBoV2v76d-xpaQ0',
  //         appId: '1:244263962418:android:fd6f25009884f03140792b',
  //         messagingSenderId: '244263962418',
  //         projectId: 'vdoctor-a4ce1',
  //         storageBucket: 'vdoctor-a4ce1.appspot.com'));

  // await FirebaseAPI().initNotification();
  // await Firebase.initializeApp();
  // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // await dotenv.load(fileName: ".env");
  // Stripe.publishableKey=dotenv.env["STRIPE_PUBLISHABLE_KEY"]!;
  // await Stripe.instance.applySettings();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: ColorConstants.primaryColor));
  runApp(const MyApp());
}

void getFCMToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();

  print("FCM Token: $fcmToken ");
}

Future<void> initializeFirebase() async {
  Firebase.initializeApp().whenComplete(() {
    print("FirebaseinitializeApp-completed");
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    getFCMToken();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: false,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

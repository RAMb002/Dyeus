import 'package:dyeus/view/screens/otp_screen/otp_screen.dart';
import 'package:dyeus/view/screens/welcome_screen/AuthScreen.dart';
import 'package:dyeus/view/screens/welcome_screen/welcome_screen.dart';
import 'package:dyeus/view_model/provider/authenticiation_message.dart';
import 'package:dyeus/view_model/provider/loading.dart';
import 'package:dyeus/view_model/provider/phone_authentication.dart';
import 'package:dyeus/view_model/provider/resend_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>PhoneAuthenticationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>AuthenticationMessageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>LoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>ResendOtpProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Dyeus',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthScreen(),
        // home: OtpScreen(),
      ),
    );
  }
}


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit_app/providers/current_variable_provider.dart';
import 'package:rentit_app/providers/customer_provider.dart';
import 'package:rentit_app/providers/driver_provider.dart';
import 'package:rentit_app/providers/payment_provider.dart';
import 'package:rentit_app/providers/terminal_provider.dart';
import 'package:rentit_app/providers/trip_post_provider.dart';
import 'package:rentit_app/providers/trip_provider.dart';
import 'package:rentit_app/providers/vehicle_provider.dart';
import 'package:rentit_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => DriverProvider(),
      ),
        ChangeNotifierProvider(
        create: (context) => CustomerProvider(),
        ),

      ChangeNotifierProvider(
        create: (context) => TerminalProvider(),
      ),

      ChangeNotifierProvider(
        create: (context) => VehicleProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => TripProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => CurrentVariable(),
      ),
      ChangeNotifierProvider(
        create: (context) => TripPostProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => PaymentProvider(),
      )
    ],

        child:
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ));

  }
}



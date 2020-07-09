import 'package:flutter/material.dart';

import '../main.dart';
import '../front_end/dashboard.dart';
import 'patient_functionality/patient.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyApp());
      case '/patient':
        // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => PatientPage(
              data: args,
            ),
          );
        }
        return _errorRoute();

      case '/dashboard':
        // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => DashboardPage(
              data: args,
            ),
          );
        }

        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

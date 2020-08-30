import 'package:Pathomatic/camera_screen.dart';
import 'package:Pathomatic/front_end/info.dart';
import 'package:Pathomatic/screens/detect_screen.dart';
import 'package:flutter/material.dart';
import 'package:Pathomatic/front_end/home.dart';
import 'package:camera/camera.dart';
import './image_stitching/stitch.dart';

import '../main.dart';
import '../front_end/dashboard.dart';

List<CameraDescription> cameras;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyApp());
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

      case '/homepage':
        // Validation of correct data type
        cameraPage();
        return MaterialPageRoute(
          builder: (_) => HomePage(cameras),
        );

      case '/stichpage':
        // Validation of correct data type
        return MaterialPageRoute(
          builder: (_) => ImagesScreen(),
        );

      case '/camerapage':
        // Validation of correct data type
        return MaterialPageRoute(
          builder: (_) => CameraScreen(),
        );
        
      case '/detect':
        // Validation of correct data type
        return MaterialPageRoute(
          builder: (_) => DetectScreen(
              title: args,
          ),
        );

      case '/patientidentifier':
        // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => PatientIdentifier(
              data: args,
            ),
          );
        }
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

Future<Null> cameraPage() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
}

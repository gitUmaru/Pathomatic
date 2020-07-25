import 'package:Pathomatic/front_end/home.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'front_end/welcome.dart';
import 'back_end/route_generator.dart';

List<CameraDescription> cameras;

// Future<Null> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     cameras = await availableCameras();
//   } on CameraException catch (e) {
//     print('Error: $e.code\nError Message: $e.message');
//   }
//   runApp(new MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'tflite real-time detection',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//       ),
//       home: HomePage(cameras),
//     );
//   }
// }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathomatic',
      home: WelcomePage(),
      // Initially display WelcomePage
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

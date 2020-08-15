import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'front_end/welcome.dart';
import 'back_end/route_generator.dart';
import 'package:flutter/widgets.dart';

List<CameraDescription> cameras;

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

import 'package:flutter/material.dart';
import './camera_screen.dart';

import 'front_end/welcome.dart';
import 'back_end/route_generator.dart';

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

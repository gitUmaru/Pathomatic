import 'package:flutter/material.dart';

import './welcome.dart';
import './route_generator.dart';

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

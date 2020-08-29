import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'front_end/welcome.dart';
import 'back_end/route_generator.dart';
import 'package:flutter/widgets.dart';

List<CameraDescription> cameras;

void main() => runApp(Phoenix(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/images/background.png"), context);
    precacheImage(AssetImage("assets/images/InitialLogo.png"), context);
    precacheImage(AssetImage("assets/images/crosshair.png"), context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pathomatic',
      home: WelcomePage(),
      // Initially display WelcomePage
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
import 'package:Pathomatic/back_end/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../back_end/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import '../back_end/globals.dart' as globals;

import '../back_end/bndbox.dart';
import '../back_end/models.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;
    switch (globals.model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/model_unquant.tflite",
          labels: "assets/labels.txt",
        );
        break;

      case mobilenet:
        res = await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt");
        break;

      case posenet:
        res = await Tflite.loadModel(
            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
        break;

      default:
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      globals.model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: globals.model == ""
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('4x Magnification'),
                    onPressed: () => onSelect(ssd),
                  ),
                  RaisedButton(
                    child: const Text('10x Magnification'),
                    onPressed: () => onSelect(ssd),
                  ),
                  RaisedButton(
                    child: const Text('25x Magnification'),
                    onPressed: () => onSelect(mobilenet),
                  ),
                  RaisedButton(
                    child: const Text('40x Magnification'),
                    onPressed: () => onSelect(posenet),
                  ),
                  RaisedButton(
                    child: const Text('63x Magnification'),
                    onPressed: () => onSelect(mobilenet),
                  ),
                   RaisedButton(
                    child: const Text('Home'),
                    onPressed: (){
                      Navigator.of(context).pushNamed(
                        '/dashboard',
                        arguments: globals.name.text,
                      );
                    },
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  globals.model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    globals.model),
              ],
            ),
    );
  }
}

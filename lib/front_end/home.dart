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
          model: "assets/detect.tflite",
          labels: "assets/detect.txt",
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
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: globals.model == ""
            ? Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                    child: Text(
                      "Select a magnification:",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Text(""),
                        RaisedButton(
                          textColor: Colors.white,
                          color: Colors.black,
                          child: Text("4x"),
                          onPressed: () {
                            onSelect(yolo);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        RaisedButton(
                          textColor: Colors.white,
                          color: Colors.black,
                          child: Text("10x"),
                          onPressed: () {
                            onSelect(ssd);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        RaisedButton(
                          textColor: Colors.white,
                          color: Colors.black,
                          child: Text("25x"),
                          onPressed: () {
                            onSelect(mobilenet);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        RaisedButton(
                          textColor: Colors.white,
                          color: Colors.black,
                          child: Text("40x"),
                          onPressed: () {
                            onSelect(posenet);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        RaisedButton(
                          textColor: Colors.white,
                          color: Colors.black,
                          child: Text("63x"),
                          onPressed: () {
                            onSelect(mobilenet);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        Text(""),
                        Text(""),
                        Text(""),
                        Text(""),
                        IconButton(
                          iconSize: 50,
                          icon: Icon(Icons.home),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/dashboard',
                              arguments: globals.name.text,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
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
      ),
    );
  }
}

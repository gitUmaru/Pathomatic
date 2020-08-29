import 'package:Pathomatic/front_end/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import '../back_end/globals.dart' as globals;

import 'models.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;

  Camera(this.cameras, this.model, this.setRecognitions);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  double xPosition = 120;
  double yPosition = 150;

  List cameras;
  int selectedCameraIdx;
  String imagePath;
  String selectedChoice3;

  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      print(widget.cameras);
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;

            int startTime = new DateTime.now().millisecondsSinceEpoch;

            if (widget.model == mobilenet) {
              Tflite.runModelOnFrame(
                bytesList: img.planes.map((plane) {
                  return plane.bytes;
                }).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 2,
              ).then((recognitions) {
                int endTime = new DateTime.now().millisecondsSinceEpoch;
                print("Detection took ${endTime - startTime}");

                widget.setRecognitions(recognitions, img.height, img.width);

                isDetecting = false;
              });
            } else if (widget.model == posenet) {
              Tflite.runPoseNetOnFrame(
                bytesList: img.planes.map((plane) {
                  return plane.bytes;
                }).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 2,
              ).then((recognitions) {
                int endTime = new DateTime.now().millisecondsSinceEpoch;
                print("Detection took ${endTime - startTime}");

                widget.setRecognitions(recognitions, img.height, img.width);

                isDetecting = false;
              });
            } else {
              Tflite.detectObjectOnFrame(
                bytesList: img.planes.map((plane) {
                  return plane.bytes;
                }).toList(),
                model: widget.model == yolo ? "YOLO" : "SSDMobileNet",
                imageHeight: img.height,
                imageWidth: img.width,
                imageMean: widget.model == yolo ? 0 : 127.5,
                imageStd: widget.model == yolo ? 255.0 : 127.5,
                numResultsPerClass: 1,
                threshold: widget.model == yolo ? 0.2 : 0.4,
              ).then((recognitions) {
                int endTime = new DateTime.now().millisecondsSinceEpoch;
                print("Detection took ${endTime - startTime}");

                widget.setRecognitions(recognitions, img.height, img.width);

                isDetecting = false;
              });
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    // var tmp = MediaQuery.of(context).size;
    // var screenH = math.max(tmp.height, tmp.width);
    // var screenW = math.min(tmp.height, tmp.width);
    // tmp = controller.value.previewSize;
    // var previewH = math.max(tmp.height, tmp.width);
    // var previewW = math.min(tmp.height, tmp.width);
    // var screenRatio = screenH / screenW;
    // var previewRatio = previewH / previewW;

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // appBar: AppBar(
        //     backgroundColor: Colors.lightBlue,
        //     centerTitle: true,
        //     elevation: 5,
        //     title: Text("Pathomatic")),
        body: Container(
          decoration: new BoxDecoration(color: Colors.black),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: new Stack(
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.center,
                        child: _cameraPreviewWidget(context),
                      ),
                      new Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                            child: Stack(children: <Widget>[
                              Positioned(
                                top: yPosition,
                                left: xPosition,
                                child: Container(
                                  //padding: EdgeInsets.only(top: 200.0, left: 120.0),
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Image.asset(
                                      'assets/images/crosshair.png'),
                                ),
                              ),
                            ]),
                            onPanUpdate: (tapInfo) {
                              setState(() {
                                xPosition += tapInfo.delta.dx;
                                yPosition += tapInfo.delta.dy;
                              });
                            }),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            color: Colors.white,
                            onPressed: () {
                              //  DashboardPage(data: "none");
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new DashboardPage(
                                          data: globals.name.text)));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _mlTextWidget(),
                      ],
                    ),
                    _captureControlRowWidget(context),
                    SizedBox(width: 50),
                  ],
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget(context) {
    final size = MediaQuery.of(context).size;

    if (!controller.value.isInitialized) {
      return Container();
    }

    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: controller.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures

  Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
                child: Icon(Icons.arrow_forward),
                backgroundColor: Colors.lightBlue,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                '/camerapage',
              );
                })
          ],
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).

  Widget _mlTextWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
        // child: (Text("${globals.model}",  // TODO: replace the line below with this once model variable shortened
        child: (Text("4x",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ))));
  }

}

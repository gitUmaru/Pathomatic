import 'package:camera/camera.dart';

import 'package:flutter/material.dart';

import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';

import './preview_screen.dart';

import './back_end/constants.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State {
  double xPosition = 120;
  double yPosition = 150;

  String selectedChoice3;

  CameraController controller;

  List cameras;

  int selectedCameraIdx;

  String imagePath;

  @override
  void initState() {
    super.initState();

    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 5,
          title: Text("Pathomatic")),
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
                                // padding: EdgeInsets.only(top: 200.0, left: 20.0),
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width / 3,
                                child:
                                    Image.asset('assets/images/crosshair.png'),
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
                  ],
                ),
              ),
              SizedBox(height: 5),
              Align(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _cameraTogglesRowWidget(),
                        _mlTextWidget(),
                      ],
                    ),
                    _captureControlRowWidget(context),
                    SizedBox(width: 50),
                  ],
                ),
                alignment: Alignment.center,
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  /// Display Camera preview.

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
                child: Icon(Icons.camera_alt),
                backgroundColor: Colors.lightBlue,
                onPressed: () {
                  _onCapturePressed(context);
                })
          ],
        ),
      ),
    );
  }

  Widget _cameraTogglesRowWidget() {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.zoom_in,
        color: Colors.white,
        size: 30,
      ),
      onSelected: choiceAction3,
      itemBuilder: (BuildContext context) {
        return MLConstants.choices3.map((String choice3) {
          return PopupMenuItem<String>(
            value: choice3,
            child: Text(choice3),
          );
        }).toList();
      },
    );
  }

  void choiceAction3(String choice3) {
    setState(() {
      selectedChoice3 = choice3;
    });
    if (choice3 == MLConstants.FourX) {
      print('4x');
    } else if (choice3 == MLConstants.TenX) {
      print('10x');
    } else if (choice3 == MLConstants.TwentyFiveX) {
      print('25x');
    } else if (choice3 == MLConstants.FourtyX) {
      print('40x');
    } else if (choice3 == MLConstants.SixtyThreeX) {
      print('63x');
    }
  }

  Widget _mlTextWidget() {
    return Container(
        child: (Text("${selectedChoice3 ?? ''}",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ))));
  }

  void _onCapturePressed(context) async {
    // Take the Picture in a try / catch block. If anything goes wrong,

    // catch the error.

    try {
      // Attempt to take a picture and log where it's been saved

      final path = join(
        // In this example, store the picture in the temp directory. Find

        // the temp directory using the `path_provider` plugin.

        (await getTemporaryDirectory()).path,

        '${DateTime.now()}.png',
      );

      print(path);

      await controller.takePicture(path);

      // If the picture was taken, display it on a new screen

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewImageScreen(imagePath: path),
        ),
      );
    } catch (e) {
      // If an error occurs, log the error to the console.

      print(e);
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';

    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }
}

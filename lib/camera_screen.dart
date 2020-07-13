import 'package:camera/camera.dart';

import 'package:flutter/material.dart';

import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';

import './preview_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State {
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
                      child: new Container(
                        padding: 50,
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Image.asset('assets/images/crosshair.png'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cameraTogglesRowWidget(),
                  _captureControlRowWidget(context),
                  Spacer()
                ],
              ),
              SizedBox(height: 10.0)
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

  /// Display a row of toggle to select the camera (or a message if no camera is available).

  Widget _cameraTogglesRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: _onSwitchCamera,
            icon: Icon(_getCameraLensIcon(lensDirection), color: Colors.white),
            label: Text(
              "${lensDirection.toString().toUpperCase().substring(lensDirection.toString().indexOf('.') + 1)}",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;

      case CameraLensDirection.front:
        return Icons.camera_front;

      case CameraLensDirection.external:
        return Icons.camera;

      default:
        return Icons.device_unknown;
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;

    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _initCameraController(selectedCamera);
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

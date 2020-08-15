import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PreviewImageScreen extends StatefulWidget {
  final String imagePath;

  PreviewImageScreen({this.imagePath});

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        decoration: new BoxDecoration(color: Colors.black),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Image.file(File(widget.imagePath), fit: BoxFit.cover)),
              SizedBox(height: 5),
              Flexible(
                flex: 0,
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: SizedBox(
                            width: 110,
                            height: 40,
                            child: FloatingActionButton.extended(
                              heroTag: "btn2",
                              onPressed: () {
                                getBytesFromFile().then((bytes) {
                                  Share.file(
                                      'Share via:',
                                      basename(widget.imagePath),
                                      bytes.buffer.asUint8List(),
                                      'image/png');
                                });
                              },
                              label: Text('Share'),
                              icon: Icon(Icons.share),
                              backgroundColor: Colors.lightBlue,
                            ),
                          ),
                        ),
                        Uploader(file: File(widget.imagePath)),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imagePath).readAsBytesSync() as Uint8List;

    return ByteData.view(bytes.buffer);
  }
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://aipmocpathomatic.appspot.com');

  StorageUploadTask _uploadTask;

  /// Starts an upload task
  void _startUpload() {
    /// Unique file name for the file
    String filePath =
        'images/${DateTime.now()}.png'; // TODO: Change this to patient id

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: [
                if (_uploadTask.isComplete)
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text(
                      'Complete',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow, color: Colors.white),
                    onPressed: _uploadTask.resume,
                  ),

                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause, color: Colors.white),
                    onPressed: _uploadTask.pause,
                  ),

                // Progress bar
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                  child: LinearProgressIndicator(value: progressPercent),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    10,
                    0,
                    0,
                  ),
                  child: Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return SizedBox(
        height: 40,
        width: 120,
        child: FloatingActionButton.extended(
          heroTag: "btn1",
          label: Text('Upload'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload,
          backgroundColor: Colors.lightBlue,
        ),
      );
    }
  }
}

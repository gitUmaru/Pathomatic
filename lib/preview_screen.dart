import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

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
                    padding: EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        getBytesFromFile().then((bytes) {
                          Share.file('Share via:', basename(widget.imagePath),
                              bytes.buffer.asUint8List(), 'image/png');
                        });
                      },
                      label: Text('Share'),
                      icon: Icon(Icons.share),
                      backgroundColor: Colors.lightBlue,
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

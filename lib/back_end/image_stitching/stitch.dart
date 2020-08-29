import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:typed_data';
import 'dataholder.dart';
import '../globals.dart' as globals;

class ImagesScreen extends StatelessWidget with RouteAware {
  Widget makeImagesGrid() {
    return GridView.builder(
        itemCount: 12,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return ImageGridItem(index);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 5,
        title: Text('Image Stitching'),
        centerTitle: true,
      ),
      body: Container(
        child: makeImagesGrid(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        child: Row(
          children: [
            Spacer(),
            IconButton(icon: Icon(Icons.save), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        onPressed: () {
          _sendEmail(context);
        },
        icon: Icon(Icons.burst_mode),
        label: Text('Stitch'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// ignore: must_be_immutable
class ImageGridItem extends StatefulWidget {
  int _index;

  ImageGridItem(int index) {
    this._index = index;
  }

  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> with RouteAware {
  Uint8List imageFile;
  StorageReference photosReference =
      FirebaseStorage.instance.ref().child("images");

  getImage() {
    if (!requestedIndexes.contains(widget._index)) {
      int maxSize = 7 * 1024 * 1024;
      photosReference
          .child(
              '${globals.patientID.text}${globals.model}${widget._index}.png')
          .getData(maxSize)
          .then((data) {
        this.setState(() {
          imageFile = data;
        });
        imageData.putIfAbsent(widget._index, () {
          return data;
        });
      }).catchError((error) {
        debugPrint(error.toString());
      });
      requestedIndexes.add(widget._index);
    }
  }

  Widget decideGridTileWidget() {
    if (imageFile == null) {
      return Center(child: Text(""));
    } else {
      return Image.memory(
        imageFile,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (!imageData.containsKey(widget._index)) {
      getImage();
    } else {
      this.setState(() {
        imageFile = imageData[widget._index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(child: decideGridTileWidget());
  }
}

Future<void> _sendEmail(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Are you sure you want to stich these images?'),
        content: Text(
          'An email will be sent that starts the process of stitching all your images at your lowest magnification.',
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              'Don\'t Allow',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              'Allow',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              sendEmail();
            },
          ),
        ],
      );
    },
  );
}

Future<Null> sendEmail() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Email email = Email(
    body:
        "<root><patientID>${globals.patientID.text}</patientID><counter>${globals.noImages}</counter><model>${globals.model}</model><name>${globals.name.text}</name><email>${globals.email.text}</email><hospital>${globals.hospital.text}</hospital></root>",
    subject: 'IMAGE STITCHING REQUEST',
    recipients: ['pathomaticapp@gmail.com'],
    isHTML: false,
  );

  await FlutterEmailSender.send(email);
}

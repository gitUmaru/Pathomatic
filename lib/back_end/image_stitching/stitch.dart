import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'dataholder.dart';

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
        onPressed: () {},
        icon: Icon(Icons.burst_mode),
        label: Text('Stitch'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

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
          .child("cell${widget._index}.png")
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

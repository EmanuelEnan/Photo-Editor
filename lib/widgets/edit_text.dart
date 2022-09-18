import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor/widgets/default_button.dart';
import 'package:photo_editor/utils/shape_info.dart';
import 'package:photo_editor/utils/text_info.dart';
import 'package:photo_editor/utils/utils.dart';
import 'package:screenshot/screenshot.dart';

import '../screens/home-page.dart';

abstract class EditText extends State<MyHomePage> {
  TextEditingController editController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  

  List<TextInfo> texts = [];
  int currentIndex = 0;
  List<ShapeInfo> icons = [];
  double opaPic = 1;

  // double val = ${opaPic + 1};

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'text removed!',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

   removeShape(BuildContext context) {
    setState(() {
      icons.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'shape removed!',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  saveToGallery(BuildContext context) {
    if (texts.isNotEmpty) {
      screenshotController.capture().then((Uint8List? image) {
        saveImage(image!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to gallery.'),
          ),
        );
      }).catchError((err) => print(err));
    }
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Selected For Styling',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  increaseSizeShape() {
    setState(() {
      icons[currentIndex].size += 10;
    });
  }

  decreaseSizeShape() {
    setState(() {
      icons[currentIndex].size -= 10;
    });
  }

  opachange() {
    setState(() {
      icons[currentIndex].color = Colors.red.withOpacity(opaPic);
    });
  }

  addNewText(BuildContext context) {
    setState(() {
      texts.add(
        TextInfo(
          text: editController.text,
          left: 0,
          top: 0,
          color: Colors.red,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 40,
          textAlign: TextAlign.left,
        ),
      );
      Navigator.of(context).pop();
    });
  }

  addNewShape(BuildContext context) {
    setState(() {
      icons.add(
        ShapeInfo(
          left: 0,
          top: 0,
          size: 50,
          color: Colors.red.withOpacity(opaPic),
          // opacity: Opacity(opacity: opaPic, child: Container(),),
        ),
      );
    });
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('new'),
        content: TextField(
          controller: editController,
          maxLines: 5,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.edit),
            filled: true,
            hintText: 'Your text here',
          ),
        ),
        actions: [
          DefaultButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.black,
            textColor: Colors.white,
            child: const Text('back'),
          ),
          DefaultButton(
            onPressed: () => addNewText(context),
            color: Colors.black,
            textColor: Colors.white,
            child: const Text('add'),
          ),
        ],
      ),
    );
  }
}

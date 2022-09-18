import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/widgets/edit_text.dart';
import 'package:photo_editor/widgets/image_text.dart';
import 'package:photo_editor/widgets/shape_text.dart';
import 'package:screenshot/screenshot.dart';

import '../widgets/edit_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends EditText {
  File? image;
  // Image? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //  newImage() {
  //   final img = Image.asset('assets/01.jpg');

  //   final image1 = Image.file();

  //   final imagetemp = image1;

  //   setState(() {
  //     this.image = imagetemp
  //   });
  // }

  double blurImage = 0;
  double blurBox = 0.8;
  double opaImage = 0;
  bool isSwitched = false;
  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isSwitched4 = false;
  bool isSwitched5 = false;
  bool isVisible = false;
  bool isSelected = true;
  bool showFab = false;

  // Offset _dragOffset = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: (() => pickImage()),
                  child: const Icon(
                    Icons.browse_gallery,
                    size: 32,
                  ),
                ),
                TextButton(
                  onPressed: (() => pickImageC()),
                  child: const Icon(
                    Icons.camera,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
          title: const Text("Image Picker"),
        ),
        floatingActionButton: Visibility(
          visible: image != null ? showFab : !showFab,
          child: actionButton(),
        ),
        body: image != null
            ? ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 35),
                children: [
                  Screenshot(
                    controller: screenshotController,
                    child: Stack(
                      children: [
                        buildBlurredImage(),
                        for (int i = 0; i < texts.length; i++)
                          Positioned(
                            left: texts[i].left,
                            top: texts[i].top,
                            // left: _dragOffset.dx,
                            // top: _dragOffset.dy,
                            child: GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  currentIndex = i;
                                  removeText(context);
                                });
                              },
                              onTap: () => setCurrentIndex(context, i),
                              child: Draggable(
                                feedback: ImageText(
                                  textInfo: texts[i],
                                ),
                                child: ImageText(
                                  textInfo: texts[i],
                                ),
                                onDragEnd: (drag) {
                                  final renderBox =
                                      context.findRenderObject() as RenderBox;
                                  Offset off =
                                      renderBox.globalToLocal(drag.offset);
                                  setState(() {
                                    texts[i].top = off.dy - 96;
                                    texts[i].left = off.dx;
                                  });
                                },
                              ),
                            ),
                          ),
                        for (int i = 0; i < icons.length; i++)
                          Positioned(
                            left: icons[i].left,
                            top: icons[i].top,
                            // left: _dragOffset.dx,
                            // top: _dragOffset.dy,
                            child: GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  currentIndex = i;
                                  removeShape(context);
                                });
                              },
                              onTap: () => setCurrentIndex(context, i),
                              child: Draggable(
                                feedback: ShapeText(shapeInfo: icons[i]),
                                child: ShapeText(shapeInfo: icons[i]),
                                onDragEnd: (drag) {
                                  final renderBox =
                                      context.findRenderObject() as RenderBox;
                                  Offset off =
                                      renderBox.globalToLocal(drag.offset);
                                  setState(() {
                                    icons[i].top = off.dy - 96;
                                    icons[i].left = off.dx;
                                  });
                                },
                              ),
                            ),
                          ),
                        creatorText.text.isNotEmpty
                            ? Positioned(
                                left: 0,
                                bottom: 0,
                                child: Text(creatorText.text),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          isSwitched ? Froste() : Container(),
                          TextButton(
                            onPressed: () {
                              setState(
                                () {
                                  isSwitched = !isSwitched;
                                },
                              );
                            },
                            child: const Text('Froste'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          isSwitched1
                              ? Slider(
                                  value: opaPic,
                                  max: 1.0,
                                  // min: 0.0,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        opaPic = value;
                                        opachange();
                                      },
                                    );
                                  },
                                )
                              : Container(),
                          TextButton(
                            onPressed: () {
                              setState(
                                () {
                                  isSwitched1 = !isSwitched1;
                                },
                              );
                            },
                            child: const Text('Opacity'),
                          )
                        ],
                      ),
                      addText(),
                      Column(
                        children: [
                          isSwitched2 ? addColorText() : Container(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isSwitched2 = !isSwitched2;
                              });
                            },
                            child: const Text('new color'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      addShape(),
                      Column(
                        children: [
                          isSwitched3
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    increaseSize(),
                                    decreaseSize(),
                                  ],
                                )
                              : Container(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isSwitched3 = !isSwitched3;
                              });
                            },
                            child: const Text('increase text size'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          isSwitched4
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    increaseShapeSize(),
                                    decreaseShapeSize(),
                                  ],
                                )
                              : Container(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isSwitched4 = !isSwitched4;
                              });
                            },
                            child: const Text('increase shape size'),
                          ),
                        ],
                      ),
                    ],
                  ),

                  saveTheFile(),

                  // const SizedBox(height: 32),
                  // buildImageOverlay(),
                  // const SizedBox(height: 32),
                  // Slider(
                  //   value: blurBox,
                  //   max: 0.8,
                  //   onChanged: (value) => setState(() => blurBox = value),
                  // ),
                ],
              )
            : const Center(
                child: Text('Select a image from gallery or take a picture'))

        // Center(
        //   child: Column(
        //     children: [
        //       MaterialButton(
        //           color: Colors.blue,
        //           child: const Text("Pick Image from Gallery",
        //               style: TextStyle(
        //                   color: Colors.white70, fontWeight: FontWeight.bold)),
        //           onPressed: () {
        //             pickImage();

        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => ImageEditing(image: image),
        //               ),
        //             );
        //           }),
        //       MaterialButton(
        //           color: Colors.blue,
        //           child: const Text("Pick Image from Camera",
        //               style: TextStyle(
        //                   color: Colors.white70, fontWeight: FontWeight.bold)),
        //           onPressed: () {
        //             pickImageC();
        //           }),
        //       const SizedBox(
        //         height: 20,
        //       ),

        //     ],
        //   ),
        // ),
        );
  }

  Widget buildBlurredImage() => ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Stack(
          children: [
            Image.file(
              image!,
              height: 450,
              width: 450,
              // color: Colors.black.withOpacity(opaImage),
              // colorBlendMode: BlendMode.modulate,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurImage,
                  sigmaY: blurImage,
                ),
                child: Container(color: Colors.white.withOpacity(.2)),
              ),
            ),
          ],
        ),
      );

  Widget buildOpacityImage() => ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Stack(
          children: [
            Image.file(
              image!,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Container(color: Colors.red.withOpacity(opaImage)),
            ),
          ],
        ),
      );

  // Widget buildImageOverlay() => ClipRRect(
  //       borderRadius: BorderRadius.circular(24),
  //       child: Stack(
  //         children: [
  //           Image.network(
  //             'https://images.unsplash.com/photo-1606569371439-56b1e393a06b?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=2134&q=80',
  //             fit: BoxFit.cover,
  //           ),
  //           Positioned(
  //             top: 32,
  //             left: 0,
  //             right: 0,
  //             child: Center(
  //               child: buildBlur(
  //                 borderRadius: BorderRadius.circular(20),
  //                 child: Container(
  //                   padding: const EdgeInsets.all(24),
  //                   color: Colors.white.withOpacity(blurBox),
  //                   child: const Text(
  //                     'This is text is blurred',
  //                     style: TextStyle(
  //                       fontSize: 28,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );

  Widget actionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // FloatingActionButton(
        //   onPressed: (() {
        //     SizedBox(
        //       height: 450,
        //       width: 450,
        //       child: Image.asset('assets/assets/01.jpg'),
        //     );
        //   }),
        //   child: const Icon(Icons.browse_gallery),
        // ),
        // const SizedBox(
        //   height: 6,
        // ),
        FloatingActionButton(
          onPressed: (() => pickImage()),
          child: const Icon(Icons.browse_gallery),
        ),
        const SizedBox(
          height: 6,
        ),
        FloatingActionButton(
          onPressed: (() => pickImageC()),
          child: const Icon(Icons.camera),
        ),
      ],
    );
  }

  Widget buildBlur({
    required Widget child,
    required BorderRadius borderRadius,
    double sigmaX = 10,
    double sigmaY = 10,
  }) =>
      ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );

  Widget addText() {
    return TextButton(
      onPressed: () => addNewDialog(context),
      child: const Text('Add text'),
    );
  }

  Widget addShape() {
    return TextButton(
      onPressed: () {
        addNewShape(context);
        print('shaped');
      },
      child: const Text('Add shape'),
    );
  }

  Widget addColorText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () => changeTextColor(Colors.yellow),
          icon: const Icon(
            Icons.circle,
            color: Colors.yellow,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: () => changeTextColor(Colors.blue),
          icon: const Icon(
            Icons.circle,
            color: Colors.blue,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: () => changeTextColor(Colors.black),
          icon: const Icon(
            Icons.circle,
            color: Colors.black,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: () => changeTextColor(Colors.purple),
          icon: const Icon(
            Icons.circle,
            color: Colors.purple,
            size: 25,
          ),
        ),
      ],
    );
  }

  Widget increaseSize() {
    return IconButton(
      onPressed: () => increaseFontSize(),
      icon: const Icon(Icons.add),
    );
  }

  Widget decreaseSize() {
    return IconButton(
      onPressed: () => decreaseFontSize(),
      icon: const Icon(Icons.remove),
    );
  }

  Widget increaseShapeSize() {
    return IconButton(
      onPressed: () => increaseSizeShape(),
      icon: const Icon(Icons.add),
    );
  }

  Widget decreaseShapeSize() {
    return IconButton(
      onPressed: () => decreaseSizeShape(),
      icon: const Icon(Icons.remove),
    );
  }

  Widget saveTheFile() {
    return MaterialButton(
      onPressed: () => saveToGallery(context),
      child: const Text(
        'Save to the gallery',
        style: TextStyle(fontSize: 21),
      ),
    );
  }

  Widget Froste() {
    return Slider(
      value: blurImage,
      max: 15,
      onChanged: (value) => setState(() => blurImage = value),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_processing/tflite_flutter_processing.dart';

class SignLanguage extends StatefulWidget {
  @override
  _SignLanguageState createState() => _SignLanguageState();
}

class _SignLanguageState extends State<SignLanguage> {
  List? _outputs;
  File? _image;
  bool _loading = false;
  ImagePicker picker = ImagePicker(); // Create an instance of ImagePicker
  ImageProcessor imageProcessor = ImageProcessorBuilder()
      .add(ResizeOp(224, 2, ResizeMethod.NEAREST_NEIGHBOUR))
      .build();

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  showFloatingActionButton() {
    if (_image == null) {
      return FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add_a_photo),
        tooltip: 'Open Camera',
        onPressed: _optionsDialogBox,
      );
    } else {
      return FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.close),
        onPressed: () {
          setState(() {
            _image = null;
          });
        },
      );
    }
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text(
                    'Take a Picture',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => openCamera(ImageSource.camera),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                GestureDetector(
                  child: Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onTap: openGallery,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> openCamera(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;

    Navigator.of(context).pop();

    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(File(image.path));
  }

  Future<void> openGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(File(image.path));
  }

  Future<void> classifyImage(File image) async {
    try {
      TensorImage tensorImage = TensorImage.fromFile(image);
      tensorImage = imageProcessor.process(tensorImage);

      setState(() {
        _loading = false;
        _outputs = tensorImage as List?;
      });
    } catch (e) {
      print('Error classifying image: $e');
    }
  }

  Future<void> loadModel() async {
    try {
      Interpreter interpreter =
          await Interpreter.fromAsset('assets/model.tflite');
      print('Model loaded successfully');
      setState(() {
        _loading = false;
      });
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 1, 132, 91),
          title: Center(
              child: Text(
            'Sign Language Detection',
            style: TextStyle(color: Colors.white),
          ))),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 170,
            ),
            _loading
                ? Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          'No image is Selected',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _image == null
                              ? Center(
                                  child: Container(
                                    child: Text(
                                      'No image is Selected',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 400,
                                  width: 400,
                                  child: Image.file(_image!),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          _image != null
                              ? Text(
                                  "${_outputs?[0]["label"]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Icon(
                  Icons.play_arrow,
                  size: 60,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: showFloatingActionButton(),
    );
  }
}

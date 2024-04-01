import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';

class SignLanguage extends StatefulWidget {
  @override
  _SignLanguageState createState() => _SignLanguageState();
}

class _SignLanguageState extends State<SignLanguage> {
  List? _outputs;
  File? _image;
  bool _loading = false;

  final FlutterTts flutterTts = FlutterTts();

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
                    onTap: openCamera,
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
        });
  }

  Future openCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    Navigator.of(context).pop();

    setState(() {
      _loading = true;
      _image = File(image!.path);
    });
    classifyImage(File(image!.path));
  }

  Future openGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(File(image.path));
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      numThreads: 1, 
      isAsset: true,
      useGpuDelegate:
          false, 
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future speak(String s) async {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(s);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 132, 91),
        title: Center(
          child: Text(
            'Sign Language Detection',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 120),
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
                          SizedBox(height: 20),
                          _image != null
                              ? Text(
                                  "${_outputs?[0]["label"]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 20),
                          _image != null
                              ? Text(
                                  "Recognized Letter: ${_outputs?[0]["label"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 8, 35, 72),
                                    fontSize: 20.0,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  speak("${_outputs?[0]["label"]}");
                },
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

import 'package:avatar_glow/avatar_glow.dart';
import 'package:disability_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextConverter extends StatefulWidget {
  const SpeechToTextConverter({super.key});

  @override
  State<SpeechToTextConverter> createState() => _SpeechToTextConverterState();
}

class _SpeechToTextConverterState extends State<SpeechToTextConverter> {
  bool startRecord = false;
  final SpeechToText speech = SpeechToText();
  bool isAvailable = false;
  var text = "Press the mic Button to start recording speech";
  double _confidence = 1.0;

  @override
  void initState() {
    make();
    // TODO: implement initState
    super.initState();
  }

  make() async {
    isAvailable = await speech.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 132, 91),
        title: Text(
          startRecord
              ? 'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'
              : 'Voice to Text',
          style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 254, 254, 254)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Text copied to clipboard'),
              ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(28),
        child: Center(
          child: Text(
            '$text',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 137, 5, 5)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: AvatarGlow(
          animate: startRecord,
          glowColor: kPrimaryColor,
          child: GestureDetector(
            onTapDown: (value) {
              setState(() {
                startRecord = true;
              });
              if (isAvailable) {
                speech.listen(
                  onResult: (results) {
                    setState(() {
                      text = results.recognizedWords;
                      if (results.hasConfidenceRating &&
                          results.confidence > 0) {
                        _confidence = results.confidence;
                      }
                    });
                  },
                );
              }
            },
            onTapUp: (value) {
              setState(() {
                startRecord = false;
              });
              speech.stop();
            },
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Icon(
                  startRecord ? Icons.mic : Icons.mic_none_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:disability_app/screens/home_page.dart';
import 'package:disability_app/screens/signlanguage/signlanguage.dart';
import 'package:disability_app/screens/speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 132, 91),
        title: Text(
          "Disability App",
          style: GoogleFonts.lato(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignLanguage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.teal[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/icons/sign-language.png'), // Replace with your image asset
                  ),
                  SizedBox(height: 10),
                  Text("Sign Language",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 7, 0, 0))),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SpeechToTextConverter()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.teal[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/icons/voice-recognition.png'), // Replace with your image asset
                  ),
                  SizedBox(height: 10),
                  Text("Speech to Text",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 7, 0, 0))),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.teal[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/icons/artificial-intelligence.png'),
                  ),
                  SizedBox(height: 10),
                  Text("Gemini AI",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 7, 0, 0))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

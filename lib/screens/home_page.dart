import 'package:animate_do/animate_do.dart';
import 'package:disability_app/features/features_box.dart';
import 'package:disability_app/screens/colors.dart';
import 'package:disability_app/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();

  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: FadeInLeft(
          child: Text(
            'AI',
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
       leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Add your back button functionality here
              Navigator.pop(context);
            },
          ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: LottieBuilder.asset(
                  'assets/animation/Animation - 1704818003604.json',
                  height: height * 0.2,
                  width: width * 0.7,
                  fit: BoxFit.cover,
                  animate: true,
                  repeat: true),
            ),
            FadeInRight(
              duration: Durations.extralong2,
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ).copyWith(
                    top: 60,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor),
                      borderRadius: BorderRadius.circular(20)
                          .copyWith(topLeft: const Radius.circular(0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      generatedContent == null
                          ? 'Good Morning, what task can I do for you?'
                          : generatedContent!,
                      style: GoogleFonts.poppins(
                          fontSize: generatedContent == null ? 20 : 13,
                          fontWeight: FontWeight.w600,
                          color: Pallete.mainFontColor),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10, left: 22),
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Here are a few features',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Pallete.mainFontColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null,
              child: const Column(
                children: [
                  FeatureBox(
                    color: Pallete.firstSuggestionBoxColor,
                    headerText: 'Gemini AI',
                    descriptionText:
                        'A smarter way to stay organized and informed with Gemini AI.',
                  ),
                  FeatureBox(
                    color: Pallete.thirdSuggestionBoxColor,
                    headerText: 'Smart Voice Assistant',
                    descriptionText:
                        'Get the best of both worlds with a voice assistant powered by Gemini AI.',
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
           
            
          } else if (speechToText.isListening) {
             final speech = await openAIService.isArtPromptAPI(lastWords);
            generatedContent = speech;
           
            CircularProgressIndicator();

            await stopListening();
             await systemSpeak(speech);
            setState(() {});
            
          } else {
            initSpeechToText();
          }
        },
        child: Icon(
          speechToText.isListening ? Icons.stop : Icons.mic,
        ),
      ),
    );
  }
}

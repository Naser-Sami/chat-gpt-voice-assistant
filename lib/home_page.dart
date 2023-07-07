import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant_chat_gpt/feature_box.dart';
import 'package:voice_assistant_chat_gpt/openai_service.dart';
import 'package:voice_assistant_chat_gpt/palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final OpenAIService openAIService = OpenAIService();

  // instantiate FlutterTts
  final FlutterTts flutterTts = FlutterTts();

  String _lastWords = '';
  String? generatedContent;
  String? generatedImageUrl;

  // animations
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.awaitSpeakCompletion(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> _startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> _stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
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
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: const Text("Allen"),
        ),
        leading: const Icon(Icons.menu),
      ),
      body: SafeArea(
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: ListView(
            children: [
              // .. virtual assistant picture
              ZoomIn(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 100.w,
                        height: 100.w,
                        margin: EdgeInsets.only(top: 4.h),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Palette.assistantCircleColor,
                        ),
                      ),
                    ),
                    Container(
                      height: 103.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/virtualAssistant.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // .. chat bubble
              FadeInRight(
                child: Visibility(
                  visible: generatedImageUrl == null,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                    margin: EdgeInsets.symmetric(
                      horizontal: 36.w,
                    ).copyWith(
                      top: 20.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Palette.borderColor),
                      borderRadius: BorderRadius.circular(20.r).copyWith(
                        topLeft: const Radius.circular(0),
                      ),
                    ),
                    child: Text(
                      generatedContent ??
                          "Good morning, What task can I do for you",
                      style: TextStyle(
                        color: Palette.mainFontColor,
                        fontSize: generatedContent == null ? 18.sp : 14.sp,
                        fontFamily: 'Cera Pro',
                      ),
                    ),
                  ),
                ),
              ),

              // .. generate an image
              if (generatedImageUrl != null)
                Padding(
                  padding: EdgeInsets.all(10.0.w).copyWith(top: 30.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.network(generatedImageUrl!),
                  ),
                ),

              SlideInLeft(
                child: Visibility(
                  visible:
                      generatedContent == null && generatedImageUrl == null,
                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    padding: EdgeInsets.all(10.w),
                    margin: EdgeInsetsDirectional.only(top: 5.h, start: 26.w),
                    child: Text(
                      'Here are a few commands',
                      style: TextStyle(
                        color: Palette.mainFontColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cera Pro',
                      ),
                    ),
                  ),
                ),
              ),

              // features list
              Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Column(
                  children: [
                    FadeInLeft(
                      delay: Duration(milliseconds: start),
                      child: const FeatureBox(
                        color: Palette.firstSuggestionBoxColor,
                        headerText: "Chat GPT",
                        descriptionText:
                            "A smarter way to stay organized and informedwith ChatGPT",
                      ),
                    ),
                    FadeInLeft(
                      delay: Duration(milliseconds: start + delay),
                      child: const FeatureBox(
                        color: Palette.secondSuggestionBoxColor,
                        headerText: "Dall-E",
                        descriptionText:
                            "Get inspired and stay creative with your personal assistant powered by Dall-E",
                      ),
                    ),
                    FadeInLeft(
                      delay: Duration(milliseconds: start + 2 * delay),
                      child: const FeatureBox(
                        color: Palette.thirdSuggestionBoxColor,
                        headerText: "Smart Voice Assistant",
                        descriptionText:
                            "Get the best of both worlds with a voice assistant powered by Dall-Erand ChatGPT",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await _startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIService.isArtPromptApi(_lastWords);
              if (kDebugMode) {
                print('speech $speech');
              }

              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                await systemSpeak(speech);
                setState(() {});
              }

              await _stopListening();
            } else {
              initSpeechToText();
            }

            // setState(() {
            //   // generatedContent =
            //   //     'Quantum computing is a new type of computing that uses the strange and powerful world of quantum mechanics to solve problems more quickly than classical computers. Instead of usina classical bits, which can only be in two states (0 or 1), quantum computers use quantum bits, or qubits, which can be in many states at once. This allows quantum computers to perform multiple calculations simultaneously and find the best solution much faster than classical computers. In short, quantum computing is a way to solve complex problems faster and more efficiently than traditional computers.';
            //   generatedImageUrl =
            //       'https://images.freeimages.com/images/large-previews/212/flowers-1370428.jpg';
            // });
          },
          backgroundColor: Palette.firstSuggestionBoxColor,
          child: Icon(
            speechToText.isListening ? Icons.stop : Icons.mic,
          ),
        ),
      ),
    );
  }
}

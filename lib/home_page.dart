import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:voice_assistant/palette.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'services.dart';
import 'feature_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';
  OpenAI openairesponse=OpenAI();
  FlutterTts flutterTts = FlutterTts();
  String imageurl = '';
  String speech = '';
  int call=0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }
  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }
  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }
  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }
  Future<void> speak(String content) async{
    await flutterTts.speak(content);
  }
  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SlideInDown(
          child: const Text(
                'Jarvis',
                style: TextStyle(
                  color: Pallete.blackColor,
                ),
              ),
        ),
        leading: const Icon(
          Icons.menu,
          color: Pallete.blackColor,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      //circle
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    //image
                    margin: const EdgeInsets.only(top: 11),
                    height: 125,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/virtualAssistant.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SlideInLeft(
              delay: Duration(milliseconds: 200),
              child: Visibility(
                visible: imageurl=='',
                child: Container(
                  //intro message
                  margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Pallete.borderColor),
                    borderRadius: BorderRadius.circular(30)
                        .copyWith(topLeft: const Radius.circular(0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      speech==''?'Good Morning, what can I do for you?':speech,
                      style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontSize: speech==''?20:16,
                          fontFamily: 'Cera Pro'),
                    ),
                    ),
                  ),
              ),
            ),
            if(speech!='')Container(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        width: 1,
                    )
                ),
                child: Text(
                "STOP",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: () {
                  flutterTts.stop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const HomePage(),
                  ),
                  );
                },
              ),
            ),
            SlideInLeft(
              duration: Duration(milliseconds: 300),
              child: Visibility(
                visible: speech=='' && imageurl=='',
                child: Container(
                  //select options
                  margin: const EdgeInsets.only(left: 21, top: 20),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Please select one of the options:',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Pallete.mainFontColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if(imageurl!='')Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(imageurl),
                  ),
                ),
                Container(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 1.5,
                      )
                    ),
                    child: Text(
                      "BACK",
                      style: TextStyle(
                          color: Pallete.blackColor,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Visibility(
              visible: speech=='' && imageurl=='',
              child: Column(
                children: [
                  SlideInLeft(
                    duration: Duration(milliseconds: 400),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          call=1;
                        });
                      },
                      child: Featurebox(
                          heading: 'ChatGPT',
                          description:
                              'ChatGPT at your service to resolve all your queries',
                          color: Pallete.firstSuggestionBoxColor,
                      ),
                    ),
                  ),
                  SlideInLeft(
                    duration: Duration(milliseconds: 500),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          call=2;
                        });
                      },
                      child: Featurebox(
                          heading: 'Dall-E',
                          description:
                              'Get inspired and show your creative self using Dall-E',
                          color: Pallete.secondSuggestionBoxColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
          duration: Duration(milliseconds: 700),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () async {
            if (await speechToText.hasPermission && speechToText.isNotListening && (call==1 || call==2)){
              startListening();
            }
            else if(speechToText.isListening){
              await Future.delayed(const Duration(seconds: 2), (){});
              stopListening();
              print(lastWords);
              if(call==1){
                final answer=await openairesponse.ChatGpt(lastWords);
                setState(() {
                  speech=answer;
                  imageurl='';
                  call=0;
                });
                await speak(answer);
              }
              else if(call==2){
                final answer = await openairesponse.DallE(lastWords);
                setState(() {
                  imageurl=answer;
                  speech='';
                  call=0;
                });
              }
            }
            else{
              initSpeech();
              setState(() {
                call=0;
              });
            }
          },
          backgroundColor: Pallete.firstSuggestionBoxColor,
          elevation: 0,
          child: Icon(
            speechToText.isListening?Icons.stop:Icons.mic,
            color: Pallete.blackColor,
          ),
        ),
      ),
    );
  }
}

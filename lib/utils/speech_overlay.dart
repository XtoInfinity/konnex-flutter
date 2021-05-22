import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechOverlay extends StatefulWidget {
  @override
  _SpeechOverlayState createState() => _SpeechOverlayState();
}

class _SpeechOverlayState extends State<SpeechOverlay> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Please speak out loud what you want to type';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _listen();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 150.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: Container(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            onPressed: _listen,
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
              size: 50,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.7),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: 16, vertical: Get.height * 0.1),
          child: Text(
            _text,
            style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == "notListening") {
            Future.delayed(Duration(seconds: 1), () => Get.back(result: _text));
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(
            () {
              _text = val.recognizedWords;
              if (val.hasConfidenceRating && val.confidence > 0) {
                _confidence = val.confidence;
              }
            },
          ),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}

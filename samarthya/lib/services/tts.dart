import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:samarthya/style/color.dart';
import 'package:translator/translator.dart';

class tts extends StatefulWidget {
  @override
  _tts createState() => _tts();
}

enum TtsState { playing, stopped }

class _tts extends State<tts> {
  GoogleTranslator translator = GoogleTranslator();
  FlutterTts? flutterTts;
  dynamic languages;
  String? language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  var output;

  String? _newVoiceText = "Wikis are enabled by wiki software, otherwise known as wiki engines. A wiki engine, being a form of a content management system, differs from other web-based systems such as blog software, in that the content is created without any defined owner or leader, and wikis have little inherent structure, allowing structure to emerge according to the needs of the users.[1] Wiki engines usually allow content to be written using a simplified markup language and sometimes edited with the help of a rich-text editor.[2] There are dozens of different wiki engines in use, both standalone and part of other software, such as bug tracking systems. Some wiki engines are open source, whereas others are proprietary. Some permit control over different functions (levels of access); for example, editing rights may permit changing, adding, or removing material. Others may permit access without enforcing access control. Other rules may be imposed to organize content.";
  String lan = "hi";
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;
  void trans() {
    translator.translate(_newVoiceText!, to: lan).then((value) {
      setState(() {
        output = value;
      });
    });
  }

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    flutterTts?.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts?.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts?.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts?.getLanguages;
    print("pritty print ${languages}");
    if (languages != null) setState(() => languages);
  }

  Future _speak() async {
    await flutterTts?.setVolume(volume);
    await flutterTts?.setSpeechRate(rate);
    await flutterTts?.setPitch(pitch);
    trans();
    if (output != null) {
      //trans();
      print(output.toString());
      var result = await flutterTts?.speak(output.toString());
      if (result == 1) setState(() => ttsState = TtsState.playing);
    }
  }

  Future _stop() async {
    var result = await flutterTts?.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts?.stop();
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = <DropdownMenuItem<String>>[];
    for (String type in languages) {
      if (type.length == 5) {
        if (type[3] == 'I' && type[4] == 'N') {
          if (type[0] == 't' && type[1] == 'a')
            items.add(DropdownMenuItem(value: type, child: Text('Tamil')));
          else if (type[0] == 't' && type[1] == 'e')
            items.add(DropdownMenuItem(value: type, child: Text('Telugu')));
          else if (type[0] == 'm' && type[1] == 'l')
            items.add(DropdownMenuItem(value: type, child: Text('Malyalam')));
          else if (type[0] == 'm' && type[1] == 'r')
            items.add(DropdownMenuItem(value: type, child: Text('Marathi')));
          else if (type[0] == 'g')
            items.add(DropdownMenuItem(value: type, child: Text('Gujarati')));
          else if (type[0] == 'b')
            items.add(DropdownMenuItem(value: type, child: Text('Bengali')));
          else if (type[0] == 'h')
            items.add(DropdownMenuItem(value: type, child: Text('Hindi')));
          else if (type[0] == 'e')
            items.add(DropdownMenuItem(value: type, child: Text('English')));
          else
            items.add(DropdownMenuItem(value: type, child: Text('Kannad')));
        }
      }
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = selectedType;
      {
        if (language == "ta-IN") lan = "ta";
        else if (language == "bn-IN") lan = "bn";
        else if (language == "gu-IN") lan = "gu";
        else if (language == "hi-IN") lan = "hi";
        else if (language == "mr-IN") lan = "mr";
        else if (language == "en-IN") lan = "en";
        else if (language == "kn-IN") lan = "kn";
        else if (language == "ml-IN") lan = "ml";
        else if (language == "te-IN") lan = "te";
      }
      flutterTts?.setLanguage(language!);
    });
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomBar(),
        appBar: AppBar(
          title: Text(
            'Text To Speech',
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              _inputSection(),
              languages != null ? _languageDropDownSection() : Text("hi-IN"),
            ])));
  }

  Widget _inputSection() => Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: Text("Listen selected notice"));

  Widget _languageDropDownSection() => Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        DropdownButton(
          value: language,
          items: getLanguageDropDownMenuItems(),
          onChanged: changedLanguageDropDownItem,
        )
      ]));

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }

  bottomBar() => Container(
        margin: EdgeInsets.all(10.0),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _speak,
              child: Icon(Icons.play_arrow),
              backgroundColor: Colors.green,
            ),
            FloatingActionButton(
              onPressed: _stop,
              backgroundColor: Colors.red,
              child: Icon(Icons.stop),
            ),
          ],
        ),
      );
}

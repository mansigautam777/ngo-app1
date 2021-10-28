import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samarthya/screens/openpdf.dart';
import 'package:samarthya/services/speech.dart';
import 'package:samarthya/services/tts.dart';
import 'package:samarthya/style/color.dart';
import 'package:flutter/material.dart';
import 'package:samarthya/style/theme.dart';
import 'package:samarthya/widget/drawer.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  static final String routeName = 'home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKeyHome = GlobalKey<ScaffoldState>();

  Color cardBackgroundColor = kBackgroundColor;


  final TextEditingController _controller = new TextEditingController();

  int _currentIndex = 0;

  List<dynamic> _list = [];
  bool _isSearching = false;
  List searchresult = [];
  bool isListening = false;

  Widget appBarTitle = new Text(
    "Search Example",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
  }

  /// This works for single selection (Unable to deselect the currently selected one by clicking on it, but that's ok because the previous one is deselected when a new one is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyHome,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
        IconButton(onPressed: toggleRecording, icon: isListening?Icon(Icons.mic):Icon(Icons.mic_none_outlined)),
        IconButton(
          icon: icon,
          onPressed: () {
            setState(() {
              if (this.icon.icon == Icons.search) {
                this.icon = Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.appBarTitle = TextField(
                  controller: _controller,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: inputDecor,
                  onChanged: searchOperation,
                );
                _handleSearchStart();
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
      ]),
      drawer: createDrawer(context),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: appbar2Items(context),
              ),
            ),
            Flexible(
                child: searchresult.length != 0 || _controller.text.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchresult.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = searchresult[index]['title'];
                          return listData!=null?ListTile(
                            title: Text(listData.toString()),
                          ): ListTile(title: Text("fef")) ;
                        },
                      )
                    : new ListView.builder(
                        shrinkWrap: true,
                        itemCount: _list.length,
                        itemBuilder: (BuildContext context, int index) {
                          var listData = _list[index];
                          return listData!=null?Card(
                            child: listData!=null?ListTile(
                              leading: Text(listData['title']!=null?listData['title']:"Not available"),
                              title: Row(
                                children: [
                                  TextButton(child: Icon(Icons.picture_as_pdf),onPressed: (){
                                    openPDF(context, listData['url']);

                                    // http.get(Uri.parse(listData['url']));

                                  },),
                                  TextButton(child: Icon(Icons.headphones),onPressed: (){
                                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => tts()));
                                  },),

                                ],
                              ),
                            ):ListTile(),
                          ):Card();
                        },
                      ))
          ],
        ),
      ),
    );
  }

  _handleSearchStart() async {
    var klist = [];
    await FirebaseFirestore.instance
        .collection("documents")
        .get()
        .then((snapshot) => {
              snapshot.docs.forEach((e) {
                print(e.data());
                klist.add(e.data());
              })
            });
    setState(() {
      _list = klist;
    });
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search Sample",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) {
          print(text);
          _isSearching = true;
          searchOperation(text);
          print(searchresult);
          setState(() {});
        },
        onListening: (isListening) {
          setState(() => this.isListening = isListening);
          if (!isListening) _isSearching = false;
        },
      );

  showD(BuildContext context, List<String> items, String query) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return AlertDialog(
                title: Text(query),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () async {
                      var klist = [];
                      print(items[_currentIndex]);
                      await FirebaseFirestore.instance
                          .collection("documents")
                          .where(query, isEqualTo: items[_currentIndex])
                          .get()
                          .then((snapshot) => {
                                snapshot.docs.forEach((e) {
                                  print(e.data()['title']);
                                  klist.add(e.data());
                                })
                              });
                      setState(() {
                        print(klist);
                        _list = klist;
                      });
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
                content: Container(
                  width: double.minPositive,
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                        value: index,
                        groupValue: _currentIndex,
                        title: Text(items[index]),
                        onChanged: (val) {
                          setState2(() {
                            _currentIndex = int.parse(val.toString());
                            print(_currentIndex);
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  List<Widget> appbar2Items(BuildContext context){
    return [
                  TextButton.icon(
                      onPressed: () async {
                        List<String> states = [
                          "Delhi",
                          "Chandigarh",
                          "Rajasthan",
                          "Ladakh",
                          "Punjab"
                        ];
                        showD(context, states, "state");
                      },
                      icon: Icon(
                        Icons.location_city,
                        color: Colors.white,
                      ),
                      label: Text("States")),
                  TextButton.icon(
                      onPressed: () async {
                        List<String> states = ["State Board", "CBSE"];
                        showD(context, states, "board");
                        
                      },
                      icon: Icon(
                        Icons.book,
                        color: Colors.white,
                      ),
                      label: Text("Board")),
                  TextButton.icon(
                      onPressed: () async {
                        List<String> states = [
                          "Admission",
                          "scholarship",
                          "Benifits"
                        ];
                        showD(context, states, "filter");
                        
                      },
                      icon: Icon(
                        Icons.filter,
                        color: Colors.white,
                      ),
                      label: Text("Other Filter")),
                ];
  }
}

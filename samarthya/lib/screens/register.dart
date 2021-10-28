import 'dart:io';
import 'package:flutter/material.dart';
import 'package:samarthya/style/color.dart';
import 'package:samarthya/models/addparent.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  static final String routeName = 'welcome';

  final bool isAndroid = Platform.isAndroid;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Become a Member"),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Samarthya',
            style: Theme.of(context)
                .textTheme
                .headline3
          ),
          Image.asset('assets/logo2.jpg'),
          Text(
            
            'Be an informed parent and keep yourself updated with all the latest official notices of your region !',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline5
          ),
          //Image.asset('images/icons8_comments_48.png'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                child: Material(
                  color: kPrimaryColorLight,
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 400,
                    elevation: 16,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddUser())).then((_) => Navigator.of(context).pop());
                    },
                    child: Text(
                      'Register',
                      style: Theme.of(context)
                          .textTheme
                          .button
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20.0), // <= NEW
            ],
          ),
        ],
      ),
    );
  }
}

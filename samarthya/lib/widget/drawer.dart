import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:samarthya/screens/home.dart';
import 'package:samarthya/screens/register.dart';
import 'package:samarthya/style/color.dart';

Drawer createDrawer(BuildContext context){
  return Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              accountName: Text(
                "",
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              accountEmail: Text(
                '',
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 50.0,
                backgroundColor: kPrimaryColor,
                backgroundImage: new NetworkImage(
                    'https://drive.google.com/uc?export=view&id=1194BmuJDoVXJ0e9Do8JP1wKrfzFNljS_'),
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(
                FontAwesomeIcons.home,
                color: kPrimaryColorDark,
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              title: Text("Register"),
              leading: Icon(
                FontAwesomeIcons.addressCard,
                color: kPrimaryColorDark,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Welcome())).then((value) => Navigator.of(context).pop());
              },
            ),
          ],
        ),
      );
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samarthya/style/color.dart';

String? _name;
String? _phone;
String? _state = 'Andhra Pradesh';
String? _language;
String? _board = "CBSE";

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUser();
}

  class _AddUser extends State<AddUser> {
  
  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    final _registerFormKey = GlobalKey<FormState>();
    CollectionReference users =
        FirebaseFirestore.instance.collection('parents');

    Future<void> addUser(BuildContext context) {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'name': _name, // John Doe
            'phone': _phone, // Stokes and Sons
            'state': _state, //madhya pradesh
            'language': _language,
            'board': _board
          })
          .then((value){ 
            print("User Added");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.blueAccent, content: Text("Successful Registration")));
            Navigator.of(context).pop();

          })
          .catchError((error){print("Failed to add user: $error");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.deepOrange, content: Text("Unsucessful Registration, try again",style: TextStyle(color: Colors.white),)));
          
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _registerFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Text(
                  'Registration Information',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  validator: (String? value) {
                    if (value == null) {
                      return 'Please enter a name';
                    }
                  },
                  decoration: InputDecoration(labelText: "Name"),
                  onChanged: (value) => _name = value,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: "Phone No."),
                  onChanged: (value) => _phone = value,
                  validator: (String? value) {
                    if (value == null) {
                      return 'Please enter your phone no.';
                    }
                  },
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Text("Select State        "),
                    DropdownButton<String>(
      value: _state,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: Theme.of(context).textTheme.bodyText1,
      underline: Container(
        height: 2,
        color:  kPrimaryColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _state = newValue!;
        });
      },
      items: <String>['Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh','Goa','Gujrat','Haryana','	Himachal Pradesh','Jharkhand','Karnataka','Kerala','Madhya Pradesh','Maharashtra',
      'Manipur','Meghalaya','Mizoram']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
                  ],
                ),
                
                SizedBox(height: 20.0),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  validator: (String? value) {
                    if (value == null) {
                      return 'Please enter your language';
                    }
                  },
                  decoration: InputDecoration(labelText: "Language"),
                  onChanged: (value) => _language = value,
                ),
                SizedBox(height: 20.0),
               Row(
                  children: [
                    Text("Select Board        "),
                    DropdownButton<String>(
      value: _board,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: Theme.of(context).textTheme.bodyText1,
      underline: Container(
        height: 2,
        color:  kPrimaryColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _board = newValue!;
        });
      },
      items: <String>['CBSE', 'State']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
                  ],
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: kPrimaryColor200,
                    child: MaterialButton(
                      minWidth: 400,
                      child: Text("SIGN UP"),
                      onPressed:()=> addUser(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


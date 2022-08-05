import 'package:flutter/material.dart';
import 'dart:io';
import '../Models/Contact.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _photoUrl = "empty";

  saveContact(context) async {
    if(this._firstName.isNotEmpty &&
       this._lastName.isNotEmpty &&
       this._phone.isNotEmpty &&
       this._email.isNotEmpty &&
       this._address.isNotEmpty
    ){

      Contact contact = Contact(this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);
      
      await _databaseReference.push().set(contact.toJson());
      navigateToLastScreen(context); 
    } else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Fields Required'),
            content: Text('All the fields are required.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: (){
                  return Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  Future pickImage() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 200.0,
      maxHeight: 200.0
    );

    String fileName = context.basename(file.path);
    uploadImage(file, fileName);
  }

  uploadImage(File file, String fileName) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName);

    storageReference.putFile(file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      setState(() {
        _photoUrl = downloadUrl;
      });
    });
  }



  navigateToLastScreen(context){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: pickImage,
                child: Center(
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _photoUrl == "empty"? 
                        AssetImage("images/logo.png"):
                        NetworkImage(_photoUrl)
                      )
                    ),
                  ),
                ),
              ),
            ),
            // first name
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                    _firstName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            // last name
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                    _lastName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            //email
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                    _email = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            //Phone
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                    _phone = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            //address
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                    _address = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
              child: RaisedButton(
                padding: EdgeInsets.all(10.0),
                child: Text('Save', style: TextStyle(
                  color: Colors.white, fontSize: 20.0
                ),),
                onPressed: (){saveContact(context);},
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:firebase_database/firebase_database.dart';
import 'package:firebaselogin/Models/Contact.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditContact extends StatefulWidget {

  final String id;
  EditContact(this.id);

  @override
  _EditContactState createState() => _EditContactState(id);
}

class _EditContactState extends State<EditContact> {
  String id;
  _EditContactState(this.id);
  
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String _photoUrl;

  bool isLoading = true;

  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _emController = TextEditingController();
  TextEditingController _phController = TextEditingController();
  TextEditingController _adController = TextEditingController();

  //firebase reference
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState(){
    super.initState();
    getContact(id);
  }

  getContact(id) async {
    Contact _contact;
    _databaseReference.child(id).onValue.listen((event) { 
        _contact = Contact.fromSnapshot(event.snapshot);

        _fnController.text = _contact.firstName;
        _lnController.text = _contact.lastName;
        _emController.text = _contact.email;
        _phController.text = _contact.phone;
        _adController.text = _contact.address;

        setState(() {
          _firstName = _contact.firstName;
          _lastName = _contact.lastName;
          _email = _contact.email;
          _phone = _contact.phone;
          _address = _contact.address;
          _photoUrl = _contact.photoUrl;

          isLoading = false;
        });

    });
  }

  updateContact(BuildContext context) async {
    if (this._firstName.isNotEmpty &&
        this._lastName.isNotEmpty &&
        this._email.isNotEmpty &&
        this._phone.isNotEmpty &&
        this._address.isNotEmpty
    ) {
      Contact _contact = Contact.withId(this.id , this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);
      await _databaseReference.child(id).set(_contact.toJson());
      navigateToLastScreen(context);
    }
    else{
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
  
  navigateToLastScreen(BuildContext context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    //image view
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            this.pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? AssetImage("images/logo.png")
                                          : NetworkImage(_photoUrl),
                                    ))),
                          ),
                        )),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                          });
                        },
                        controller: _fnController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _lastName = value;
                          });
                        },
                        controller: _lnController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _phController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        controller: _emController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _address = value;
                          });
                        },
                        controller: _adController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    // update button
                    Container(
                      padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.all(10.0),
                        onPressed: () {
                          updateContact(context);
                        },
                        color: Colors.red,
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
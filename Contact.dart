import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

class Contact{

  String _id;
  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  String _photoUrl;
  String _address;

  Contact(this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);

  Contact.withId(this._id, this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);

  //getters

  String get id => this._id;
  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get email => this._email;
  String get phone => this._phone;
  String get photoUrl => this._photoUrl;
  String get address => this._address;

  //setters

  set firstName(String firstName){
    this._firstName = firstName;
  }

  set lastName(String lastName){
    this._lastName = lastName;
  }

  set id(String id){
    this._id = id;
  }

  set email(String email){
    this._email = email;
  }

  set phone(String phone){
    this._phone = phone;
  }

  set photoUrl(String photoUrl){
    this._photoUrl = photoUrl;
  }

  set address(String address){
    this._address = address;
  }

  Contact.fromSnapshot(DataSnapshot snapshot ){
    this._id = snapshot.key;
    this._firstName = snapshot.value['firstName'];
    this._lastName = snapshot.value['lastName'];
    this._email = snapshot.value['email'];
    this._phone = snapshot.value['phone'];
    this._photoUrl = snapshot.value['photoUrl'];
    this._address = snapshot.value['address'];
  }

  Map<String, dynamic> toJson(){
    return{
      'firstName': _firstName,
      'lastName': _lastName,
      'email': _email,
      'phone': _phone,
      'photoUrl': _photoUrl,
      'address': _address
    };
  }

}
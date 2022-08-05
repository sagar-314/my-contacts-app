# my-contacts-app
A flutter based android and iOS application.

An app that can store contact information including media files. It provides user login with email and password using Firebase Authentication. It uses Firebase to store user data and Firebase Storage to store media files. 

**-----------------------------------------------------------------------------------------------------------------------------**

File descriptions:

**main.dart:** This is the builder file, that initializes and runs the app. It can be configured to maintain basic app details like app name, global theme, etc.

**Contact.dart:** This file contains the contact class. Every user has multiple properties like name, email, photo, etc.
which is be easily maintained by getters and setters of this class.

**HomePage.dart:** This file contains the home screen. It uses **itemBuilder** to create list view of contacts. It also uses **MaterialPageRoutes** to move to ViewContact or EditContact screen on tap.

**AddContact.dart:**  This file used to create new contact and save it on firebase. It is associated with the **floatingActionButton** on Home sreen.

**ViewContact.dart:** This file contains the view contact screen. It uses **IconButton** to move to EditScreen, **FlatButton** to delete the contact, **alertDialog box** to pop-up alert messages before deletion.

**EditContact.dart:** This file is used to update contact details. It uses **async** function to upload image as it can take some time.

**-----------------------------------------------------------------------------------------------------------------------------**

Dependencies used:

cupertino_icons: ^0.1.3

firebase_database: ^2.0.0

firebase_core: ^0.3.0

image_picker: ^0.6.0+1

url_launcher: ^5.0.1

firebase_storage: ^2.0.1

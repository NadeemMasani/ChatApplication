# Team Members
Nadeem Masani :- 824660441
Tejas Patil   :- 821522462

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Project Description :-
This is a chat application that allows 2 users to exchange text messages and also allows creation of 
Group chat and sharing text messages in the same below are the features implemented 

## Authentication : 
	1. Sign-up and Sign in using email authentication (Firebase)
	2. Forget passowrd which sends reset passowrd link on the registered email to change password

## Chat :
	One-to-One chat : 
		1. List all the current chats for logged in user
		2. List all the users in the application to select any user and start a chat
		3. Exchange text messages live between 2 users by clicking on the chat
		4. Messages read tick when intended user sees the message and unread tick otherwise
		4. Count of unread messgaes on the list screen for all chats for the user.
		6. Display picture for the users if added during signup
	
	Group chat : 
		1. List all the group chat user is involved in.
		2. Create new group chat and upto 10 users in the group.
		3. Exchange text messages live in the group chat screen.
		
	Note : Features 4-6 of one-to-one chat not implemented for group chat


## Special Instructions :-

we have used Flutter 
Dependencies are the ones included in pubspec.yaml file
  firebase_core: "0.5.3"
  cupertino_icons: ^0.1.3
  cloud_firestore: ^0.14.4
  firebase_auth: ^0.18.4+1
  shared_preferences: ^0.5.12+4
  firestore_ui: ^1.12.0
  image_picker: ^0.6.7

## Test Dummy Accounts : 
 1. nadeem.masani11@gmail.com/qwerty
 2. patiltejas2578@gmail.com/qwerty
 
We have Tested for android only

In order to test the forget passowrd functionality, you will have to sign up using an email which can recieve an email 
so the password link can be set

You might need to run 2 simulaotrs simultenously to see the chat application in full effect


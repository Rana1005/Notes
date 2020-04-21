import "package:flutter/material.dart";
import 'package:notes/screens/note_detail.dart';
import 'package:notes/screens/note_list.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatefulWidget {
  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ur_notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: NoteList(),
    );
  }
}

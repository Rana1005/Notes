import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/database_helper.dart';

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetails(this.note,this.appBarTitle);
  @override
  _NoteDetailsState createState() => _NoteDetailsState(this.note,this.appBarTitle);
}

class _NoteDetailsState extends State<NoteDetails> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  String appBarTitle;
  Note note;
  DatabaseHelper helper=DatabaseHelper();

  _NoteDetailsState(this.note,this.appBarTitle);

  static var _priorities = ['High', 'Low'];
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    titlecontroller.text=note.title;
    descriptioncontroller.text=note.description;
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                // 1st
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectedByuser) {
                      setState(() {
                        debugPrint("user selected $valueSelectedByuser");
                        updatePriorityAsInt(valueSelectedByuser);
                      });
                    },
                  ),
                ),

                // 2nd
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titlecontroller,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Something change in title text field");
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: "title",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                //3rd
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptioncontroller,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Something change in description text field");
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: "description",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                // 4th
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Save",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save buttom clicked");
                                _save();
                              });
                            }),
                      ),
                      Container(width: 5.0),
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Delete",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Delete buttom clicked");
                                _delete();
                              });
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context,true);
  }

  // Convert the String priority in the form of integer before saving it to Database
	void updatePriorityAsInt(String value) {
		switch (value) {
			case 'High':
				note.priority = 1;
				break;
			case 'Low':
				note.priority = 2;
				break;
		}
	}
  // Convert int priority to String priority and display it to user in DropDown
	String getPriorityAsString(int value) {
		String priority;
		switch (value) {
			case 1:
				priority = _priorities[0];  // 'High'
				break;
			case 2:
				priority = _priorities[1];  // 'Low'
				break;
		}
		return priority;
	}
  	// Update the title of Note object
  void updateTitle(){
    note.title = titlecontroller.text;
  }

	// Update the description of Note object
	void updateDescription() {
		note.description = descriptioncontroller.text;
	}

	// Save data to database
	void _save() async {

		moveToLastScreen();

		note.date = DateFormat.yMMMd().format(DateTime.now());
		int result;
		if (note.id != null) {  // Case 1: Update operation
			result = await helper.updateNote(note);
		} else { // Case 2: Insert Operation
			result = await helper.insertNote(note);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Note Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Note');
		}

	}

	void _delete() async {

		moveToLastScreen();

		// Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
		// the detail page by pressing the FAB of NoteList page.
		if (note.id == null) {
			_showAlertDialog('Status', 'No Note was deleted');
			return;
		}

		// Case 2: User is trying to delete the old note that already has a valid ID.
		int result = await helper.deleteNote(note.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Note Deleted Successfully');
		} else {
			_showAlertDialog('Status', 'Error Occured while Deleting Note');
		}
	}

	void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

}




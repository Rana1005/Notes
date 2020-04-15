import "package:flutter/material.dart";

class NoteDetails extends StatefulWidget {
  String appBarTitle;
  NoteDetails(this.appBarTitle);
  @override
  _NoteDetailsState createState() => _NoteDetailsState(this.appBarTitle);
}

class _NoteDetailsState extends State<NoteDetails> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  String appBarTitle;

  _NoteDetailsState(this.appBarTitle);

  static var _priorities = ['High', 'Low'];
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
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
                    value: "Low",
                    onChanged: (valueSelectedByuser) {
                      setState(() {
                        debugPrint("user selected $valueSelectedByuser");
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
    Navigator.pop(context);
  }
}

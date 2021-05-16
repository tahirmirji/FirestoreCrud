import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCRUDPage extends StatefulWidget {
  @override
  FirestoreCRUDPageState createState() {
    return FirestoreCRUDPageState();
  }
}

class FirestoreCRUDPageState extends State<FirestoreCRUDPage> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String name;
  String id;

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'name: ${doc.get('name')}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'todo: ${doc.get('todo')}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateData(doc),
                  child: Text('Update todo',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Name',
        fillColor: Colors.grey[300],
        filled: true
      ),
      validator: (value) 
      {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => name = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore CRUD'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Form(
            key: _formKey,
            child: buildTextFormField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
              RaisedButton(
                onPressed: id != null ? readData : null,
                child: Text('Read', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('CRUD').snapshots(),
            // ignore: missing_return
            builder: (context, snapshot) {
              try {
                if (snapshot.hasData) {
                  return Column(
                 children: 
          snapshot.data.docs.map((doc) => buildItem(doc)).toList());
                } else {
                  return Container();
                }
              } catch (e) 
              {
                print(e.toString());
              }
              return Container( height: 1.0,width: 1.0, );
            },
          )
        ],
      ),
    );
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('CRUD').add({'name': '$name', 'todo': randomTodo()});
      setState(() => id = ref.get().toString());
      print('$id');
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').doc(id).get();
  }

  Future<void> getData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').doc(id).get();
  }

  void updateData(DocumentSnapshot doks) async {
    await db.collection('CRUD').doc(doks.id).update({'todo': 'New Value As you clicked Update'});
  }

  void deleteData(DocumentSnapshot doks) async {
    await db.collection('CRUD').doc(doks.id).delete()
    .then((value) => print('Document ${doks.id} deleted successfully'));
    setState(() => id = null);
  }

  String randomTodo() {
    final randomNumber = Random().nextInt(4);
    print('TODO Random number: $randomNumber');
    String todo;
    switch (randomNumber) {
      case 1:
        todo = 'Great and reliable';
        break;
      case 2:
        todo = 'Fast data reflection ';
        break;
      case 3:
        todo = 'Firestore Fire';
        break;
      default:
        todo = 'Google\'s Firebase ecosystem';
        break;
    }
    return todo;
  }
}

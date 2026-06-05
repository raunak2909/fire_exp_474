import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  String uid;

  AddNotePage({required this.uid});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();

  FirebaseFirestore? mFirestore;

  @override
  void initState() {
    super.initState();
    mFirestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter your title here..",
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            SizedBox(height: 11),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: "Enter your description here..",
                labelText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    ///add_note
                    DocumentReference<Map<String, dynamic>> noteAdded =
                        await mFirestore!
                            .collection("users")
                            .doc(widget.uid)
                            .collection("notes")
                            .add({
                              "title": titleController.text,
                              "desc": descController.text,
                              "createdAt":
                                  DateTime.now().millisecondsSinceEpoch,
                            });

                    print("note added : ${noteAdded.id}");
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
                SizedBox(width: 11),
                OutlinedButton(onPressed: () {}, child: Text('Cancel')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_exp_474/add_note_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore? mFirestore;

  @override
  void initState() {
    super.initState();
    mFirestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: StreamBuilder(
        stream: mFirestore!.collection("notes").snapshots(),
        builder: (_, snap) {

          print(snap.connectionState);

          if(snap.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snap.hasError){
            return Center(
              child: Text("Error: ${snap.error.toString()}"),
            );
          }

          if(snap.hasData){
            return snap.data!.docs.isNotEmpty ? ListView.builder(
              itemCount: snap.data!.docs.length,
                itemBuilder: (_, index){
                Map<String, dynamic> eachNote = snap.data!.docs[index].data();
              return ListTile(
                title: Text(eachNote["title"]),
                subtitle: Text(eachNote["desc"]),
              );
            }) : Center(
              child: Text('No Notes yet!!'),
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNotePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

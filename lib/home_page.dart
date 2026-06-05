import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_exp_474/add_note_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore? mFirestore;
  String userId = "";

  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    mFirestore = FirebaseFirestore.instance;
    getUserId();
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("uid") ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: userId.isNotEmpty
          ? StreamBuilder(
              stream: mFirestore!
                  .collection("users")
                  .doc(userId)
                  .collection("notes")
                  .snapshots(),
              builder: (_, snap) {
                print(snap.connectionState);

                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snap.hasError) {
                  return Center(child: Text("Error: ${snap.error.toString()}"));
                }

                if (snap.hasData) {
                  return snap.data!.docs.isNotEmpty
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    selectedIndex = 1;
                                    setState(() {});
                                  },
                                  child: selectedIndex == 1 ? Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrangeAccent,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                    child: Text("Description", style: TextStyle(color: Colors.white),),
                                  ) : Text("Description"),
                                ),
                                InkWell(
                                  onTap: () {
                                    selectedIndex = 2;
                                    setState(() {});
                                  },
                                  child: selectedIndex == 2 ? Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child: Text("Specifications", style: TextStyle(color: Colors.white),),
                                  ) : Text("Specifications"),
                                ),
                                InkWell(
                                  onTap: () {
                                    selectedIndex = 3;
                                    setState(() {});
                                  },
                                  child: selectedIndex == 3 ? Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child: Text("Reviews", style: TextStyle(color: Colors.white),),
                                  ) : Text("Reviews"),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: snap.data!.docs.length,
                                itemBuilder: (_, index) {
                                  Map<String, dynamic> eachNote = snap
                                      .data!
                                      .docs[index]
                                      .data();
                                  return ListTile(
                                    title: Text(eachNote["title"]),
                                    subtitle: Text(eachNote["desc"]),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Center(child: Text('No Notes yet!!'));
                }

                return Container();
              },
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNotePage(uid: userId)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo/db_service/db.dart';

import 'package:flutter/material.dart';

import 'package:random_string/random_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool personal = true, college = false, office = false;
  bool suggest = false;
  final TextEditingController _textEditingController = TextEditingController();
  Stream? todoStream;

  getData() async {
    todoStream = await DatabaseService().getTask(personal
        ? "Personal"
        : college
            ? "College"
            : "Office");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getWork() {
    return StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot docSnap = snapshot.data.docs[index];
                        return CheckboxListTile(
                          activeColor: Colors.greenAccent.shade700,
                          title: Text(docSnap["work"]),
                          value: docSnap['Yes'],
                          onChanged: (newValue) async {
                            await DatabaseService().tickMethod(
                                docSnap['Id'],
                                personal
                                    ? "Personal"
                                    : college
                                        ? "College"
                                        : "Office");
                            setState(() {
                              Future.delayed(Duration(seconds: 2), () {
                                DatabaseService().removeMethod(
                                    docSnap["Id"],
                                    personal
                                        ? "Personal"
                                        : college
                                            ? "College"
                                            : "Office");
                              });
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }))
              : Center(child: Text(''));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.yellowAccent.shade700,
        onPressed: () {
          openBox();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 70, left: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            // Colors.white,
            // Colors.white38,
            // Colors.white12,

            Color.fromRGBO(0, 128, 128, 0.5),
            Color.fromRGBO(255, 215, 0, 0.75),
            Color.fromRGBO(218, 112, 214, 0.8),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hii",
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: const Text(
                "Let's Start Working",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                personal
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade200,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Personal",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          personal = true;
                          college = false;
                          office = false;
                          await getData();
                          setState(() {});
                        },
                        child: Text(
                          "Personal",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                college
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade200,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "College",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          personal = false;
                          college = true;
                          office = false;
                          await getData();
                          setState(() {});
                        },
                        child: Text(
                          "College",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                office
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade200,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Office",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          personal = false;
                          college = false;
                          office = true;
                          await getData();
                          setState(() {});
                        },
                        child: Text(
                          "Office",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 15),
            getWork(),
          ],
        ),
      ),
    );
  }

  Future openBox() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Text(
                          "Add ToDo",
                          style: TextStyle(
                            color: Colors.greenAccent.shade400,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      )),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the Task"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            String id = randomAlphaNumeric(10);
                            Map<String, dynamic> userToDo = {
                              "work": _textEditingController.text,
                              'Id': id,
                              "Yes": false,
                            };
                            personal
                                ? DatabaseService()
                                    .addPersonalTask(userToDo, id)
                                : college
                                    ? DatabaseService()
                                        .addCollegeTask(userToDo, id)
                                    : DatabaseService()
                                        .addOfficeTask(userToDo, id);
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}

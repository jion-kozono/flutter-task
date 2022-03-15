import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/task.dart';

class AddTaskPage extends StatefulWidget {
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();

  Future<void> insertTask(String title) async {
    var collection = FirebaseFirestore.instance.collection("task");
    await collection.add({
      "title": title,
      "is_done": false,
      "created_time": Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Text("タイトル"),
              ),
              Container(
                  width: 500,
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Container(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(onPressed: () {
                      insertTask(titleController.text);
                      Navigator.pop(context);
                    },
                        child: Text("追加"))),
              ),
            ],
          ),
        ));
  }
}

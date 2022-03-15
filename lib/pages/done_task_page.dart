import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_task/model/task.dart';

class DoneTaskPage extends StatefulWidget {
  @override
  State<DoneTaskPage> createState() => _DoneTaskPageState();
}

class _DoneTaskPageState extends State<DoneTaskPage> {
  TextEditingController editTitleController = TextEditingController();

  late CollectionReference tasks;

  @override
  void initState() {
    // TODO: implement initState
    tasks = FirebaseFirestore.instance.collection("task");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: tasks.snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (!snapshot.data?.docs[index].get("is_done"))
                      return Container();
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(snapshot.data?.docs[index].get("title")),
                      value: snapshot.data?.docs[index].get("is_done"),
                      onChanged: (bool? value) async {
                        await snapshot.data?.docs[index].reference.update({
                          "is_done": value,
                          "updated_time": Timestamp.now()
                        });
                      },
                      secondary: IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text("編集"),
                                      leading: Icon(Icons.edit),
                                      onTap: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SimpleDialog(
                                                titlePadding:
                                                    EdgeInsets.all(20),
                                                title: Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    children: [
                                                      Text("タイトルを編集"),
                                                      Container(
                                                          width: 500,
                                                          child: TextField(
                                                            controller:
                                                                editTitleController,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          )),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 30.0),
                                                        child: Container(
                                                          width: 200,
                                                          height: 30,
                                                          child: ElevatedButton(
                                                              onPressed: () async {
                                                                await snapshot.data?.docs[index].reference.update({
                                                                  "title": editTitleController.text,
                                                                  "updated_time": Timestamp.now(),
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              child:
                                                                  Text("編集")),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                    ListTile(
                                      title: Text("削除"),
                                      leading: Icon(Icons.delete),
                                      onTap: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "${snapshot.data?.docs[index].get("title")}を削除しますか？"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      await snapshot.data?.docs[index].reference.delete();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("はい"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("キャンセル"),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    );
                  },
                )
              : Container();
        });
  }
}

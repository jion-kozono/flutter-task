import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  late String title;
  bool isDone = false;
  late Timestamp? createdTime;
  late Timestamp? updatedTime;

  Task(
      {required this.title,
      required this.isDone,
      this.createdTime,
      this.updatedTime});
}

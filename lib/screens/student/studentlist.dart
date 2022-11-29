// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmgt/screens/student/studentedit.dart';
import 'package:pmgt/screens/student/studentforms.dart';
import 'package:pmgt/widgets/constants.dart';

class StudentList extends StatefulWidget {
  final String std;
  final String stream;
  final String year;

  const StudentList(
      {required this.std, required this.stream, required this.year, Key? key})
      : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  QuerySnapshot? students;

  bool call = false;
  List<bool> delete = [];
  List<String> ids = [];

  getStudents() async {
    await FirebaseFirestore.instance
        .collection("Students")
        .doc(widget.year)
        .collection(widget.std + widget.stream)
        .orderBy("First Name")
        .get()
        .then((value) {
      call ? null : getList(value);
      setState(() {
        students = value;
        call = true;
      });
    });
    return students;
  }

  getList(QuerySnapshot detail) {
    for (var v = 0; v < detail.docs.length; v++) {
      delete.add(false);
    }
  }

  deleteDetails() async {
    for (var v = 0; v < ids.length; v++) {
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(widget.year)
          .collection(widget.std + widget.stream)
          .doc(ids[v])
          .delete();
    }
    ids.clear();
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('Delete Student Details'),
                Text('Do you want to delete selected item?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                deleteDetails();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Student Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ids.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "New Student",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentForm(
                                      std: widget.std, stream: widget.stream)));
                        },
                        child: const Text("Add Details"),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "New Student",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentForm(
                                      std: widget.std, stream: widget.stream)));
                        },
                        child: const Text("Add Details"),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent)),
                        onPressed: () {
                          showMyDialog();
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
            const Text(
              "Tap to Edit Student Details",
              style: TextStyle(color: Colors.red, fontSize: 12.0),
            ),
            const Divider(),
            Expanded(
              child: FutureBuilder(
                future: getStudents(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("Loading Data or No data to display"),
                    );
                  }
                  return ListView.builder(
                    itemCount: students!.docs.length,
                    itemBuilder: (context, index) {
                      return Table(
                        border: const TableBorder(
                          verticalInside: BorderSide(color: Colors.black54),
                          horizontalInside: BorderSide(color: Colors.black54),
                          bottom: BorderSide(color: Colors.black54),
                          left: BorderSide(color: Colors.black54),
                          right: BorderSide(color: Colors.black54),
                          top: BorderSide(color: Colors.black54),
                        ),
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text("${index + 1}"),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentEdit(
                                                        year: widget.year,
                                                        first: students!
                                                                .docs[index]
                                                            ["First Name"],
                                                        last: students!
                                                                .docs[index]
                                                            ["Last Name"],
                                                        mother: students!
                                                                .docs[index]
                                                            ["Mother Name"],
                                                        docid: students!
                                                            .docs[index].id,
                                                        std: widget.std,
                                                        stream:
                                                            widget.stream)));
                                      },
                                      child: Text(
                                        students!.docs[index]["First Name"] +
                                            " " +
                                            students!.docs[index]["Last Name"],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                        students!.docs[index]["Mother Name"]),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Checkbox(
                                  value: delete[index],
                                  onChanged: (value) {
                                    setState(() {
                                      delete[index] = value!;
                                      delete[index]
                                          ? ids.add(students!.docs[index].id)
                                          : ids
                                              .remove(students!.docs[index].id);
                                    });
                                    print(delete);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmgt/screens/test/testdetails.dart';
import 'package:pmgt/widgets/constants.dart';

class ViewTest extends StatefulWidget {
  final String std;
  final String stream;
  final String subject;
  final String year;
  final String date;
  const ViewTest({
    required this.std,
    required this.year,
    required this.stream,
    required this.subject,
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  State<ViewTest> createState() => _ViewTestState();
}

class _ViewTestState extends State<ViewTest> {
  QuerySnapshot? tests;

  bool call = false;
  List<bool> delete = [];
  List<String> ids = [];

  getTests() async {
    await FirebaseFirestore.instance
        .collection("Tests")
        .where("Class", isEqualTo: widget.std)
        .where("Stream", isEqualTo: widget.stream)
        .where("Academic Year", isEqualTo: widget.year)
        .orderBy("Date", descending: true)
        .orderBy("Start Time")
        .get()
        .then((value) {
      call ? null : getList(value);
      setState(() {
        tests = value;
        call = true;
      });
    });
    return tests;
  }

  getList(QuerySnapshot detail) {
    for (var v = 0; v < detail.docs.length; v++) {
      delete.add(false);
    }
  }

  deleteDetails() async {
    for (var v = 0; v < ids.length; v++) {
      await FirebaseFirestore.instance.collection("Tests").doc(ids[v]).delete();
    }
    ids.clear();
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Test'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
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
        title: const Text("Test Details"),
      ),
      body: Column(
        children: [
          ids.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Stream: ${widget.stream}"),
                      Text("Class: ${widget.std}"),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Stream: ${widget.stream}"),
                      Text("Class: ${widget.std}"),
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
                ),
          const Divider(),
          Expanded(
            child: FutureBuilder(
              future: getTests(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Loading Data or No data to display"),
                  );
                }
                return ListView.builder(
                  itemCount: tests!.docs.length,
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
                              child: Center(
                                child: Text(tests!.docs[index]["Date"]),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(tests!.docs[index]["Subject"]),
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
                                              builder: (context) => TestDetails(
                                                    date: tests!.docs[index]
                                                        ["Date"],
                                                    perform: "View",
                                                    startTime:
                                                        tests!.docs[index]
                                                            ["Start Time"],
                                                    std: tests!.docs[index]
                                                        ["Class"],
                                                    stream: tests!.docs[index]
                                                        ["Stream"],
                                                    subject: tests!.docs[index]
                                                        ["Subject"],
                                                  )));
                                    },
                                    child: const Text("View"),
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
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TestDetails(
                                                    date: tests!.docs[index]
                                                        ["Date"],
                                                    perform: "Update",
                                                    startTime:
                                                        tests!.docs[index]
                                                            ["Start Time"],
                                                    std: tests!.docs[index]
                                                        ["Class"],
                                                    stream: tests!.docs[index]
                                                        ["Stream"],
                                                    subject: tests!.docs[index]
                                                        ["Subject"],
                                                  )));
                                    },
                                    child: const Text("Update"),
                                  ),
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
                                        ? ids.add(tests!.docs[index].id)
                                        : ids.remove(tests!.docs[index].id);
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
    );
  }
}

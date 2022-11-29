// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmgt/services/sms.dart';
import 'package:pmgt/widgets/constants.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class AttendanceList extends StatefulWidget {
  final String std;
  final String stream;
  final String year;
  final String date;
  final String time;
  final String subject;
  final String perform;

  const AttendanceList(
      {required this.subject,
      required this.time,
      required this.date,
      required this.std,
      required this.stream,
      required this.year,
      required this.perform,
      Key? key})
      : super(key: key);

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  QuerySnapshot? students;
  QuerySnapshot? attendance;

  bool call = false;
  bool added = false;

  List<bool> absent = [];
  List<String> phone = [];
  List<String> mom = [];

  TextEditingController message = TextEditingController();

  getStudents() async {
    await FirebaseFirestore.instance
        .collection("Students")
        .doc(widget.year)
        .collection(widget.std + "" + widget.stream)
        .where("Subjects", arrayContains: widget.subject)
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

  getAttendance() async {
    await FirebaseFirestore.instance
        .collection("Attendance")
        .doc(widget.std + " " + widget.stream + " " + widget.subject)
        .collection(widget.date + " " + widget.time)
        .orderBy("First Name")
        .get()
        .then((value) {
      setState(() {
        attendance = value;
      });
    });
    return attendance;
  }

  addAttendance() async {
    for (var v = 0; v < students!.docs.length; v++) {
      FirebaseFirestore.instance
          .collection("Attendance")
          .doc(widget.std + " " + widget.stream + " " + widget.subject)
          .set({
        "timeStamp": DateTime.now(),
      });
      if (phone.contains(students!.docs[v]["Father Phone"]) ||
          mom.contains(students!.docs[v]["Mother Phone"])) {
        await FirebaseFirestore.instance
            .collection("Attendance")
            .doc(widget.std + " " + widget.stream + " " + widget.subject)
            .collection(widget.date + " " + widget.time)
            .doc()
            .set({
          "First Name": students!.docs[v]["First Name"],
          "Last Name": students!.docs[v]["Last Name"],
          "Father Phone": students!.docs[v]["Father Phone"],
          "Attendance": "Absent",
          "timeStamp": DateTime.now(),
        });
      } else {
        await FirebaseFirestore.instance
            .collection("Attendance")
            .doc(widget.std + " " + widget.stream + " " + widget.subject)
            .collection(widget.date + " " + widget.time)
            .doc()
            .set({
          "First Name": students!.docs[v]["First Name"],
          "Last Name": students!.docs[v]["Last Name"],
          "Father Phone": students!.docs[v]["Father Phone"],
          "Attendance": "Present",
          "timeStamp": DateTime.now(),
        });
      }
      added = true;
    }
    print(message.text);
    for (var i = 0; i < phone.length; i++) {
      SMS().publish(phone[i],
          "Dear parent,\nYour ward was absent for ${widget.subject} lecture, scheduled on ${widget.date}.\nCHTEDU");
    }
    for (var i = 0; i < mom.length; i++) {
      SMS().publish(mom[i],
          "Dear parent,\nYour ward was absent for ${widget.subject} lecture, scheduled on ${widget.date}.\nCHTEDU");
    }
    if (added) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: ((context) => AttendanceList(
                  date: widget.date,
                  perform: "View",
                  std: widget.std,
                  stream: widget.stream,
                  subject: widget.subject,
                  time: widget.time,
                  year: widget.year,
                ))),
      );
    }
  }

  getList(QuerySnapshot students) {
    for (var v = 0; v < students.docs.length; v++) {
      absent.add(false);
    }
  }

  Future<void> saveLaunch(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$fileName');
    print('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("File Location: $path/$fileName"),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = "Sr. No";
    header.cells[1].value = "Name";
    header.cells[2].value = "Attendance";

    for (var v = 0; v < attendance!.docs.length; v++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = "${v + 1}";
      row.cells[1].value =
          "${attendance!.docs[v]["First Name"] + " " + attendance!.docs[v]["Last Name"]}";
      row.cells[2].value = "${attendance!.docs[v]["Attendance"]}";
    }

    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 0, 0, 0));

    List<int> bytes = document.save();
    document.dispose();

    saveLaunch(bytes,
        '${widget.date}_${widget.subject}_${widget.std}_${widget.stream}.pdf');
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attendance Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text('Type your message here'),
                TextField(
                  controller: message,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                addAttendance();
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
        title: widget.perform == "Add"
            ? const Text("Attendance Sheet")
            : const Text("Attendance Details"),
        actions: [
          widget.perform == "View"
              ? IconButton(
                  onPressed: () {
                    createPDF();
                  },
                  icon: const Icon(Icons.download),
                  tooltip: "Download PDF",
                )
              : Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Subject: ${widget.subject}",
                    ),
                    Text("Class: ${widget.std} ${widget.stream}"),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Date: ${widget.date}",
                    ),
                    Text("Time: ${widget.time}"),
                  ],
                ),
                widget.perform == "Add"
                    ? ElevatedButton(
                        onPressed: () {
                          showMyDialog();
                        },
                        child: const Text("Update"),
                      )
                    : Container(),
              ],
            ),
            const Divider(),
            widget.perform == "Add"
                ? Expanded(
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
                              horizontalInside:
                                  BorderSide(color: Colors.black54),
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
                                        child: Text(students!.docs[index]
                                            ["First Name"]),
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
                                            students!.docs[index]["Last Name"]),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Checkbox(
                                      value: absent[index],
                                      onChanged: (value) {
                                        setState(() {
                                          var no = students!.docs[index]
                                              ["Father Phone"];
                                          absent[index] = value!;
                                          absent[index]
                                              ? phone.add(no)
                                              : phone.remove(no);

                                          var m = students!.docs[index]
                                              ["Mother Phone"];
                                          absent[index] = value;
                                          absent[index]
                                              ? mom.add(m)
                                              : mom.remove(m);
                                        });
                                        print(absent);
                                        print(phone);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ))
                : Expanded(
                    child: FutureBuilder(
                      future: getAttendance(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Loading Data or No data to display"),
                          );
                        }
                        return ListView.builder(
                          itemCount: attendance!.docs.length,
                          itemBuilder: (context, index) {
                            return Table(
                              border: const TableBorder(
                                verticalInside:
                                    BorderSide(color: Colors.black54),
                                horizontalInside:
                                    BorderSide(color: Colors.black54),
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
                                          child: Text(attendance!.docs[index]
                                              ["First Name"]),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(attendance!.docs[index]
                                              ["Last Name"]),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(attendance!.docs[index]
                                              ["Attendance"]),
                                        ),
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

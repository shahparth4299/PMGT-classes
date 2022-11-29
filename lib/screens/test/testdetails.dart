// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmgt/services/sms.dart';
import 'package:pmgt/widgets/constants.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class TestDetails extends StatefulWidget {
  final String std;
  final String stream;
  final String subject;
  final String date;
  final String startTime;
  final String perform;
  const TestDetails({
    required this.date,
    required this.perform,
    required this.std,
    required this.stream,
    required this.startTime,
    required this.subject,
    Key? key,
  }) : super(key: key);

  @override
  State<TestDetails> createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  QuerySnapshot? details;

  bool call = false;
  bool added = false;

  List<bool> absent = [];
  List<String> phone = [];
  List<String> marks = [];

  getDetails() async {
    await FirebaseFirestore.instance
        .collection("Test Details")
        .doc(widget.std + " " + widget.stream + " " + widget.subject)
        .collection(widget.date + " " + widget.startTime)
        .orderBy("First Name")
        .get()
        .then((value) {
      call ? null : getList(value);
      setState(() {
        details = value;
        call = true;
      });
    });
    return details;
  }

  addTestDeatils() async {
    for (var v = 0; v < details!.docs.length; v++) {
      await FirebaseFirestore.instance
          .collection("Test Details")
          .doc(widget.std + " " + widget.stream + " " + widget.subject)
          .collection(widget.date + " " + widget.startTime)
          .doc(details!.docs[v]["Student Phone"] +
              " " +
              details!.docs[v]["First Name"])
          .update({
        "Marks": marks[v] == "" ? details!.docs[v]["Marks"] : marks[v],
        "Attendance": absent[v] ? "Absent" : "Present",
      });
      added = true;
    }

    if (added) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: ((context) => TestDetails(
                  date: widget.date,
                  perform: "View",
                  std: widget.std,
                  stream: widget.stream,
                  subject: widget.subject,
                  startTime: widget.startTime,
                ))),
      );
    }
  }

  getList(QuerySnapshot detail) {
    for (var v = 0; v < detail.docs.length; v++) {
      detail.docs[v]["Attendance"] == "Absent"
          ? absent.add(true)
          : absent.add(false);
      phone.add(detail.docs[v]["Father Phone"]);
      marks.add("");
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

  sendSMS() {
    for (var v = 0; v < details!.docs.length; v++) {
      SMS().publish(details!.docs[v]["Mother Phone"],
          "Dear parents,\nYour ward has scored ${details!.docs[v]["Marks"]} in ${widget.subject} test, scheduled on ${widget.date}\nCHTEDU"
          // "Test Score\nClass: ${widget.std} ${widget.stream} Subject: ${widget.subject} scheduled on ${widget.date}\nYour ward has scored ${details!.docs[v]["Marks"]}\n-Preeti Miss Group Tuitions"
          );
      SMS().publish(details!.docs[v]["Father Phone"],
          "Dear parents,\nYour ward has scored ${details!.docs[v]["Marks"]} in ${widget.subject} test, scheduled on ${widget.date}\nCHTEDU"
          // "Test Score\nClass: ${widget.std} ${widget.stream} Subject: ${widget.subject} scheduled on ${widget.date}\nYour ward has scored ${details!.docs[v]["Marks"]}\n-Preeti Miss Group Tuitions"
          );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("SMS Sent"),
        duration: Duration(seconds: 5),
      ),
    );
  }

  Future<void> createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 4);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = "Sr. No";
    header.cells[1].value = "Name";
    header.cells[2].value = "Attendance";
    header.cells[3].value = "Marks";

    for (var v = 0; v < details!.docs.length; v++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = "${v + 1}";
      row.cells[1].value =
          "${details!.docs[v]["First Name"] + " " + details!.docs[v]["Last Name"]}";
      row.cells[2].value = "${details!.docs[v]["Attendance"]}";
      row.cells[3].value = "${details!.docs[v]["Marks"]}";
    }

    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 0, 0, 0));

    List<int> bytes = document.save();
    document.dispose();

    saveLaunch(bytes,
        '${widget.date}_${widget.subject}_${widget.std}_${widget.stream}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Test Details"),
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
          widget.perform == "View"
              ? IconButton(
                  onPressed: () {
                    sendSMS();
                  },
                  icon: const Icon(Icons.message),
                  tooltip: "Send SMS",
                )
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "Subject: ${widget.subject}",
                  ),
                  Text(
                      "Class: ${widget.std} ${widget.stream} -- Date: ${widget.date}"),
                ],
              ),
              widget.perform == "Update"
                  ? ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor)),
                      onPressed: () {
                        addTestDeatils();
                      },
                      child: const Text("Update"),
                    )
                  : Container(),
            ],
          ),
          // widget.perform == "Update"
          //     ? const Text(
          //         "Uncheck For Present",
          //         style: TextStyle(fontSize: 12.0, color: Colors.red),
          //       )
          //     : const Text(""),
          const Divider(),
          Expanded(
            child: FutureBuilder(
              future: getDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Loading Data or No data to display"),
                  );
                }
                return ListView.builder(
                  itemCount: details!.docs.length,
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
                                child: Text("${index + 1}"),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(details!.docs[index]
                                          ["First Name"] +
                                      " " +
                                      details!.docs[index]["Last Name"]),
                                ),
                              ),
                            ),
                            widget.perform == "View"
                                ? TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                            details!.docs[index]["Attendance"]),
                                      ),
                                    ),
                                  )
                                : TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Checkbox(
                                      value: absent[index],
                                      onChanged: (value) {
                                        setState(() {
                                          absent[index] = value!;
                                        });
                                        print(absent);
                                        print(phone);
                                      },
                                    ),
                                  ),
                            widget.perform == "View"
                                ? TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child:
                                            Text(details!.docs[index]["Marks"]),
                                      ),
                                    ),
                                  )
                                : TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0, bottom: 10.0),
                                      child: Center(
                                        child: TextFormField(
                                          initialValue: details!.docs[index]
                                              ["Marks"],
                                          keyboardType: TextInputType.number,
                                          maxLength: 3,
                                          onChanged: (value) {
                                            setState(() {
                                              if (absent[index]) {
                                                marks[index] = "0";
                                              } else {
                                                marks[index] = value;
                                              }
                                            });
                                            print(marks);
                                          },
                                        ),
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
    );
  }
}

// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmgt/screens/test/viewtest.dart';
import 'package:pmgt/services/sms.dart';
import 'package:pmgt/widgets/constants.dart';

class CreateTest extends StatefulWidget {
  final String perform;
  const CreateTest({required this.perform, Key? key}) : super(key: key);

  @override
  State<CreateTest> createState() => _CreateTestState();
}

class _CreateTestState extends State<CreateTest> {
  String stream = "Arts";
  String std = "XI";
  String subject = "English";

  var years = [
    "2022-2023",
    "2023-2024",
    "2024-2025",
    "2025-2026",
    "2026-2027",
    "2027-2028",
    "2028-2029",
    "2029-2030",
    "2030-2031",
    "2031-2032",
    "2032-2033",
    "2033-2034",
    "2034-2035",
    "2035-2036",
    "2036-2037",
    "2037-2038"
  ];
  List<String> arts = [
    "English",
    "Hindi",
    "Maths",
    "I.T.",
    "French",
    "Economics",
    "Sociology",
    "Psycology",
    "Logic",
    "Philosophy",
    "Pol. Science",
    "History",
    "Geography",
  ];
  List<String> commerce = [
    "English",
    "Hindi",
    "I.T.",
    "Economics",
    "French",
    "Maths",
    "Accounts",
    "O.C.",
    "S.P.",
  ];

  String message = "";
  String academicyear = "2022-2023";
  DateTime date = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  _selectDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.perform == "Create" ? DateTime.now() : DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (selected != null && selected != date) {
      setState(() {
        date = selected;
      });
    }
  }

  _startTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: startTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != startTime) {
      setState(() {
        startTime = timeOfDay;
      });
    }
  }

  _endTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: endTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != endTime) {
      setState(() {
        endTime = timeOfDay;
      });
    }
  }

  createTest() async {
    await FirebaseFirestore.instance.collection("Tests").doc().set({
      "Class": std,
      "Stream": stream,
      "Subject": subject,
      "Start Time": "${startTime.hour}:${startTime.minute}",
      "End Time": "${endTime.hour}:${endTime.minute}",
      "Date": date.toString().substring(0, 11),
      "Academic Year": academicyear,
    }).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Test Created"),
          duration: Duration(seconds: 3),
        ),
      );
    });
    await FirebaseFirestore.instance
        .collection("Students")
        .doc(academicyear)
        .collection(std + "" + stream)
        .where("Subjects", arrayContains: subject)
        .orderBy("First Name")
        .get()
        .then((value) {
      QuerySnapshot students = value;
      FirebaseFirestore.instance
          .collection("Test Details")
          .doc(std + " " + stream + " " + subject)
          .set({"timeStamp": DateTime.now()});
      for (var v = 0; v < students.docs.length; v++) {
        FirebaseFirestore.instance
            .collection("Test Details")
            .doc(std + " " + stream + " " + subject)
            .collection(date.toString().substring(0, 11) +
                " ${startTime.hour}:${startTime.minute}")
            .doc(students.docs[v]["Student Phone"] +
                " " +
                students.docs[v]["First Name"])
            .set({
          "First Name": students.docs[v]["First Name"],
          "Last Name": students.docs[v]["Last Name"],
          "Father Phone": students.docs[v]["Father Phone"],
          "Student Phone": students.docs[v]["Student Phone"],
          "Attendance": "",
          "Marks": "",
        });

        SMS().publish(students.docs[v]["Father Phone"],
            "Dear students,\nTest for subject $subject has been scheduled on ${date.toString().substring(0, 11)}, timing ${startTime.hour}.${startTime.minute}\nCHTEDU"
            // "Test Scheduled for Subject:$subject, Class: $std-$stream on ${date.toString().substring(0, 11)} ${startTime.hour}:${startTime.minute}. \nAll the best!\n-Preeti Miss Group Tuitions."
            );

        SMS().publish(students.docs[v]["Mother Phone"],
            "Dear students,\nTest for subject $subject has been scheduled on ${date.toString().substring(0, 11)}, timing ${startTime.hour}.${startTime.minute}\nCHTEDU"
            // "Test Scheduled for Subject:$subject, Class: $std-$stream on ${date.toString().substring(0, 11)} ${startTime.hour}:${startTime.minute}. \nAll the best!\n-Preeti Miss Group Tuitions."
            );
      }
    });
  }

  viewTest() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => ViewTest(
                  std: std,
                  stream: stream,
                  subject: subject,
                  year: academicyear,
                  date: date.toString().substring(0, 11),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: widget.perform == "Create"
            ? const Text("Create Test")
            : const Text("View Test"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.1),
                  width: MediaQuery.of(context).size.height * (1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset("assets/logo-removebg.png"),
                      const Text(
                        "Preeti Miss - Group Tuitions\nTests",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * (0.02)),
                widget.perform == "Create"
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Center(child: Text("Date")),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                  ),
                                  onPressed: () {
                                    _selectDate();
                                  },
                                  child: Text(date.toString().substring(0, 11)),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Center(child: Text("Start Time")),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                  ),
                                  onPressed: () {
                                    _startTime();
                                  },
                                  child: Text(
                                      "${startTime.hour}:${startTime.minute}"),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Center(child: Text("End Time")),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                  ),
                                  onPressed: () {
                                    _endTime();
                                  },
                                  child:
                                      Text("${endTime.hour}:${endTime.minute}"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(height: MediaQuery.of(context).size.height * (0.02)),
                widget.perform == "Create"
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Center(child: Text("Academic Year")),
                                Center(
                                  child: DropdownButton(
                                    value: academicyear,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: years.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        academicyear = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Center(child: Text("Subject Name")),
                                stream == "Arts"
                                    ? Center(
                                        child: DropdownButton(
                                          value: subject,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: arts.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              subject = value.toString();
                                            });
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: DropdownButton(
                                          value: subject,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: commerce.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              subject = value.toString();
                                            });
                                          },
                                        ),
                                      ),
                              ],
                            )
                          ],
                        ),
                      )
                    : Center(
                        child: Column(
                          children: [
                            const Center(child: Text("Academic Year")),
                            Center(
                              child: DropdownButton(
                                value: academicyear,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: years.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    academicyear = value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                const Divider(),
                const Text("Select Class",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Radio(
                      value: "XI",
                      groupValue: std,
                      onChanged: (value) {
                        setState(() {
                          std = value.toString();
                        });
                      },
                    ),
                    const Text("XI")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: "XII",
                      groupValue: std,
                      onChanged: (value) {
                        setState(() {
                          std = value.toString();
                        });
                      },
                    ),
                    const Text("XII")
                  ],
                ),
                const Divider(),
                SizedBox(height: MediaQuery.of(context).size.height * (0.02)),
                const Text("Select Stream",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Radio(
                      value: "Arts",
                      groupValue: stream,
                      onChanged: (value) {
                        setState(() {
                          stream = value.toString();
                        });
                      },
                    ),
                    const Text("Arts")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: "Commerce",
                      groupValue: stream,
                      onChanged: (value) {
                        setState(() {
                          stream = value.toString();
                        });
                      },
                    ),
                    const Text("Commerce")
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * (0.02)),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
                    onPressed: () {
                      widget.perform == "Create" ? createTest() : viewTest();
                    },
                    child: widget.perform == "Create"
                        ? const Text("Create Test")
                        : const Text("View Tests"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

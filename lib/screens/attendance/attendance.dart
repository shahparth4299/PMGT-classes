import 'package:flutter/material.dart';
import 'package:pmgt/screens/attendance/attendancelist.dart';
import 'package:pmgt/widgets/constants.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
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
    "Other"
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
    "Other"
  ];

  String academicyear = "2022-2023";
  DateTime date = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  _selectDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != date) {
      setState(() {
        date = selected;
      });
    }
  }

  _selectTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      "Preeti Miss - Group Tuitions\n Attendance",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (0.02)),
              Center(
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
                        const Center(child: Text("Time")),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          onPressed: () {
                            _selectTime();
                          },
                          child: Text(
                              "${selectedTime.hour}:${selectedTime.minute}"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (0.02)),
              Center(
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
                                  icon: const Icon(Icons.keyboard_arrow_down),
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
                                  icon: const Icon(Icons.keyboard_arrow_down),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttendanceList(
                                std: std,
                                stream: stream,
                                year: academicyear,
                                date: date.toString().substring(0, 11),
                                subject: subject,
                                perform: "Add",
                                time:
                                    "${selectedTime.hour}:${selectedTime.minute}",
                              ),
                            ));
                      },
                      child: const Text("Add Attendance"),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttendanceList(
                                std: std,
                                stream: stream,
                                year: academicyear,
                                date: date.toString().substring(0, 11),
                                subject: subject,
                                time:
                                    "${selectedTime.hour}:${selectedTime.minute}",
                                perform: "View",
                              ),
                            ));
                      },
                      child: const Text("View Attendance"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

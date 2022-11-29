import 'package:flutter/material.dart';
import 'package:pmgt/screens/student/studentlist.dart';
import 'package:pmgt/widgets/constants.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  String stream = "Arts";
  String std = "XI";

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

  String academicyear = "2022-2023";

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
                      "Preeti Miss - Group Tuitions\nStudents Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (0.02)),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentList(
                                std: std, stream: stream, year: academicyear)));
                  },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

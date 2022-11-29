// ignore_for_file: avoid_print, unnecessary_string_escapes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmgt/widgets/constants.dart';

class StudentEdit extends StatefulWidget {
  final String std;
  final String stream;
  final String year;
  final String first;
  final String last;
  final String mother;
  final String docid;

  const StudentEdit(
      {required this.year,
      required this.first,
      required this.last,
      required this.mother,
      required this.std,
      required this.stream,
      required this.docid,
      Key? key})
      : super(key: key);

  @override
  State<StudentEdit> createState() => _StudentEditState();
}

class _StudentEditState extends State<StudentEdit> {
  final _formKey = GlobalKey<FormState>();

  DateTime date = DateTime.now();
  String board = "H.S.C";
  String academicyear = "2022-2023";
  String gender = "Male";
  List<String> subjects = [];

  bool english = false;
  bool hindi = false;
  bool it = false;
  bool french = false;
  bool eco = false;
  bool socio = false;
  bool psyc = false;
  bool polsc = false;
  bool logic = false;
  bool phil = false;
  bool hist = false;
  bool geo = false;
  bool maths = false;
  bool acc = false;
  bool oc = false;
  bool sp = false;

  var genders = ["Male", "Female", "Other"];
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

  TextEditingController fname = TextEditingController();
  TextEditingController mname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController mother = TextEditingController();
  TextEditingController phone1 = TextEditingController();
  TextEditingController phone2 = TextEditingController();
  TextEditingController phone3 = TextEditingController();
  TextEditingController college = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();

  _selectDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != date) {
      setState(() {
        date = selected;
      });
    }
  }

  Future formValidate() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection("Students")
            .doc(academicyear)
            .set({"lastUpdated": DateTime.now()});
        print(widget.docid);
        await FirebaseFirestore.instance
            .collection("Students")
            .doc(academicyear)
            .collection(widget.std + "" + widget.stream)
            .doc(widget.docid)
            .update({
          "First Name": fname.text,
          "Middle Name": mname.text,
          "Last Name": lname.text,
          "Mother Name": mother.text,
          "Student Phone": phone1.text,
          "Father Phone": phone2.text,
          "Mother Phone": phone3.text,
          "Address": address.text,
          "College": college.text,
          "City": city.text,
          "Pincode": pincode.text,
          "Stream": widget.stream,
          "Class": widget.std,
          "DOB": date.toString().substring(0, 11),
          "Academic Year": academicyear,
          "Gender": gender,
          "Board": board,
          "Subjects": subjects,
          "timeStamp": DateTime.now()
        });
        fname.clear();
        mname.clear();
        lname.clear();
        mother.clear();
        address.clear();
        college.clear();
        phone1.clear();
        phone2.clear();
        phone3.clear();
        city.clear();
        pincode.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Form Submitted Successfully"),
            duration: Duration(milliseconds: 300),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection("Students")
        .doc(academicyear)
        .collection(widget.std + widget.stream)
        .where("First Name", isEqualTo: widget.first)
        .where("Last Name", isEqualTo: widget.last)
        .where("Mother Name", isEqualTo: widget.mother)
        .get()
        .then((value) {
      print(value.size);
      print(value.metadata.toString());
      print(value.docs.first.id);
      setState(() {
        academicyear = value.docs[0]["Academic Year"];
        gender = value.docs[0]["Gender"];
        fname.text = value.docs[0]["First Name"];
        lname.text = value.docs[0]["Last Name"];
        mname.text = value.docs[0]["Middle Name"];
        mother.text = value.docs[0]["Mother Name"];
        phone1.text = value.docs[0]["Student Phone"];
        phone2.text = value.docs[0]["Father Phone"];
        phone3.text = value.docs[0]["Mother Phone"];
        address.text = value.docs[0]["Address"];
        city.text = value.docs[0]["City"];
        pincode.text = value.docs[0]["Pincode"];
        college.text = value.docs[0]["College"];
        date = DateFormat("yyyy-MM-dd").parse(value.docs[0]["DOB"]);
        if (value.docs[0]["Subjects"].contains("English")) {
          english = true;
          subjects.add("English");
        }
        if (value.docs[0]["Subjects"].contains("Hindi")) {
          hindi = true;
          subjects.add("Hindi");
        }
        if (value.docs[0]["Subjects"].contains("French")) {
          french = true;
          subjects.add("French");
        }
        if (value.docs[0]["Subjects"].contains("Psychology")) {
          psyc = true;
          subjects.add("Psychology");
        }
        if (value.docs[0]["Subjects"].contains("S.P.")) {
          sp = true;
          subjects.add("S.P.");
        }
        if (value.docs[0]["Subjects"].contains("Economics")) {
          eco = true;
          subjects.add("Economics");
        }
        if (value.docs[0]["Subjects"].contains("Logic")) {
          logic = true;
          subjects.add("Logic");
        }
        if (value.docs[0]["Subjects"].contains("Sociology")) {
          socio = true;
          subjects.add("Sociology");
        }
        if (value.docs[0]["Subjects"].contains("Philosophy")) {
          phil = true;
          subjects.add("Philosophy");
        }
        if (value.docs[0]["Subjects"].contains("Geography")) {
          geo = true;
          subjects.add("Geography");
        }
        if (value.docs[0]["Subjects"].contains("History")) {
          hist = true;
          subjects.add("History");
        }
        if (value.docs[0]["Subjects"].contains("Pol. Science")) {
          polsc = true;
          subjects.add("Pol. Science");
        }
        if (value.docs[0]["Subjects"].contains("O.C.")) {
          oc = true;
          subjects.add("O.C.");
        }
        if (value.docs[0]["Subjects"].contains("I.T.")) {
          it = true;
          subjects.add("I.T.");
        }
        if (value.docs[0]["Subjects"].contains("Maths")) {
          maths = true;
          subjects.add("Maths");
        }
        if (value.docs[0]["Subjects"].contains("Accounts")) {
          acc = true;
          subjects.add("Accounts");
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Student Form"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Academic Year"),
                  DropdownButton(
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
                  const SizedBox(height: 10.0),
                  const Text("Date of Birth"),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                    ),
                    onPressed: () {
                      _selectDate();
                    },
                    child: Text(date.toString().substring(0, 11)),
                  ),
                  const SizedBox(height: 10.0),
                  const Text("First Name"),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: fname,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return value!.length < 3
                          ? "Enter valid first name"
                          : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Middle Name"),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: mname,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return value!.isEmpty ? "Enter valid middle name" : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Last Name"),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: lname,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return value!.length < 3 ? "Enter valid last name" : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Gender"),
                  DropdownButton(
                    value: gender,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: genders.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Mother\'s Name"),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: mother,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return value!.length < 3 ? "Enter valid name" : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Student Phone"),
                  TextFormField(
                    controller: phone1,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      return value!.length != 10
                          ? "Enter valid phone number"
                          : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Father Phone"),
                  TextFormField(
                    controller: phone2,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      return value!.length != 10
                          ? "Enter valid phone number"
                          : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Mother Phone"),
                  TextFormField(
                    controller: phone3,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      return value!.length != 10
                          ? "Enter valid phone number"
                          : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("College Name"),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: college,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return value!.length < 4
                          ? "Enter valid College Name"
                          : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Address"),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: address,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    maxLines: 3,
                    validator: (value) {
                      return value!.length < 15 ? "Enter valid address" : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("City"),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: city,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return value!.length < 3 ? "Enter valid city" : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Pincode"),
                  TextFormField(
                    controller: pincode,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return value!.length != 6 ? "Enter valid pincode" : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Divider(),
                  const Text("Subjects"),
                  widget.stream == "Arts"
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: english,
                                  onChanged: (value) {
                                    setState(() {
                                      english = value!;
                                      english
                                          ? subjects.add("English")
                                          : subjects.remove("English");
                                    });
                                  },
                                ),
                                const Text("English"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: hindi,
                                  onChanged: (value) {
                                    setState(() {
                                      hindi = value!;
                                      hindi
                                          ? subjects.add("Hindi")
                                          : subjects.remove("Hindi");
                                    });
                                  },
                                ),
                                const Text("Hindi"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: eco,
                                  onChanged: (value) {
                                    setState(() {
                                      eco = value!;
                                      eco
                                          ? subjects.add("Economics")
                                          : subjects.remove("Economics");
                                    });
                                  },
                                ),
                                const Text("Economics"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: logic,
                                  onChanged: (value) {
                                    setState(() {
                                      logic = value!;
                                      logic
                                          ? subjects.add("Logic")
                                          : subjects.remove("Logic");
                                    });
                                  },
                                ),
                                const Text("Logic"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: psyc,
                                  onChanged: (value) {
                                    setState(() {
                                      psyc = value!;
                                      psyc
                                          ? subjects.add("Psychology")
                                          : subjects.remove("Psychology");
                                    });
                                  },
                                ),
                                const Text("Psychology"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: phil,
                                  onChanged: (value) {
                                    setState(() {
                                      phil = value!;
                                      phil
                                          ? subjects.add("Philosophy")
                                          : subjects.remove("Philosophy");
                                    });
                                  },
                                ),
                                const Text("Philosophy"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: it,
                                  onChanged: (value) {
                                    setState(() {
                                      it = value!;
                                      it
                                          ? subjects.add("I.T.")
                                          : subjects.remove("I.T.");
                                    });
                                  },
                                ),
                                const Text("I.T."),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: french,
                                  onChanged: (value) {
                                    setState(() {
                                      french = value!;
                                      french
                                          ? subjects.add("French")
                                          : subjects.remove("French");
                                    });
                                  },
                                ),
                                const Text("French"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: socio,
                                  onChanged: (value) {
                                    setState(() {
                                      socio = value!;
                                      socio
                                          ? subjects.add("Sociology")
                                          : subjects.remove("Sociology");
                                    });
                                  },
                                ),
                                const Text("Sociology"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: polsc,
                                  onChanged: (value) {
                                    setState(() {
                                      polsc = value!;
                                      polsc
                                          ? subjects.add("Pol. Science")
                                          : subjects.remove("Pol. Science");
                                    });
                                  },
                                ),
                                const Text("Pol. Science"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: hist,
                                  onChanged: (value) {
                                    setState(() {
                                      hist = value!;
                                      hist
                                          ? subjects.add("History")
                                          : subjects.remove("History");
                                    });
                                  },
                                ),
                                const Text("History"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: geo,
                                  onChanged: (value) {
                                    setState(() {
                                      geo = value!;
                                      geo
                                          ? subjects.add("Geography")
                                          : subjects.remove("Geography");
                                    });
                                  },
                                ),
                                const Text("Geography"),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: english,
                                  onChanged: (value) {
                                    setState(() {
                                      english = value!;
                                      english
                                          ? subjects.add("English")
                                          : subjects.remove("English");
                                    });
                                  },
                                ),
                                const Text("English"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: hindi,
                                  onChanged: (value) {
                                    setState(() {
                                      hindi = value!;
                                      hindi
                                          ? subjects.add("Hindi")
                                          : subjects.remove("Hindi");
                                    });
                                  },
                                ),
                                const Text("Hindi"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: eco,
                                  onChanged: (value) {
                                    setState(() {
                                      eco = value!;
                                      eco
                                          ? subjects.add("Economics")
                                          : subjects.remove("Economics");
                                    });
                                  },
                                ),
                                const Text("Economics"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: it,
                                  onChanged: (value) {
                                    setState(() {
                                      it = value!;
                                      it
                                          ? subjects.add("I.T.")
                                          : subjects.remove("I.T.");
                                    });
                                  },
                                ),
                                const Text("I.T."),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: french,
                                  onChanged: (value) {
                                    setState(() {
                                      french = value!;
                                      french
                                          ? subjects.add("French")
                                          : subjects.remove("French");
                                    });
                                  },
                                ),
                                const Text("French"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: maths,
                                  onChanged: (value) {
                                    setState(() {
                                      maths = value!;
                                      maths
                                          ? subjects.add("Maths")
                                          : subjects.remove("Maths");
                                    });
                                  },
                                ),
                                const Text("Maths"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: oc,
                                  onChanged: (value) {
                                    setState(() {
                                      oc = value!;
                                      oc
                                          ? subjects.add("O.C.")
                                          : subjects.remove("O.C.");
                                    });
                                  },
                                ),
                                const Text("O.C."),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: acc,
                                  onChanged: (value) {
                                    setState(() {
                                      acc = value!;
                                      acc
                                          ? subjects.add("Accounts")
                                          : subjects.remove("Accounts");
                                    });
                                  },
                                ),
                                const Text("Accounts"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: sp,
                                  onChanged: (value) {
                                    setState(() {
                                      sp = value!;
                                      sp
                                          ? subjects.add("S.P.")
                                          : subjects.remove("S.P.");
                                    });
                                    print(subjects);
                                  },
                                ),
                                const Text("S.P."),
                              ],
                            ),
                          ],
                        ),
                  subjects.isEmpty
                      ? const Center(
                          child: Text(
                            "Please select a subject!",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : const Text(""),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                      ),
                      onPressed: () {
                        formValidate();
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

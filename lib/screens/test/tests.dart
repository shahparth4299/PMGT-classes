import 'package:flutter/material.dart';
import 'package:pmgt/screens/test/createtest.dart';
import 'package:pmgt/widgets/constants.dart';

class Tests extends StatefulWidget {
  const Tests({Key? key}) : super(key: key);

  @override
  State<Tests> createState() => _TestsState();
}

class _TestsState extends State<Tests> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const Divider(),
              const Text("Creat Test"),
              SizedBox(height: MediaQuery.of(context).size.height * (0.02)),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateTest(
                                perform: "Create",
                              )));
                },
                child: const Text("Create Test"),
              ),
              const Divider(),
              const Text("View Test"),
              SizedBox(height: MediaQuery.of(context).size.height * (0.02)),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateTest(
                                perform: "View",
                              )));
                },
                child: const Text("View Test"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

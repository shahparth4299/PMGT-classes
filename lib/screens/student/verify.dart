import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pmgt/screens/home.dart';
import 'package:pmgt/services/sms.dart';
import 'package:pmgt/widgets/constants.dart';

class Verify extends StatefulWidget {
  final String father;
  final bool f;
  final String student;
  final bool s;
  const Verify(
      {required this.f,
      required this.s,
      required this.father,
      required this.student,
      Key? key})
      : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  TextEditingController fOtp = TextEditingController();
  TextEditingController sOtp = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  validate() {
    if (_formKey.currentState!.validate()) {
      SMS().verify(widget.father, fOtp.text);
      SMS().publish(widget.father, "Welcome to Preeti Miss Group Tuitions");
      SMS().verify(widget.student, sOtp.text);
      SMS().publish(widget.father, "Welcome to Preeti Miss Group Tuitions");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Verify",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.f
                    ? Text("Phone Number +${widget.father} already verified!")
                    : Text("Enter OTP sent on +${widget.father}"),
                widget.f
                    ? Container()
                    : TextFormField(
                        controller: fOtp,
                        validator: (value) {
                          return value!.length < 6 ? "Enter correct OTP" : null;
                        },
                        maxLength: 6,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                const Divider(),
                widget.s
                    ? Text(
                        "Phone Number +91${widget.student} already verified!")
                    : Text("Enter OTP sent on +91${widget.student}"),
                widget.s
                    ? Container()
                    : TextFormField(
                        controller: sOtp,
                        validator: (value) {
                          return value!.length < 6 ? "Enter correct OTP" : null;
                        },
                        maxLength: 6,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                const Divider(),
                ElevatedButton(
                  onPressed: () {
                    validate();
                  },
                  child: const Text("Verify"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Student Registered Successfully"),
                        duration: Duration(milliseconds: 300),
                      ),
                    );
                  },
                  child: const Text("Return"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

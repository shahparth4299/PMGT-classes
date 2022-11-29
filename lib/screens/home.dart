import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pmgt/screens/attendance/attendance.dart';
import 'package:pmgt/screens/student/student.dart';
import 'package:pmgt/screens/test/tests.dart';
import 'package:pmgt/services/auth.dart';
import 'package:pmgt/services/authenticate.dart';
import 'package:pmgt/widgets/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    // HomePage(),
    Student(),
    Tests(),
    Attendance(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: _selectedIndex == 0
            ? Text(
                "Students",
                style: GoogleFonts.poppins(),
              )
            : _selectedIndex == 1
                ? Text(
                    "Test",
                    style: GoogleFonts.poppins(),
                  )
                : Text(
                    "Attendance",
                    style: GoogleFonts.poppins(),
                  ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: "Logout",
            onPressed: () {
              AuthService().signOut().then((value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Authenticate())));
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedIconTheme:
            const IconThemeData(color: kPrimaryColor, opacity: 4.0),
        selectedItemColor: kPrimaryColor,
        unselectedIconTheme:
            const IconThemeData(color: Colors.black, opacity: 2.0),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //   icon: LineIcon(LineIcons.home),
          //   label: 'Home',
          // ),
          BottomNavigationBarItem(
            icon: LineIcon(LineIcons.userGraduate),
            label: 'Student',
          ),
          BottomNavigationBarItem(
            icon: LineIcon(LineIcons.school),
            label: 'Tests',
          ),
          BottomNavigationBarItem(
            icon: LineIcon(LineIcons.university),
            label: 'Attendance',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

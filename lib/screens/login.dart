import 'package:animate_do/animate_do.dart';
import 'package:bio_spot_check/auth/facedetectionview.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Api/Api.dart';
import '../auth/FDF.dart';
import '../auth/person.dart';
import '../models/attendance_model.dart';
import '../screens/frf.dart';
import 'attendance_page.dart';

TextEditingController usr = TextEditingController();
TextEditingController pass = TextEditingController();
TextEditingController usrid = TextEditingController();
double attendancePercentage = 0;
int attendancePercent = 0;
Future<void> requestCameraPermission() async {
  // Check if camera permission is granted
  PermissionStatus status = await Permission.camera.status;

  if (status.isDenied) {
    // If permission is denied, request it
    status = await Permission.camera.request();
  }

  if (status.isDenied) {
    // If permission is still denied, show a message or handle accordingly
  } else if (status.isGranted) {
    // Permission is granted, you can proceed with using the camera
  }
}


class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<AttendanceEntry> _attendanceData = [];
  bool _isLoading = true;
  late DateTime _selectedDate;
  double totalHours = 0;

  Future<void> _fetchDataForUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _attendanceData = await ApiService.fetchAttendanceData(usrid.text);
      _calculateTotalHoursAndAttendance();  // Calculate after fetching
    } catch (e) {
      print('Failed to load data: $e');
      _attendanceData = [];
      totalHours = 0; // Reset total hours if fetch fails
      attendancePercentage = 0; // Reset attendance percentage
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _calculateTotalHoursAndAttendance() async {
    await Future<void>.delayed(Duration.zero); // Simulate an asynchronous operation
    int totalMinutes = _attendanceData.fold(0, (sum, entry) {
      var duration = Duration(hours: entry.timeOut.hour - entry.timeIn.hour,
          minutes: entry.timeOut.minute - entry.timeIn.minute);
      return sum + duration.inMinutes; // Calculate in minutes for accuracy
    });
    totalHours = totalMinutes / 60;
   var month = extractMonths().length;
   var days = month*20;
   print(extractMonths());
   print(totalHours);
    double expectedHours = days * 7;
    print(expectedHours);
    setState(() {
      attendancePercentage = ((totalHours / expectedHours) * 100)/100;
      attendancePercent = ((totalHours / expectedHours) * 100).toInt();
    });
  }
  Set<String> extractMonths() {
    Set<String> months = Set<String>();
    for (AttendanceEntry entry in _attendanceData) {
      String monthYear = '${entry.date.month}/${entry.date.year}';
      months.add(monthYear);
    }
    return months;
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var usridEM = "Enter UserID";
    var passEM = "Enter Password";
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child: FadeInUp(
                        duration: const Duration(seconds: 1),
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background.png'),
                                  fit: BoxFit.fill)),
                        )),
                  ),
                  Positioned(
                    height: 400,
                    width: width + 20,
                    child: FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background-2.png'),
                                  fit: BoxFit.fill)),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                      duration: const Duration(milliseconds: 1500),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Color.fromRGBO(49, 39, 79, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1700),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                                color: const Color.fromRGBO(196, 135, 198, .3)),
                            boxShadow: [
                              const BoxShadow(
                                color: Color.fromRGBO(196, 135, 198, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color.fromRGBO(
                                              196, 135, 198, .3)))),
                              child: TextField(
                                controller: usrid,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "User ID  ",
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade700)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                obscureText: true,
                                controller: pass,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade700)),
                              ),
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1700),
                      child: Center(
                          child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Color.fromRGBO(196, 135, 198, 1)),
                              )))),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1900),
                      child: MaterialButton(
                        onPressed: () async {
                          await requestCameraPermission();
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (usrid.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(usridEM),
                            ));
                          } else if (pass.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(passEM),
                            ));
                          } else {
                            String userIp = await Api().userIpAddress();
                            await Api().fetchData(usrid.text);
                            bool login = Verify().verify(usrid.text, usr.text, pass.text, userIp);
                            await _fetchDataForUser();
                            await _calculateTotalHoursAndAttendance();
                            await APIforTSK().usrtsk(usrid.text);
                            if (login) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Login Successful"),
                                duration: Duration(seconds: 2),
                              ));
                              bool isexist = await Atten().checkUserIdExists();
                              if (isexist) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const MyHomePage(
                                              title: "BioLogin",
                                            )),
                                    (route) => false);
                              } else {
                                FaceDect().initFDF();
                                List<Person> personList =
                                    await FaceDect().enrollPerson();
                                if (personList != []) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FaceRecognitionView(
                                                personList: personList,
                                              )));
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("$message"),
                              ));
                            }
                          }
                        },
                        color: const Color.fromRGBO(49, 39, 79, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 50,
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 2000),
                      child: Center(
                          child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Create Account",
                                style: TextStyle(
                                    color: Color.fromRGBO(49, 39, 79, .6)),
                              )))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

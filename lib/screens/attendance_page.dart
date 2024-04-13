import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Api/Api.dart';
import '../models/attendace_model.dart';
import 'login.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<AttendanceEntry> _attendanceData = [];
  bool _isLoading = true;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchDataForUser();
  }

  void _fetchDataForUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _attendanceData = await ApiService.fetchAttendanceData(usrid.text);
    } catch (e) {
      print('Failed to load data: $e');
      _attendanceData = [];
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _fetchDataForUser();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details',
            style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.lato().fontFamily,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Theme(
                data: ThemeData.light().copyWith(
                  colorScheme:
                      ColorScheme.light(primary: Colors.deepPurpleAccent),
                ),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime(2021),
                  lastDate: DateTime.now(),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                    _fetchDataForUser();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _attendanceData.any((entry) =>
                        entry.date.year == _selectedDate.year &&
                        entry.date.month == _selectedDate.month &&
                        entry.date.day == _selectedDate.day)
                    ? ListView.builder(
                        itemCount: _attendanceData.length,
                        itemBuilder: (context, index) {
                          final attendanceEntry = _attendanceData[index];
                          // Check if the attendance entry's date matches the selected date
                          if (attendanceEntry.date.year == _selectedDate.year &&
                              attendanceEntry.date.month ==
                                  _selectedDate.month &&
                              attendanceEntry.date.day == _selectedDate.day) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: Container(
                                height: screenHeight * 0.20,
                                decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        // Text(
                                        //   'Selected Date:',
                                        //   style: TextStyle(
                                        //     color: Colors.white,
                                        //     fontSize: 20,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontFamily:
                                        //         GoogleFonts.lato().fontFamily,
                                        //   ),
                                        // ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                            'Date: ${attendanceEntry.date.day}/${attendanceEntry.date.month}/${attendanceEntry.date.year}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  GoogleFonts.lato().fontFamily,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Time In: ${attendanceEntry.timeIn.format(context)}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  GoogleFonts.lato().fontFamily,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Time Out: ${attendanceEntry.timeOut.format(context)}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  GoogleFonts.lato().fontFamily,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox
                                .shrink(); // Return an empty widget if the date does not match
                          }
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 190),
                        child: Container(
                          height: screenHeight * 0.20,
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            'Absent',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                          )),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

import 'package:bio_spot_check/main.dart';
import 'package:bio_spot_check/models/task_model.dart';
import 'package:bio_spot_check/screens/Announcements.dart';
import 'package:bio_spot_check/screens/Projects.dart';
import 'package:bio_spot_check/screens/attendance_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../Api/Api.dart';
import '../Api/notionApi.dart';
import '../auth/FDF.dart';
import '../auth/FDforout.dart';
import '../auth/person.dart';
import '../utils/CFC.dart';
import 'login.dart';

List<Task_model> tasks = [];
List<String> nameParts = UsrName.split(' ');
String firstName = nameParts.first;

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

DateTime now = DateTime.now();
String date_now = formatDate(now);

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Task_model>> _fetchTasksFuture;
  late Future<void> _getAttenFuture; // Add this line

  @override
  void initState() {
    super.initState();
    _fetchTasksFuture = fetchTasks();
    _getAttenFuture = Atten().get_atten(usrid.text, date_now);
  }

  Future<List<Task_model>> fetchTasks() async {
    try {
      List<Task_model> fetchedTasks = await fetchNotionTasks() ?? [];
      return fetchedTasks;
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  Widget buildShimmerEffect(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 17,
                ),
                Container(
                  width: screenWidth * .913,
                  height: screenHeight * 0.2685,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple, Colors.deepPurpleAccent],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back,\n $firstName !",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: GoogleFonts.lato().fontFamily),
                          ),
                          Text(
                            " $Email",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onLongPress: (){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>  Login()),
                                (route) => false);},
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3)),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundImage:
                              MemoryImage(Uint8List.fromList(profileBytes)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(height: screenHeight * .025),
              Container(
                height: screenHeight * 0.2957,
                child: FutureBuilder<List<Task_model>>(
                  future: _fetchTasksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return buildShimmerEffect(context);
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else {
                      tasks = snapshot.data!
                          .where((task) =>
                              task.statusName == 'In progress' &&
                              task.email.contains(Email))
                          .toList();

                      if (tasks.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No tasks found.',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _fetchTasksFuture =
                                        fetchTasks(); // Reload tasks
                                  });
                                },
                                child: Text('Refresh'),
                              ),
                            ],
                          ),
                        );
                      }

                      return GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _fetchTasksFuture = fetchTasks();
                          });
                        },
                        child: ListView.builder(
                          itemCount: tasks.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: screenWidth * .02),
                                    Row(
                                      children: [
                                        SizedBox(width: screenWidth * .02),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'Task: ${task.taskName}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 150,
                                      width: 360,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 8, 2, 0),
                                        child: SingleChildScrollView(
                                          child: Text(
                                            task.Description),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          190, 5, 0, 0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 10,
                                            width: 10,
                                            color: getCompletionColor(
                                                task.priority),
                                          ),
                                          SizedBox(width: screenWidth * .01),
                                          Text(
                                            '${task.priority}',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                          SizedBox(width: screenWidth * .025),
                                          Container(
                                            height: 25,
                                            width: 90,
                                            decoration: BoxDecoration(
                                              color: getStatusColor(
                                                  task.statusName),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: DropdownButton<String>(
                                                value: task.statusName,
                                                onChanged:
                                                    (String? newValue) async {
                                                  if (newValue != null) {
                                                    await updateStatus(
                                                        task.task_id, newValue);
                                                    setState(() {
                                                      _fetchTasksFuture =
                                                          fetchTasks(); // Reload tasks
                                                    });
                                                  }
                                                },
                                                items: <String>[
                                                  'Done',
                                                  'In progress',
                                                  'Not started',
                                                ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              GoogleFonts.lato()
                                                                  .fontFamily,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).toList(),
                                                underline: Container(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AttendancePage()));
                  },
                  child: Container(
                    height: screenHeight * .090,
                    width: screenWidth * .92,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        CircularPercentIndicator(
                          radius: 31.0,
                          animation: true,
                          animationDuration: 1200,
                          lineWidth: 6.0,
                          percent: .8,
                          center: Text(
                            '80',
                            style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                          circularStrokeCap: CircularStrokeCap.butt,
                          fillColor: Colors.white,
                          progressColor: Colors.green,
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text('IN TIME:',style: TextStyle(fontFamily: GoogleFonts.lato().fontFamily,
                                fontWeight: FontWeight.bold),),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder<void>(
                              // Use FutureBuilder to wait for the async operation
                              future: _getAttenFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // Once the data is available, display it
                                  return Text('$time_in');
                                }
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepPurpleAccent,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await requestCameraPermission();
                              await Api().fetchIP(usrid.text);
                              String uip = await Api().userIpAddress();
                              String dip = dbip;
                              if (uip == dip) {
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
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("IP invalid"),
                                ));
                              }
                            },
                            child: Text(
                              "Check-Out",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CFC(
                        name: 'Projects',
                        page: Projects(),
                        icon: Icons.account_tree_outlined,
                        iconcolor: Colors.cyan),
                    SizedBox(width: 20),
                    CFC(
                        name: 'Announcements',
                        page: Announcements(),
                        icon: Icons.wechat,
                        iconcolor: Colors.orangeAccent),
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

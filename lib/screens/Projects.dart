import 'package:bio_spot_check/Api/Api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../Api/notionApi.dart';
import '../models/project_model.dart';
import 'project_details.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  late Future<List<Project_model>> _fetchProjectsFuture;

  Future<List<Project_model>> fetchProjects() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return fetchNotionPages(); // Fetch actual data using the API
  }

  @override
  void initState() {
    super.initState();
    _fetchProjectsFuture = fetchProjects();
  }

  Widget buildShimmerEffect(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6, // Number of shimmer items to show
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: screenWidth * .95,
                    height: screenWidth * .35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Projects',
          style: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.lato().fontFamily,
              fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        )),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _fetchProjectsFuture = fetchProjects(); // Refresh the data
            });
          },
          child: FutureBuilder<List<Project_model>>(
            future: _fetchProjectsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return buildShimmerEffect(context);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                List<Project_model> projects = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    Project_model project = projects[index];
                    return Column(
                      children: [
                        if (project.assignees.contains(
                            Email)) // Filter projects by assignee email
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Project_Details(
                                    projectName: project.projectName,
                                    statusName: project.statusName,
                                    completionPercentage:
                                        project.completionPercentage,
                                    priority: project.priority,
                                    startDate: project.startDate,
                                    endDate: project.endDate,
                                    tasks: project.tasks,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: screenWidth * .35,
                              width: screenWidth * .95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF000000),
                                    offset: Offset.fromDirection(20, 2),
                                    blurRadius: 3,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          child: CircularPercentIndicator(
                                            radius: 30.0,
                                            animation: true,
                                            animationDuration: 1200,
                                            lineWidth: 8.0,
                                            percent:
                                                project.completionPercentage,
                                            circularStrokeCap:
                                                CircularStrokeCap.butt,
                                            fillColor: Colors.white,
                                            progressColor:
                                                Colors.deepPurpleAccent,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 25, 0, 0),
                                          child: Row(
                                            children: [
                                              Text(project.projectName,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily:
                                                          GoogleFonts.lato()
                                                              .fontFamily,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[600])),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                project.icon ?? '',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5), // Reduced spacing here
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              260, 0, 0, 0),
                                          child: Container(
                                            height: 10,
                                            width: 10,
                                            color: getCompletionColor(
                                                project.priority),
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Text(project.priority ?? 'Not Set'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 4),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// Color functions and Project_model class remain the same as in the original code

Color getCompletionColor(String? category) {
  switch (category) {
    case 'High':
      return Colors.red.shade400;
    case 'Low':
      return Colors.green.shade400;
    case 'Medium':
      return Colors.orange.shade400;
    case 'General':
      return Colors.blue.shade400;
    default:
      return Colors.black;
  }
}

Color getStatusColor(String? category) {
  switch (category) {
    case 'Dropped':
      return Colors.red.shade400;
    case 'Done':
      return Colors.green.shade400;
    case 'Requested':
      return Colors.orange.shade400;
    case 'In progress':
      return Colors.blue.shade400;
    default:
      return Colors.black;
  }
}

class Project_model {
  final String projectName;
  final String statusName;
  final double completionPercentage;
  final String? priority;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> tasks;
  final String? icon;
  final String assignees;

  Project_model(
      {required this.projectName,
      required this.statusName,
      required this.completionPercentage,
      this.priority,
      this.startDate,
      this.endDate,
        required this.assignees,
      required this.tasks,
      required this.icon});

  factory Project_model.fromJson(Map<String, dynamic> json) {
    // Extract the project name
    String extractProjectName() {
      return json['properties']['Project name']['title'][0]['plain_text'] ?? '';
    }

    // Extract the status name
    String extractStatusName() {
      return json['properties']['Status']['status']['name'] ?? '';
    }

    // Extract the completion percentage
    double extractCompletionPercentage() {
      var completionValue =
          json['properties']['Completion']['rollup']['number'];
      // Check if the value is an int and convert, or default to double conversion
      if (completionValue is int) {
        return completionValue.toDouble();
      } else if (completionValue is double) {
        return completionValue;
      }
      return 0.0; // Default value in case it's neither int nor double
    }

    // Extract priority
    String? extractPriority() {
      return json['properties']['Priority']['select']?['name'];
    }

    // Extract start and end dates
    DateTime? extractStartDate() {
      var startDateString = json['properties']['Dates']['date']?['start'];
      if (startDateString != null) {
        return DateTime.parse(startDateString);
      }
      return null;
    }

    DateTime? extractEndDate() {
      var endDateString = json['properties']['Dates']['date']?['end'];
      if (endDateString != null) {
        return DateTime.parse(endDateString);
      }
      return null;
    }
    String extractAssigneeEmail() {
      var assigneeList = json['properties']['Assignee']['people'];
      if (assigneeList != null && assigneeList.isNotEmpty) {
        List<dynamic> emails = assigneeList.map((assignee) {
          return assignee['person']['email'] ?? '';
        }).toList();
        return emails.join(', ');
      }
      return '';
    }
    String? extractIconEmoji() {
      return json['icon']?['emoji']; // Check if the icon field is present
    }

    // Extract tasks (assuming task IDs are sufficient for your use case)
    List<String> extractTasks() {
      var tasksList = json['properties']['Tasks']['relation'] as List<dynamic>?;
      if (tasksList != null) {
        return tasksList.map((task) => task['id'] as String).toList();
      }
      return [];
    }

    return Project_model(
      projectName: extractProjectName(),
      statusName: extractStatusName(),
      completionPercentage: extractCompletionPercentage(),
      priority: extractPriority(),
      startDate: extractStartDate(),
      endDate: extractEndDate(),
      tasks: extractTasks(),
      assignees: extractAssigneeEmail(),
      icon: extractIconEmoji(),
    );
  }
}

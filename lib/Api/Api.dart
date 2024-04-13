import 'dart:convert';

import 'package:bio_spot_check/screens/login.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../auth/facedetectionview.dart';
import '../models/attendace_model.dart';

var message;
var users;
List<int> profileBytes = [];
var UsrName;
var Email;
var dbip;
var atten;
var time_in;
var time_out;


class Api {
  Future<String> userIpAddress() async {
    try {
      final response =
          await http.get(Uri.parse('https://api64.ipify.org?format=json'));
      if (response.statusCode == 200) {
        final ipAddress = json.decode(response.body)["ip"];
        return ipAddress;
      } else {
        throw Exception('Failed to get IP address');
      }
    } catch (e) {
      throw Exception('Failed to get IP address');
    }
  }

  Future<List<Map<String, dynamic>>> fetchData(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.27/get_data.php?id=$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        users = data;
        for (var user in data) {
          UsrName = user['username'];
          Email = user['email'];
        }
        for (var user in data) {
          String base64EncodedProfile = user['profile'];
          profileBytes = base64.decode(base64EncodedProfile);
          user['profile'] = profileBytes;
        }

        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchIP(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.27/get_data.php?id=$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        users = data;
        for (var user in data) {
          dbip = user['ip'];
        }
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }
}

class Verify {
  bool verify(String userid, String username, String pass, String userIp) {
    for (var user in users) {
      if (user["userid"] == userid) {
        if (user["password"] == pass) {
          String userDbIp = user["ip"].trim();
          if (userDbIp == userIp) {
            return true; // User ID, password, and IP match
          } else {
            message = 'Invalid IP';
            return false; // IP doesn't match
          }
        } else {
          message = 'Password Incorrect';
          return false; // Password doesn't match
        }
      }
    }
    message = 'Invalid UserID';
    return false; // User ID not found
  }
}

class APIforTSK {
  Future<List<String>> usrtsk(String usrId) async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.27/get_task.php?id=$usrId'));
      if (response.statusCode == 200) {
        final List<dynamic> tasks = json.decode(response.body);
        if (tasks.isNotEmpty) {
          return tasks.cast<String>(); // Ensure the list is of type String
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Failed to get Task. Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      return []; // Returning an empty list on error
    }
  }
}

class Atten {
  Future<void> updateData() async {
    var url = Uri.parse('http://192.168.1.27/update_data.php');
    var response = await http.post(url,
        body: {'id': usrid.text, 'Date': formattedDate, 'TimeIn': timein});
    if (response.statusCode == 200) {
    } else {}
  }

  Future<void> get_atten(var userId, var date) async {
    var url =
        Uri.parse("http://192.168.1.27/get_atten.php?id=$userId&date=$date");
    var response = await http.post(url);
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data is List) {
          // Handle list data
          atten = data;
          for (var atten in data) {
            time_in = atten['time_in'];
            time_out = atten['time_out'];
          }
        } else if (data is Map && data.containsKey('message')) {
          // Handle message object
          print(data['message']);
        } else {
          // Handle unexpected format
          print("Unexpected JSON format");
        }
      } catch (e) {
        // Handle JSON parsing error
        print("Error parsing JSON: $e");
      }
    } else {
      // Handle HTTP error
      print("HTTP error: ${response.statusCode}");
    }
  }

  Future<void> updateTO(var userId, var date, var timeout) async {
    var url =
        Uri.parse("http://192.168.1.27/update_to.php?id=$userId&date=$date");
    var response = await http.post(url, body: {
      'time_out': timeout,
    });
    //print(date);
    if (response.statusCode == 200) {
    } else {}
  }

  Future<bool> checkUserIdExists() async {
    try {
      DateTime now = DateTime.now();
      var Date = '${now.year}-${now.month}-${now.day}';
      var url = Uri.parse('http://192.168.1.27/check_user.php');
      var response =
          await http.post(url, body: {'id': usrid.text, 'date': Date});
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          var data = json.decode(response.body);
          // Check if the 'exists' field is present in the response
          if (data.containsKey("exists")) {
            bool exists = data["exists"];
            // Return true if the user ID does not exist, false otherwise
            return exists;
          } else {
            // Handle invalid response format
            return false;
          }
        } else {
          // Handle empty response body
          return false;
        }
      } else {
        // Handle HTTP error
        return false;
      }
    } catch (e) {
      // Handle network or server error
      return false;
    }
  }
}
class ApiService {
  static Future<List<AttendanceEntry>> fetchAttendanceData(String userId) async {
    var url = Uri.parse('http://192.168.1.27/get_all_atten.php?id=$userId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse != null && jsonResponse is List) {
        return jsonResponse.map((data) => AttendanceEntry.fromJson(data)).toList();
      } else {
        throw Exception('Unexpected or null JSON format');
      }
    } else {
      throw Exception('Failed to load attendance data');
    }
  }
}


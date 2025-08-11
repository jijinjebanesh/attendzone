### # 📲 AttendZone – Smart Face-Recognized Attendance App

> A Flutter-based professional attendance system that uses *face recognition, **IP-based location validation, and **smart task/project dashboards* for real-time employee tracking and communication. Powered by facesdk_plugin, Node.js, and MongoDB.

---

### ## 🌟 Features

#### *🏠 Home Dashboard*

* Face detection & IP validation for punch-in
* Attendance percentage and time logs
* Today's tasks with status, priority & progress update
* Checkout with FaceAuth + IP check

![Home](assets/images/homepage_gif.gif)

#### *📁 Projects Overview*

* All projects assigned to the user with progress circles
* Click for detailed project info (start time, Git repo, etc.)
* List of all tasks by all assignees
![Projects](assets/images/projectspage_original.gif)

#### *📌 Task Management*

* View, update, and track task progress
* See task priority and current status
  📸 **Demo GIF: tasks.gif**

#### *📅 Attendance History*

* Calendar view of past attendance
* Daily status with punch-in/out time & summary
![Attendance](assets/images/attedancepage_original.gif)

#### *👤 Profile Page*

* View user info (name, ID, position, email, etc.)
* Profile picture (from Cloudinary)
![Profile](assets/images/profilepage_original.gif)

#### *💬 Professional Messaging*

* Project-specific chats and announcements
* Send images, files, polls, reactions, replies, and threads
![Message](assets/images/messagepage_original.gif)

#### *🧠 Face Recognition with Anti-Spoofing*

* Face detection with depth map and liveness check
* Spoof-proof via facesdk_plugin with C++ algorithms
  📸 **Demo GIF: faceauth.gif**

---

### ## 📁 Folder Structure
```
bash
├── main.dart
├── routes.dart
├── helper_functions.dart
├── facedetectionview.dart
├── person.dart
│
├── Api/
│   ├── Api.dart
│   ├── chatApi.dart
│   ├── notionApi.dart
│   └── taskApi.dart
│
├── auth/
│   ├── auth.dart
│   ├── facedetectionview.dart
│   ├── FDF.dart
│   ├── FDforout.dart
│   └── person.dart
│
├── constants/
│   ├── buttonOutlined.dart
│   ├── image_strings.dart
│   ├── page_indicator.dart
│   └── sizes.dart
│
├── models/
│   ├── attendance_model.dart
│   ├── emojiModel.dart
│   ├── project_model.dart
│   └── task_model.dart
│
├── screens/
│   ├── home.dart
│   ├── attendance_page.dart
│   ├── Projects.dart
│   ├── project_details.dart
│   ├── dashboard.dart
│   ├── Announcements.dart
│   ├── login.dart
│   ├── messages.dart
│   └── profile.dart
│
├── popups/
│   ├── fullscreen_loaders.dart
│   └── loaders.dart
│
├── theme/
│   ├── theme.dart
│   └── custom_theme/
│       └── elevated_button_theme.dart
│
└── utils/
    ├── appbar.dart
    ├── CFC.dart
    ├── device_utils.dart
    ├── sharedPrefs.dart
    ├── taskCard.dart
    ├── TC.dart
    └── TFD.dart
```

---

### ## 💡 Tech Stack

* 💙 *Flutter (Mobile App Frontend)*
* 🧠 *FaceSDK Plugin (Face Recognition & Anti-Spoofing)*
* ⚙️ *Node.js + Express.js (Backend)*
* ☁️ *MongoDB (Database)*
* 🌍 *Cloudinary (User profile image storage)*
* 🧠 *C++ Face Algorithms (Depth Map, Liveness Detection)*

---

### ## 🔐 Core Functionalities

* *Face Recognition with Liveness Detection*
* *IP-based Punch Validation*
* *Check-in/Check-out with FaceAuth*
* *Project & Task Dashboards with Live Update*
* *Attendance History & Analytics*
* *Real-time Messaging and Announcements*
* *Secure Cloudinary Media Storage*
* *JWT-based Authentication*

---

### ## ⚙️ Setup & Installation

bash
git clone https://github.com/YOUR_USERNAME/AttendZone.git
cd AttendZone
flutter pub get
flutter run







import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_doctor/Screen/GetAllPrescription/GetAllPrescription.dart';
import 'package:v_doctor/Screen/OnboardingScreen/OnboardingScreen.dart';
import 'package:v_doctor/Screen/Patient/PatientHomeScreen.dart';
import 'package:v_doctor/Screen/PaymentHistory/PaymentHistoryPatient.dart';
import 'package:v_doctor/Screen/Profile/PatientProfileScreen.dart';
import 'package:v_doctor/Screen/View/LabReport/LabReport.dart';
import 'package:v_doctor/Screen/View/UpcomingAppointmenr/ViewAppointment.dart';
import 'package:v_doctor/Screen/View/UpcomingAppointmenr/ViewPatientAppointment.dart';
import 'package:v_doctor/Screen/View/view_bookmark_doctor.dart';
import 'package:v_doctor/Screen/View/view_speciality.dart';
import 'package:v_doctor/utils/SessionManager.dart';

class PatientDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    "https://file.xunruicms.com/admin_html/assets/pages/media/profile/profile_user.jpg", // Add your profile image URL here
                  ),
                ),
                SizedBox(width: 10),
                FutureBuilder<String?>(
                  future: ProfileManager().getName(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      );
                    } else {
                      return Text(
                        'Patient Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Get.to(() => PatientHomeScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Get.to(() => PatientProfileScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.healing),
            title: Text('Speciality'),
            onTap: () {
              Get.to(() => ViewSpeciality());
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Appointment'),
            onTap: () {
              Get.to(() => ViewPatientAppointment());
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Lab Reports'),
            onTap: () {
              Get.to(() => LabReports());
            },
          ), ListTile(
            leading: Icon(Icons.medical_services_outlined),
            title: Text('Prescription'),
            onTap: () {
              Get.to(() => GetAllPrescription());
            },
          ),
          ListTile(
            leading: Icon(Icons.price_change),
            title: Text('Payment History'),
            onTap: () {
              Get.to(() => PaymentHistoryPatient());
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      radius: 20,
      titlePadding: EdgeInsets.all(20),
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            clearUserSession();
            Get.to(() => OnboardingScreen());
          },
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  void clearUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

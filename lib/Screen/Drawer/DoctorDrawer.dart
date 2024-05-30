import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_doctor/Screen/Appointments/view_doctor_appointments.dart';
import 'package:v_doctor/Screen/Doctor/DoctorHomeScreen.dart';
import 'package:v_doctor/Screen/OnboardingScreen/OnboardingScreen.dart';
import 'package:v_doctor/Screen/PaymentHistory/PaymentHistory.dart';
import 'package:v_doctor/Screen/Profile/DoctorProfile.dart';
import 'package:v_doctor/Screen/Profile/DoctorSetting.dart';

class DoctorDrawer extends StatelessWidget {
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
                Text(
                  'Dr Mehta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Get.to(DoctorHomeScreen());
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Get.to(DoctorSetting());
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Appointment'),
            onTap: () {
              Get.to(ViewDoctorAppointment());
            },
          ),

          ListTile(
            leading: Icon(Icons.price_change),
            title: Text('Payment History'),
            onTap: () {
              Get.to(PaymentHistory());
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
          Get.back(); // Close the dialog
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

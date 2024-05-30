import 'package:flutter/material.dart';
import 'package:v_doctor/Screen/Drawer/DoctorDrawer.dart';
import 'package:v_doctor/Screen/Profile/Setting/AvailabilityScreen.dart';
import 'package:v_doctor/Screen/Profile/Setting/ChangePassword.dart';
import 'package:v_doctor/Screen/Profile/Setting/ClinicInfoScreen.dart';
import 'package:v_doctor/Screen/Profile/Setting/EditProfileScreen.dart';
import 'package:v_doctor/Screen/Profile/Setting/FeesScreen.dart';
import 'package:v_doctor/Screen/Profile/Setting/QuestionScreen.dart';
import 'package:v_doctor/utils/colors.dart';

class DoctorSetting extends StatefulWidget {
  const DoctorSetting({Key? key}) : super(key: key);

  @override
  State<DoctorSetting> createState() => _DoctorSettingState();
}

class _DoctorSettingState extends State<DoctorSetting> {
  late double height;
  late double width;

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  int currentPageIndex = 0;

  final List<Widget> screens = [
    EditProfileScreen(),
    ClinicInfoScreen(),
    FeesScreen(),
    AvailabilityScreen(),
    QuestionScreen(),
    ChangePassword(),
  ];

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    return Scaffold(
      key: _globalKey,
      backgroundColor: ColorConstants.primaryColor,
      drawer: DoctorDrawer(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: ColorConstants.primaryColor,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person),
            label: 'Edit Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_hospital_sharp),
            label: 'Clinic Info',
          ),
          NavigationDestination(
            icon: Icon(Icons.currency_exchange_rounded),
            label: 'Fees',
          ),
          NavigationDestination(
            icon: Icon(Icons.query_builder_outlined),
            label: 'Availability',
          ),
          NavigationDestination(
            icon: Icon(Icons.question_mark_outlined),
            label: 'Question',
          ),
          NavigationDestination(
            icon: Icon(Icons.lock),
            label: 'Change Password',
          ),
        ],
      ),

      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: height * 0.08,
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu, color: ColorConstants.white),
                onPressed: () {
                  _globalKey.currentState?.openDrawer();
                },
              ),
              SizedBox(width: 20),
              Text(
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: screens[currentPageIndex],
        ),
      ]),
    );
  }
}

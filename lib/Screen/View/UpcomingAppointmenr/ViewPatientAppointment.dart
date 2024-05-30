import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_doctor/Screen/Drawer/PatientDrawer.dart';
import 'package:v_doctor/Screen/View/UpcomingAppointmenr/PatientPastTabWidget.dart';
import 'package:v_doctor/Screen/View/UpcomingAppointmenr/PatientUpcomingTabWidget.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class ViewPatientAppointment extends StatefulWidget {
  const ViewPatientAppointment({Key? key}) : super(key: key);

  @override
  State<ViewPatientAppointment> createState() => _ViewPatientAppointmentState();
}

class _ViewPatientAppointmentState extends State<ViewPatientAppointment> {
  late double height;
  late double width;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;


    return DefaultTabController(
      length: 2, // Define the number of tabs
      child: Scaffold(
        key: _globalKey,
        backgroundColor: ColorConstants.primaryColor,
        drawer: PatientDrawer(),
        body: Container(
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: height * 0.17,
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Builder(
                            builder: (BuildContext context) {
                              return IconButton(
                                icon: Icon(Icons.menu,
                                    color: ColorConstants.white),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              );
                            },
                          ),
                          SizedBox(width: width * 0.05),
                          Text(
                            appointmenttxt,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TabBar(
                        indicatorColor: ColorConstants.tabbarColor,
                        labelColor: ColorConstants.tabbarColor,
                        labelStyle: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(text: UpcomingTab),
                          Tab(text: PastTab),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.85,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorConstants.homebackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(width * 0.1),
                        topRight: Radius.circular(width * 0.1),
                      ),
                    ),
                    child: TabBarView(
                      children: [
                        PatientUpcomingTabWidget(),
                        PatientPastTabWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

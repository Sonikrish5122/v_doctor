import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_doctor/API/DoctorAPI/TodayAppointmentAPI.dart';
import 'package:v_doctor/Model/DoctorModel/TodayAppointmentModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/Appointments/view_appointments_details.dart';
import 'package:v_doctor/Screen/Appointments/view_doctor_appointments.dart';
import 'package:v_doctor/Screen/Drawer/DoctorDrawer.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';
import 'package:v_doctor/utils/SessionManager.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? userEmail;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    getTodayAppointmentInfo(); // Fetch today's appointment data
  }

  void _loadUserData() async {
    final sessionManager = SessionManager();
    final userData = await sessionManager.getUserInfo();

    setState(() {
      userEmail = userData?.userId;
      userId = userData?.userType;
    });
  }

  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = false;
  String? errorMessage;
  TodayAppointmentModel? todayAppointmentModel;

  void getTodayAppointmentInfo() async {
    sessionManager = SessionManager();
    await sessionManager!.getUserInfo().then((value) {
      if (value != null) {
        setState(() {
          userData = value;
        });

        fetchTodayAppointmentData();
      }
    });
  }

  void fetchTodayAppointmentData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (userData == null) {
        setState(() {
          errorMessage = 'User data is null.';
          isLoading = false;
        });
        return;
      }

      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      // Fetch today's appointment data using the API
      var response = await GetTodayAppointmentModelAPIService().getTodayAppointmentInfo(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      setState(() {
        todayAppointmentModel = response; // Assign the response to the model
      });

      print(response);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please try again later.';
      });
      print('Exception: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorConstants.primaryColor,
      drawer: DoctorDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height * 0.12,
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: ColorConstants.white),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    Text(
                      "Hi, Dr Mehta",
                      style: TextStyle(
                        color: ColorConstants.white,
                        fontSize: width * 0.04,
                      ),
                    ),
                    Spacer(),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg"),
                      radius: width * 0.06,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.01),
                  child: Text(
                    todaysTxt,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                      color: ColorConstants.white,
                    ),
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width * 0.1),
                  topRight: Radius.circular(width * 0.1),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nextappointMent,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(ViewDoctorAppointment());
                          },
                          child: Text(
                            viewAllText,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: width * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Display today's appointments here
                    if (todayAppointmentModel != null)
                      Expanded(
                        child: ListView.builder(
                          itemCount: todayAppointmentModel!.data.length,
                          itemBuilder: (context, index) {
                            var appointment = todayAppointmentModel!.data[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewAppointmentDetailsScreen(
                                      name: appointment.patientProfile.name,
                                      gender: appointment.patientProfile.gender,
                                      time: appointment.time,
                                      doctorId: appointment.doctorId,
                                      patientId: appointment.patientId,
                                      appointmentId: appointment.appointmentId, // Corrected field name
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Date:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(appointment.appointmentDate),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Time:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            appointment.time,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Name:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            appointment.patientProfile.name,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Gender:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            appointment.patientProfile.gender,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Appointment Mode:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            appointment.appointmentMode,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Appointment Type:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            appointment.appointmentType,
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    SizedBox(height: height * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

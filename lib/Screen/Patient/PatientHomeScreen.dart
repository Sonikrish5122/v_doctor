import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/PatientAPI/SpecialityAPIService.dart';
import 'package:v_doctor/API/PatientAPI/TodayAppointmentPatientAPI.dart';
import 'package:v_doctor/Common%20Widget/CircleIconWithText.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Model/SpecialityModel.dart';
import 'package:v_doctor/Model/TodayAppontmentPatient.dart';
import 'package:v_doctor/Screen/Drawer/PatientDrawer.dart';
import 'package:v_doctor/Screen/Profile/PatientProfileScreen.dart';
import 'package:v_doctor/Screen/View/DoctorSpecialityScreen.dart';
import 'package:v_doctor/Screen/View/UpcomingAppointmenr/PatientViewAppointmentDetails.dart';
import 'package:v_doctor/Screen/View/UpcomingAppointmenr/ViewPatientAppointment.dart';

import 'package:v_doctor/Screen/View/view_speciality.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? userId;
  String? userType;
  List<SpecialityData> specialities = [];
  List<SpecialityData> filteredSpecialities = [];
  TextEditingController searchController = TextEditingController();
  late ProfileManager profileManager;
  bool isLoading = false;
  SessionManager? sessionManager;
  UserData? userData;

  String? errorMessage;
  @override
  void initState() {
    super.initState();
    ProfileManager();
    _loadUserData();
    _fetchSpecialities();
    getTodayAppointmentPatientInfo();
  }

  void _loadUserData() async {
    SessionManager sessionManager = SessionManager();
    UserData? userData = await sessionManager.getUserInfo();
    setState(() {
      userId = userData?.userId;
      userType = userData?.userType;
    });
  }

  void _fetchSpecialities() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<SpecialityData> fetchedSpecialities =
          await SpecialityAPIService().fetchSpecialities();

      setState(() {
        specialities = fetchedSpecialities;
        filteredSpecialities = specialities;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterSpecialities(String query) {
    List<SpecialityData> filteredList = specialities.where((speciality) {
      return speciality.specialityName!
          .toLowerCase()
          .startsWith(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSpecialities = filteredList;
    });
  }

  TodayAppointmentPatientModel? todayAppointmentPatientModel;

  void getTodayAppointmentPatientInfo() async {
    sessionManager = SessionManager();
    await sessionManager!.getUserInfo().then((value) {
      if (value != null) {
        setState(() {
          userData = value;
        });

        fetchTodayAppointmentPatientData();
      }
    });
  }

  void fetchTodayAppointmentPatientData() async {
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

      var response = await GetTodayAppointmentPatientAPIService()
          .getTodayAppointmentPatientInfo(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      setState(() {
        todayAppointmentPatientModel = response;
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
    String _formatTime(String? time) {
      if (time == null) return '';
      final formattedTime = DateFormat.jm().format(DateTime.parse(time));
      return formattedTime;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorConstants.primaryColor,
      drawer: PatientDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: height * 0.45,
              padding: EdgeInsets.all(width * 0.01),
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
                      FutureBuilder<String?>(
                        future: ProfileManager().getName(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              'Hi, ${snapshot.data}',
                              style: TextStyle(
                                  color: ColorConstants.white,
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Text(
                              'Hi, Jess', // Default name
                              style: TextStyle(
                                color: ColorConstants.white,
                                fontSize: width * 0.04,
                              ),
                            );
                          }
                        },
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(PatientProfileScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 6),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg"),
                            radius: width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.12),
                    child: Text(
                      patientText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.06,
                        color: ColorConstants.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(width * 0.04),
                    height: height * 0.06,
                    child: TextField(
                      onChanged: (value) {
                        _filterSpecialities(value);
                      },
                      decoration: InputDecoration(
                        hintText: searchText,
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.02),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.02),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          specialityText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(ViewSpeciality());
                          },
                          child: Text(
                            viewAllText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                      height: height * 0.14,
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : filteredSpecialities.isEmpty
                              ? Center(
                                  child: Text(
                                    'No specialties found.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: filteredSpecialities.length,
                                  itemBuilder: (context, index) {
                                    final speciality =
                                        filteredSpecialities[index];
                                    return Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(() => DoctorSpecialityScreen(
                                                specialityName:
                                                    speciality.specialityName ??
                                                        '',
                                                specialityId:
                                                    speciality.sId ?? '',
                                              ));
                                        },
                                        child: CircleIconWithText(
                                          icon: Icons.healing,
                                          iconColor:
                                              ColorConstants.primaryColor,
                                          iconSize: width * 0.10,
                                          text: speciality.specialityName ?? '',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.55,
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
                          'Next Appointment',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => ViewPatientAppointment());
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: width * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),
                    if (todayAppointmentPatientModel != null &&
                        todayAppointmentPatientModel!.data != null &&
                        todayAppointmentPatientModel!.data!.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: todayAppointmentPatientModel!.data!.length,
                        itemBuilder: (context, index) {
                          final appointment =
                              todayAppointmentPatientModel!.data![index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(PatientViewAppointmentDetails(
                                appointmentId:
                                    '${appointment.appointmentId ?? ''}',
                              ));
                            },
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Appointment Time: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Name: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${appointment.doctorDetails?.name ?? ''}',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Doctor Experience: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${appointment.doctorDetails?.experience ?? ''} years',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Mobile No.: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${appointment.doctorDetails?.mobileNo ?? ''} ',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Email: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${appointment.doctorDetails?.email ?? ''}',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Type: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${appointment.appointmentType ?? ''}',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Appointment Mode: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${appointment.appointmentMode ?? ''}',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Appointment Status:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Text(
                                          ' ${appointment.isCompleted ?? false ? 'Completed' : 'Pending'}',
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
                    if (todayAppointmentPatientModel == null ||
                        todayAppointmentPatientModel!.data == null ||
                        todayAppointmentPatientModel!.data!.isEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              appointmentimg,
                              height: height * 0.2,
                              width: width * 0.5,
                            ),
                          ),
                          Text(
                            'No appointments found.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

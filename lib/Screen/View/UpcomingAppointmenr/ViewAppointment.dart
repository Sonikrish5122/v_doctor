import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/PatientAPI/PastAppointment.dart';
import 'package:v_doctor/API/PatientAPI/UpComingAPIService.dart';
import 'package:v_doctor/Model/BookingModel/PastAppoinmentModel.dart';
import 'package:v_doctor/Model/BookingModel/UpComingModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/View/UpcomingAppointmenr/ViewAppointmentDetails.dart';
import 'package:v_doctor/Screen/Drawer/PatientDrawer.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class ViewAppointment extends StatefulWidget {
  const ViewAppointment({Key? key}) : super(key: key);

  @override
  State<ViewAppointment> createState() => _ViewAppointmentState();
}

class _ViewAppointmentState extends State<ViewAppointment> {
  late double height;
  late double width;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = false;
  String? errorMessage;
  PastAppointment? pastAppointment;
  UpcomingAppointment? upcomingAppointment;

  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    getPastInfo();
  }

  void fetchPastData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      pastAppointment = await PastAPIService().getPastAppointment(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please try again later.';
        isLoading = false;
        print(errorMessage);
      });
      print(e);
    }
  }

  void getPastInfo() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        getUpcomingInfo();
        fetchPastData();
      }
    });
  }

  void getUpcomingInfo() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        fetchUpcomingData();
      }
    });
  }

  void fetchUpcomingData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      upcomingAppointment =
          await UpComingAppointmentAPIService().getUpcomingAppointment(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please try again later.';
        isLoading = false;
        print(errorMessage);
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    DateTime? parseDate(String date) {
      try {
        final parts = date.split('-');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      } catch (e) {
        print('Error parsing date: $e');
      }
      return null;
    }

    final pastDate = pastAppointment!.appointmentData.isNotEmpty
        ? pastAppointment!.appointmentData.first.appointments.isNotEmpty
            ? pastAppointment!
                .appointmentData.first.appointments.first.appointmentDate
            : null
        : null;

    final pastDateformat = pastDate != null ? parseDate(pastDate) : null;

    final pastDateString1 = pastDateformat != null
        ? DateFormat('dd - MM - yyyy').format(pastDateformat)
        : 'Invalid Date';
    final formattedPastDateString = pastDateformat != null
        ? DateFormat('dd MMM').format(pastDateformat)
        : 'Invalid Date';

    final pastStartTime = pastAppointment!.appointmentData.isNotEmpty
        ? pastAppointment!.appointmentData.first.appointments.isNotEmpty
            ? pastAppointment!
                .appointmentData.first.appointments.first.startTime
            : null
        : null;

    String formattedStartTime = pastStartTime != null
        ? DateFormat('h : mm aa').format(DateTime.parse(pastStartTime))
        : 'Invalid Time';

    String _formatTime(String timeString) {
      try {
        final dateTime = DateTime.parse(timeString)
            .toLocal(); // Parse and convert to local time
        final formattedTime =
            DateFormat.jm().format(dateTime); // Format to 12-hour format
        return formattedTime;
      } catch (e) {
        print('Error formatting time: $e');
        return 'Invalid Time';
      }
    }

    String formatDate(String dateString) {
      DateFormat inputFormat = DateFormat('dd-MM-yyyy');
      DateFormat outputFormat = DateFormat('dd-MMM');
      DateTime date = inputFormat.parse(dateString);
      return outputFormat.format(date);
    }

    return DefaultTabController(
      length: 2,
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
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  child: Column(
                                    children:
                                        upcomingAppointment?.appointmentData
                                                ?.map((appointmentData) {
                                              return SizedBox(
                                                height: height * 0.80,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: upcomingAppointment
                                                          ?.appointmentData
                                                          ?.length ??
                                                      0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final appointmentData =
                                                        upcomingAppointment!
                                                                .appointmentData[
                                                            index];
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: appointmentData
                                                          .appointments
                                                          .map((appointment) {
                                                        return Card(
                                                          elevation: 20,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 10.0,
                                                                  left: 10,
                                                                  right: 10,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius:
                                                                          40,
                                                                      backgroundImage: NetworkImage(appointment
                                                                          .doctorDetails
                                                                          .profilePic),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            20),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          appointment
                                                                              .doctorDetails
                                                                              .name,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Start Time: ",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              color: Colors.black,
                                                                            ),
                                                                            children: <TextSpan>[
                                                                              TextSpan(
                                                                                text: _formatTime(appointment.startTime) ?? 'Start Time Not Defined',
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Payment Mode: ",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              color: Colors.black,
                                                                            ),
                                                                            children: <TextSpan>[
                                                                              TextSpan(
                                                                                text: " ${appointment.paymentMode}",
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Payment Status: ",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              color: Colors.black,
                                                                            ),
                                                                            children: <TextSpan>[
                                                                              TextSpan(
                                                                                text: " ${appointment.paymentStatus}",
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Appointment Mode: ",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              color: Colors.black,
                                                                            ),
                                                                            children: <TextSpan>[
                                                                              TextSpan(
                                                                                text: " ${appointment.appointmentMode}",
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            16.0),
                                                                child: Text(
                                                                  formatDate(
                                                                      appointment
                                                                          .appointmentDate),
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ),
                                                              Divider(
                                                                height: 20,
                                                                thickness: 1,
                                                                indent: 0,
                                                                endIndent: 0,
                                                                color: ColorConstants
                                                                    .iconBackground,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10.0),
                                                                child:
                                                                    Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Card(
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            Get.to(
                                                                              () => ViewAppointmentDetails(),
                                                                              arguments: {
                                                                                'name': appointmentData.appointments.first.doctorDetails.name,
                                                                                'mobileNo': appointmentData.appointments.first.doctorDetails.mobileNo,
                                                                                'profile_pic': appointmentData.appointments.first.doctorDetails.profilePic,
                                                                                'date': appointment.appointmentDate,
                                                                                'StartTime': appointment.startTime,
                                                                                'unique_id': appointment.uniqueId,
                                                                                'isCompleted': appointment.isCompleted,
                                                                              },
                                                                            );
                                                                          },
                                                                          icon:
                                                                              Icon(Icons.remove_red_eye_outlined),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                    );
                                                  },
                                                ),
                                              );
                                            })?.toList() ??
                                            [],
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: pastAppointment?.appointmentData
                                    .map((appointmentData) {
                                  return SizedBox(
                                    height: height * 0.80,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: appointmentData
                                              ?.appointments.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final appointment = appointmentData
                                            ?.appointments[index];
                                        if (appointment == null) {
                                          return SizedBox
                                              .shrink(); // Return an empty widget if appointment is null
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Card(
                                              elevation: 20,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 20),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 40,
                                                          backgroundImage:
                                                              NetworkImage(appointment
                                                                  .doctorDetails
                                                                  .profilePic),
                                                        ),
                                                        SizedBox(width: 20),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              appointment
                                                                  .doctorDetails
                                                                  .name,
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: start,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: _formatTime(
                                                                        appointment
                                                                            .startTime),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // Add null check for appointment properties
                                                            appointment.paymentMode !=
                                                                    null
                                                                ? RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          "Payment Mode: ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text:
                                                                              " ${appointment.paymentMode}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : SizedBox
                                                                    .shrink(),
                                                            appointment.paymentStatus !=
                                                                    null
                                                                ? RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          "Payment Status: ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text:
                                                                              " ${appointment.paymentStatus}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : SizedBox
                                                                    .shrink(),
                                                            appointment.appointmentMode !=
                                                                    null
                                                                ? RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          "Appointment Mode: ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text:
                                                                              " ${appointment.appointmentMode}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : SizedBox
                                                                    .shrink(),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    child: Text(
                                                      formatDate(appointment
                                                          .appointmentDate),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 20,
                                                    thickness: 1,
                                                    indent: 0,
                                                    endIndent: 0,
                                                    color: ColorConstants
                                                        .iconBackground,
                                                  ),
                                                  Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              bottom: 4),
                                                      child: Card(
                                                        color: ColorConstants
                                                            .primaryColor,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            Get.to(
                                                                () =>
                                                                    ViewAppointmentDetails(),
                                                                arguments: {
                                                                  'name': appointment
                                                                      .doctorDetails
                                                                      .name,
                                                                  'mobileNo': appointment
                                                                      .doctorDetails
                                                                      .mobileNo,
                                                                  'profile_pic':
                                                                      appointment
                                                                          .doctorDetails
                                                                          .profilePic,
                                                                  'date': appointment
                                                                      .appointmentDate,
                                                                  'StartTime':
                                                                      appointment
                                                                          .startTime,
                                                                  'unique_id':
                                                                      appointment
                                                                          .uniqueId,
                                                                  'isCompleted':
                                                                      appointment
                                                                          .isCompleted,
                                                                });
                                                          },
                                                          icon: Icon(
                                                            Icons
                                                                .remove_red_eye_outlined,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                }).toList() ??
                                [
                                  SizedBox(
                                    height: height * 0.80,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ],
                          ),
                        )
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

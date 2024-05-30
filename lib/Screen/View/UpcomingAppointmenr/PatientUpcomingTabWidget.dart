import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/PatientAPI/UpComingAPIService.dart';
import 'package:v_doctor/Model/BookingModel/UpComingModel.dart';
import 'package:v_doctor/Model/DoctorModel/UpcomingAppointmentModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/Appointments/view_appointments_details.dart';
import 'package:v_doctor/Screen/View/UpcomingAppointmenr/PatientViewAppointmentDetails.dart';
import 'package:v_doctor/utils/SessionManager.dart';

class PatientUpcomingTabWidget extends StatefulWidget {
  @override
  _PatientUpcomingTabWidgetState createState() =>
      _PatientUpcomingTabWidgetState();
}

class _PatientUpcomingTabWidgetState extends State<PatientUpcomingTabWidget> {
  TextEditingController _dateController = TextEditingController();
  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = false;
  String? errorMessage;

  UpcomingAppointment? upcomingAppointment;
  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    getUpcomingInfo();
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
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 20),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (errorMessage != null)
            Center(
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            )
          else if (upcomingAppointment != null &&
                upcomingAppointment!.appointmentData.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Appointments:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: upcomingAppointment!.appointmentData.length,
                    itemBuilder: (context, index) {
                      final appointmentData =
                      upcomingAppointment!.appointmentData[index];
                        final appointment = appointmentData.appointments[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(PatientViewAppointmentDetails(
                            appointmentId: '${appointment.appointmentId ?? ''}',
                          ));
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      appointment.appointmentDate,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Time:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      appointment.time,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Name:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      appointment.doctorDetails.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),


                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Appointment Mode:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      appointment.appointmentMode,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Appointment Type:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      appointment.appointmentType,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payment Status:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(appointment.paymentStatus,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            else
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Appointment.png',
                      width: 200,
                    ),
                    Text(
                      'No upcoming appointments found.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}

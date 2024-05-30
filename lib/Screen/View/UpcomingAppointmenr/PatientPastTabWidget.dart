import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/PatientAPI/PastAppointment.dart';
import 'package:v_doctor/Model/BookingModel/PastAppoinmentModel.dart'; // Import only the necessary model
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/Appointments/view_appointments_details.dart';
import 'package:v_doctor/Screen/View/UpcomingAppointmenr/PatientViewAppointmentDetails.dart';
import 'package:v_doctor/utils/SessionManager.dart';

class PatientPastTabWidget extends StatefulWidget {
  @override
  _PatientPastTabWidgetState createState() => _PatientPastTabWidgetState();
}

class _PatientPastTabWidgetState extends State<PatientPastTabWidget> {
  TextEditingController _dateController = TextEditingController();

  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = false;
  String? errorMessage;
  List<AppointmentDetails> appointments = []; // Define appointments list

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

      PastAppointment pastAppointment = await PastAPIService().getPastAppointment(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      setState(() {
        appointments = pastAppointment.appointmentData.expand((data) => data.appointments).toList();
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
        fetchPastData();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 10),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (errorMessage != null)
            Center(
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            )
          else if (appointments.isNotEmpty) // Check if appointments list is not empty
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: appointments.length,

                  itemBuilder: (context, index) {
                    AppointmentDetails appointment = appointments[index];
                    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(appointment.appointmentDate);


                    String formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Time:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(appointment.time),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("$formattedDate"),
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
                                  Text(appointment.doctorDetails.name),
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
                                  Text(appointment.appointmentMode),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment Mode:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(appointment.paymentMode),
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
                                  Text(appointment.paymentStatus),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Center(
                child: Column(
                  children: [
                    Text(
                      'No past appointments found.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/images/Appointment.png', // Replace this with your image path
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
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

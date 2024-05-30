import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/DoctorAPI/UpcomingAppontmentAPI.dart';
import 'package:v_doctor/Model/DoctorModel/UpcomingAppointmentModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/Appointments/view_appointments_details.dart';
import 'package:v_doctor/utils/SessionManager.dart';

class UpcomingTabWidget extends StatefulWidget {
  @override
  _UpcomingTabWidgetState createState() => _UpcomingTabWidgetState();
}

class _UpcomingTabWidgetState extends State<UpcomingTabWidget> {
  TextEditingController _dateController = TextEditingController();
  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = false;
  String? errorMessage;
  List<AppointmentDetails> appointments = [];

  @override
  void initState() {
    super.initState();
    getUpcomingInfo();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      selectableDayPredicate: (DateTime date) {
        return date
            .isAfter(now.subtract(Duration(days: 1))); // Disable past dates
      },
    );
    if (picked != null) {
      final formattedDate =
      DateFormat('yyyy-MM-dd').format(picked); // Format the date
      setState(() {
        _dateController.text = formattedDate;
      });
      fetchUpcomingData();
    }
  }

  void getUpcomingInfo() async {
    sessionManager = SessionManager();
    await sessionManager!.getUserInfo().then((value) {
      if (value != null) {
        setState(() {
          userData = value;
        });
      }
    });
  }

  void fetchUpcomingData() async {
    setState(() {
      isLoading = true;
      errorMessage = null; // Clear previous error message
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

      String selectedDate = _dateController.text;

      String currentTime = DateFormat("HH:mm:ss.SSS'Z'").format(DateTime.now());

      // Fetch upcoming appointment data
      var response =
      await UpComingAppointmentAPIService().getViewUpcomingAppointment(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
        date: selectedDate,
        time: currentTime,
      );

      if (response.containsKey('success') && response['success']) {
        UpcomingAppointmentModel upcomingAppointmentModel =
        UpcomingAppointmentModel.fromJson(response);
        setState(() {
          appointments = upcomingAppointmentModel.data[0].appointments;
        });
      } else {
        // Handle error cases
        setState(() {
          errorMessage = response['message'] ?? 'Failed to load data';
        });
      }
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
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date:',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextFormField(
            readOnly: true,
            controller: _dateController,
            onTap: () => _selectDate(context),
            decoration: InputDecoration(
              hintText: 'Tap to select date',
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
          ),
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
          else if (appointments.isNotEmpty)
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
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      AppointmentDetails appointment = appointments[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewAppointmentDetailsScreen(
                                name: appointment.patientProfile.name,
                                gender: appointment.patientProfile.gender,
                                time: appointment.time,
                                doctorId : appointment.doctorId,
                                patientId : appointment.patientId,
                                appointmentId : appointment.appointmentId,
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
                ],
              )
            else
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/Appointment.png',width: 200,),
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

import 'package:flutter/material.dart';
import 'package:v_doctor/API/DoctorAPI/AppointmentDetialsDoctorAPI.dart';
import 'package:v_doctor/API/DoctorAPI/UpdateStatusAPI.dart';
import 'package:v_doctor/Common%20Widget/AppointmentDetailItem.dart';
import 'package:v_doctor/Model/DoctorModel/UpdateStatusModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/Appointments/PrescriptionScreen.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

import '../../Model/DoctorModel/AppointmentDetailsDoctorModel.dart';

class ViewAppointmentDetailsScreen extends StatefulWidget {
  final String name;
  final String gender;
  final String time;
  final String doctorId;
  final String patientId;
  final String appointmentId;

  ViewAppointmentDetailsScreen({
    required this.name,
    required this.gender,
    required this.time,
    required this.doctorId,
    required this.patientId,
    required this.appointmentId,
  });

  @override
  State<ViewAppointmentDetailsScreen> createState() =>
      _ViewAppointmentDetailsScreenState();
}

class _ViewAppointmentDetailsScreenState
    extends State<ViewAppointmentDetailsScreen> {
  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = false;
  String? errorMessage;
  AppointmentData? appointmentData;

  @override
  void initState() {
    super.initState();
    getAppointmentInfo();
  }

  void getAppointmentInfo() async {
    sessionManager = SessionManager();
    await sessionManager!.getUserInfo().then((value) {
      if (value != null) {
        setState(() {
          userData = value;
        });

        fetchAppointmentData();
      }
    });
  }

  Future<void> fetchAppointmentData() async {
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
      String appointmentId = widget.appointmentId;

      var response = await AppointmentDetailsDoctorAPI().getAppointmentDetails(
        accessToken: accessToken,
        userId: userId,
        appointment_id: appointmentId,
      );

      setState(() {
        appointmentData = response.data.isNotEmpty ? response.data[0] : null;
      });
// Print appointment ID
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
      backgroundColor: ColorConstants.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: height * 0.08,
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  IconButton(
                    icon:
                        Icon(Icons.arrow_back_ios, color: ColorConstants.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Appointment #:${appointmentData?.uniqueId ?? ''}",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.04),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : appointmentData != null
                          ? Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PrescriptionScreen(
                                          patientName: appointmentData
                                                  ?.patientProfile[0].name ??
                                              '',
                                          appointmentId:
                                              appointmentData?.appointmentId ??
                                                  '',
                                          patientId:
                                              appointmentData?.patientId ?? '',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(18.0),
                                    )),
                                  ),
                                  child: Text(
                                    'Add prescription',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              appointment_icon,
                                              width: 30,
                                              height: 28,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Appointment Details",
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                AppointmentDetailItem(
                                                  label: 'Patient Name:',
                                                  value: appointmentData!
                                                      .patientProfile[0].name,
                                                ),
                                                Spacer(),
                                                Spacer(),
                                                Spacer(),
                                                AppointmentDetailItem(
                                                  label: 'Date of Birth:',
                                                  value: appointmentData!
                                                      .patientProfile[0].dob,
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                AppointmentDetailItem(
                                                  label: 'Mobile No',
                                                  value: appointmentData!
                                                      .patientProfile[0]
                                                      .mobileNo,
                                                ),
                                                Spacer(),
                                                Spacer(),
                                                AppointmentDetailItem(
                                                  label: 'Date',
                                                  value: appointmentData!
                                                      .appointmentDate,
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                AppointmentDetailItem(
                                                  label: 'Email:',
                                                  value: appointmentData!
                                                      .patientProfile[0].email,
                                                ),
                                                Spacer(),
                                                AppointmentDetailItem(
                                                  label: 'Gender:',
                                                  value: appointmentData!
                                                      .patientProfile[0].gender,
                                                ),
                                                Spacer(),
                                                Spacer(),
                                                Spacer(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                AppointmentDetailItem(
                                                  label: 'Appointment Mode:',
                                                  value: appointmentData!
                                                      .appointmentMode,
                                                ),
                                                Spacer(),
                                                SizedBox(
                                                  width: 52,
                                                ),
                                                AppointmentDetailItem(
                                                  label: 'Appointment Type:',
                                                  value: appointmentData!
                                                      .appointmentType,
                                                ),
                                                Spacer(),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              appointment_icon,
                                              width: 30,
                                              height: 28,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Diagnosis Details",
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Column(
                                          children: [
                                            AppointmentDetailItem(
                                              label: 'Symptoms:',
                                              value: appointmentData!.comment,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              appointment_icon,
                                              width: 30,
                                              height: 28,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Reports",
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (var report
                                                in appointmentData!.testReports)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Report Name: ${report['report_name']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Report Date: ${report['reportDate']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: ColorConstants
                                                          .LightGray,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Patient Name: ${report['patientName']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: ColorConstants
                                                          .LightGray,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              appointment_icon,
                                              width: 30,
                                              height: 28,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Question",
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: appointmentData!
                                              .preDiagnosisQuestions
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            final index = entry.key + 1;
                                            final question = entry.value;
                                            return AppointmentDetailItem(
                                              label:
                                                  'Q $index: ${question.question}',
                                              value: "Ans ${question.answer}",
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              appointment_icon,
                                              width: 30,
                                              height: 28,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Prescription",
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        if (appointmentData != null &&
                                            appointmentData!.prescription !=
                                                null) // Check if prescription list is not null
                                          Column(
                                            children: appointmentData!
                                                .prescription!
                                                .map((prescription) {
                                              if (prescription
                                                  is Map<String, dynamic>) {
                                                // Check if the prescription is a map
                                                final medications = prescription[
                                                    'medications']; // Access medications from the map
                                                if (medications != null &&
                                                    medications
                                                        is List<dynamic>) {
                                                  // Check if medications is a list
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: medications
                                                        .map((medication) {
                                                      if (medication is Map<
                                                          String, dynamic>) {
                                                        // Check if medication is a map
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "MedicineType:",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " ${medication['medicineType'] ?? 'N/A'}",
                                                                  style: TextStyle(
                                                                    fontSize: 16,

                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Medicine:",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " ${medication['medicineName'] ?? 'N/A'}",
                                                                  style: TextStyle(
                                                                    fontSize: 16,

                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Medicine Strength:",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " ${medication['medicineStrength'] ?? 'N/A'}",
                                                                  style: TextStyle(
                                                                    fontSize: 16,

                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Medicine Dose",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " ${medication['medicineDose'] ?? 'N/A'}",
                                                                  style: TextStyle(
                                                                    fontSize: 16,

                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Intake Duration:",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " ${medication['intakeDuration'] ?? 'N/A'}",
                                                                  style: TextStyle(
                                                                    fontSize: 16,

                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "To Ne Taken :",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " ${medication['toBeTaken'] ?? 'N/A'}",
                                                                  style: TextStyle(
                                                                    fontSize: 16,

                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Medicine Intake Time:",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " ${medication['medicineIntakeTime']?.join(' , ') ?? 'N/A'}",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "ImportantNote:",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                Text(

                                                                  " ${medication['importantNote'] ?? 'N/A'}",
                                                                  style: TextStyle(
                                                                    fontSize: 16,

                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            SizedBox(
                                                                height: 20),
                                                          ],
                                                        );
                                                      } else {
                                                        return SizedBox(); // Return empty widget if medication is not a map
                                                      }
                                                    }).toList(),
                                                  );
                                                }
                                              }
                                              return SizedBox(); // Return empty widget if prescription is not a map or medications is not a list
                                            }).toList(),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Text(
                                errorMessage ?? 'No appointment data found.',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

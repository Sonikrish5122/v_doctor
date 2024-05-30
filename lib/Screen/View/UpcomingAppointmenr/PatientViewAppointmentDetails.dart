import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:v_doctor/API/PatientAPI/ViewAppointmentPatientAPI.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Model/ViewAppointmentPatientModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class PatientViewAppointmentDetails extends StatefulWidget {
  final String appointmentId;

  const PatientViewAppointmentDetails({Key? key, required this.appointmentId})
      : super(key: key);

  @override
  _PatientViewAppointmentDetailsState createState() =>
      _PatientViewAppointmentDetailsState();
}

class _PatientViewAppointmentDetailsState
    extends State<PatientViewAppointmentDetails> {
  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = true;
  String? errorMessage;
  PatientVIewAppointmentDetailsModel? viewAppointmentPatientModel;
  Dio dio = Dio();

  bool isCompleted = false; // Added this variable
  bool isCancelling = false;
  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    getAppointmentInfo();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void getAppointmentInfo() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        fetchViewAppointmentInfo();
      }
    });
  }

  void fetchViewAppointmentInfo() async {
    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      viewAppointmentPatientModel =
          await ViewAppointmentPatientDetailsAPIService()
              .getViewAppointmentDetails(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
        appointmentId: widget.appointmentId,
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

  void CancleAppointment() async {
    setState(() {
      isCancelling = true;
    });

    Map<String, dynamic> cancleData = {
      "is_cancel": true
    };

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;
      String appointmentId = widget.appointmentId;

      await dio.patch(
        API + 'appointment/cancel-appointment/$userId/$appointmentId',
        data: cancleData,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'user-id': userId,
          'user-type': userType,
        }),
      );

      showSnackbar('Appointment canceled successfully');
    } catch (e) {
      // Handle errors
      print(e);
      showSnackbar('Failed to cancel appointment');
    } finally {
      setState(() {
        isCancelling = false; // Set the flag back to false after cancellation completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isCancelled =
        viewAppointmentPatientModel?.data?.first?.isCanceled ?? false;

    if (isLoading) {
      return Scaffold(
        backgroundColor: ColorConstants.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: ColorConstants.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Appointment Details",
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (viewAppointmentPatientModel
                              ?.data?.first?.appointmentMode ==
                          'online')
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Start Video Call'),
                        ),


                      Card(
                        elevation: 10,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    appointment_icon,
                                    width: 30,
                                    height: 28,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Appointment Details",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Appointment ID: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    viewAppointmentPatientModel
                                            ?.data?.first?.uniqueId
                                            .toString() ??
                                        'N/A',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Doctor Name:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      '${viewAppointmentPatientModel?.data?.first?.doctorDetails?.first.name ?? 'N/A'}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Doctor Gender:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      '${viewAppointmentPatientModel?.data?.first?.doctorDetails?.first.gender ?? 'N/A'}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Clinic Address:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      '${viewAppointmentPatientModel?.data?.first.clinicInfo?.first.address ?? 'N/A'}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Appointment Date:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    viewAppointmentPatientModel
                                            ?.data?.first.appointmentDate ??
                                        'N/A',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Time:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    viewAppointmentPatientModel
                                            ?.data?.first?.time ??
                                        'N/A',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'Appointment Mode:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    viewAppointmentPatientModel?.data?.first?.appointmentMode == 'offline'
                                        ? 'Physical'
                                        : 'Virtual',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  border: isCancelled ? Border.all(color: Colors.grey) : null,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextButton(
                                  onPressed: isCancelling ? null : CancleAppointment, // Disable button if cancellation is in progress
                                  child: isCancelling
                                      ? CircularProgressIndicator() // Show CircularProgressIndicator while cancelling
                                      : Text(
                                    'Cancel Appointment',
                                    style: TextStyle(
                                      color: isCancelled ? Colors.grey : Colors.red,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // Questions Card
                      Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    questions_icon,
                                    width: 30,
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Questions",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Symptoms :',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          viewAppointmentPatientModel
                                                  ?.data?.first?.comment ??
                                              'N/A',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (viewAppointmentPatientModel != null &&
                                        viewAppointmentPatientModel!.data !=
                                            null)
                                      Column(
                                        children: viewAppointmentPatientModel!
                                            .data!
                                            .map((appointment) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: appointment
                                                .preDiagnosisQuestions!
                                                .map((question) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Q - ${question.question ?? ""}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Ans ${question.answer ?? ""}",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                ],
                                              );
                                            }).toList(),
                                          );
                                        }).toList(),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Payment Details Card
                      Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    secure_payment,
                                    width: 30,
                                    height: 28,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Payment Details",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(height: 10),
                              Text(
                                "Payment Mode: ${viewAppointmentPatientModel?.data?.first?.paymentStatus?.paymentMode == 'offline' ? 'Pay in Clinic' : viewAppointmentPatientModel?.data?.first?.paymentStatus?.paymentMode ?? 'N/A'}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Payment Status: ${viewAppointmentPatientModel?.data?.first?.paymentStatus?.status ?? 'N/A'}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Service Fees: ${viewAppointmentPatientModel?.data?.first?.paymentStatus?.amount ?? 0} \$",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Any Extra Charges: N/A",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Total Amount: ${viewAppointmentPatientModel?.data?.first?.paymentStatus?.amount ?? 0} \$",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Prescription Details Card
                      Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    prescription_icon,
                                    width: 30,
                                    height: 28,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Prescription Details",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(height: 10),
                              // Display prescription details
                              if (viewAppointmentPatientModel != null &&
                                  viewAppointmentPatientModel!.data != null)
                                Column(
                                  children: viewAppointmentPatientModel!.data!
                                      .map((appointment) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: appointment.prescription!
                                          .map((prescription) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: prescription.medications!
                                              .map((medication) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Prescription Medicine: ${medication.medicineName ?? 'N/A'}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Medicine Dose: ${medication.medicineDose ?? 'N/A'}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "To be Taken: ${medication.toBeTaken ?? 'N/A'}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Medicine Time: ${medication.medicineIntakeTime?.join(', ') ?? 'N/A'}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Intake Duration: ${medication.intakeDuration ?? 'N/A'}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Note: ${medication.importantNote ?? 'N/A'}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                              ],
                                            );
                                          }).toList(),
                                        );
                                      }).toList(),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

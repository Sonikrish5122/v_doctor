import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/PatientAPI/PrescriptionDetailsAPI.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Model/PrescriptionDetailsModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/colors.dart';

class PrescriptionDetails extends StatefulWidget {
  final String prescriptionId;

  const PrescriptionDetails({Key? key, required this.prescriptionId})
      : super(key: key);

  @override
  _PrescriptionDetailsState createState() => _PrescriptionDetailsState();
}

class _PrescriptionDetailsState extends State<PrescriptionDetails> {
  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = true;
  String? errorMessage;
  PrescriptionDetailsModel? prescriptionDetailsModel;

  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    getDoctorInfo();
  }

  void getDoctorInfo() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        fetchDoctorInfo();
      }
    });
  }

  void fetchDoctorInfo() async {
    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      prescriptionDetailsModel =
      await PrescriptionDetailsAPIService().getPrescriptionDetails(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
        prescriptionId: widget.prescriptionId,
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
    final double width = MediaQuery.of(context).size.width;

    if (isLoading) {
      return Scaffold(
        backgroundColor: ColorConstants.primaryColor,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (prescriptionDetailsModel == null ||
        prescriptionDetailsModel!.data == null ||
        prescriptionDetailsModel!.data!.isEmpty) {
      return Scaffold(
        backgroundColor: ColorConstants.primaryColor,
        body: Center(
          child: Text(
            'No prescription details available.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    String patientName =
        prescriptionDetailsModel!.data!.first.patient!.name ?? '';
    String patientGender =
        prescriptionDetailsModel!.data!.first.patient!.gender ?? '';
    String patientDOBString =
        prescriptionDetailsModel!.data!.first.patient?.dob ?? '';
    String patientMobileNo =
        prescriptionDetailsModel!.data!.first.patient?.mobileNo ?? '';
    int patientAge = calculateAge(patientDOBString);

    String doctorName = prescriptionDetailsModel!.data!.first.doctor?.name ?? '';
    String? doctorMobileNo =
        prescriptionDetailsModel!.data!.first.doctor?.mobileNo;
    List<Medications>? medications =
        prescriptionDetailsModel!.data!.first.medications;

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
                        "Details of Prescription",
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
                      // Doctor Details Card
                      Card(
                        elevation: 10,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Doctor Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              Divider(),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Prescription # ',
                                    style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 20,),
                                  Text(
                                      '${prescriptionDetailsModel!.data!.first.uniqueId ?? ''}',
                                    style: TextStyle(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),   SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Doctor Name:',
                                    style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 20,),
                                  Text(
                                    '$doctorName',
                                    style: TextStyle(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Doctor Mobile No:',
                                    style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 20,),
                                  Text(
                                    '$doctorMobileNo',
                                    style: TextStyle(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),


                      SizedBox(height: 20,),
                      Card(
                        elevation: 10,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patient Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              Divider(),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Patient Name:',
                                    style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 20,),
                                  Text(
                                    '$patientName',
                                    style: TextStyle(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Gender:',
                                    style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 20,),
                                  Text(
                                    '$patientGender',
                                    style: TextStyle(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Age:',
                                    style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 20,),
                                  Text(
                                    '$patientAge',
                                    style: TextStyle(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Mobile No:',
                                    style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 20,),
                                  Text(
                                    '$patientMobileNo',
                                    style: TextStyle(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),


                      SizedBox(height: 20,),
                      Card(
                        elevation: 10,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Medications Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              Divider(),
                              SizedBox(height: 10),
                              if (medications != null)
                                ...medications.map((medication) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Text(
                                            'Medicine Type:',
                                            style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 20,),
                                          Text(
                                            '${medication.medicineType}',
                                            style: TextStyle(color: Colors.black,fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'Medicine Name:',
                                            style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 20,),
                                          Text(
                                            '${medication.medicineName}',
                                            style: TextStyle(color: Colors.black,fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'Strength:',
                                            style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 20,),
                                          Text(
                                            '${medication.medicineStrength}',
                                            style: TextStyle(color: Colors.black,fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'Dose:',
                                            style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 20,),
                                          Text(
                                            '${medication.medicineDose}',
                                            style: TextStyle(color: Colors.black,fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'Intake Duration:',
                                            style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 20,),
                                          Text(
                                            '${medication.intakeDuration}',
                                            style: TextStyle(color: Colors.black,fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'To be Taken: ',
                                            style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 20,),
                                          Text(
                                            '${medication.toBeTaken}',
                                            style: TextStyle(color: Colors.black,fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'Medicine Time: ',
                                            style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 20,),
                                          Text(
                                          '${medication.medicineIntakeTime?.join(" , ") ?? "N/A"}',
                                            style: TextStyle(color: Colors.black,fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Note: ',
                                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 20,),
                                          Flexible(
                                            child: Text(
                                              '${medication.importantNote}',
                                              style: TextStyle(color: Colors.black, fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),


                                      SizedBox(height: 10),
                                    ],
                                  );
                                }).toList(),

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

  // Function to calculate age from date of birth
  int calculateAge(String dobString) {
    DateTime dob = DateFormat("dd-MM-yyyy").parse(dobString);
    DateTime now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }
}

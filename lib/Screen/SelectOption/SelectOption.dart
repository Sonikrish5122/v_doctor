import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:v_doctor/Common%20Widget/LogoTitle.dart';
import 'package:v_doctor/Screen/LoginScreen/LoginUser.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';
import 'package:v_doctor/utils/style.dart';

class DoctorAndPatient {
  final String id;
  final String name;
  final int type;

  DoctorAndPatient({
    required this.id,
    required this.name,
    required this.type,
  });

  factory DoctorAndPatient.fromJson(Map<String, dynamic> json) {
    return DoctorAndPatient(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
    );
  }
}

class SelectOptionScreen extends StatefulWidget {
  const SelectOptionScreen({Key? key}) : super(key: key);

  @override
  State<SelectOptionScreen> createState() => _SelectOptionScreenState();
}

class _SelectOptionScreenState extends State<SelectOptionScreen> {
  Dio dio = Dio();
  String? _selectedCard;

  List<DoctorAndPatient> doctorAndPatientData = [];

  Future<void> fetchData() async {
    try {
      Response response = await dio.get(API + 'user/doctor-and-patient');
      Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
      List<dynamic> data = responseData['data'] as List<dynamic>;
      setState(() {
        doctorAndPatientData =
            data.map((item) => DoctorAndPatient.fromJson(item)).toList();
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  void _selectCard(String cardName) {
    setState(() {
      _selectedCard = cardName;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _navigateToLoginScreen(BuildContext context) {
    if (_selectedCard != null) {
      final selectedId = doctorAndPatientData
          .firstWhere(
            (element) => element.name == _selectedCard!,
            orElse: () => DoctorAndPatient(id: '', name: '', type: 0),
          )
          .id;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginUser(
              selectedCardId: selectedId, selectedCard: _selectedCard!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(selectSnackBartxt),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoTitle(),
              SizedBox(height: 5),
              Text(
                continue_as,
                style: continueas.copyWith(
                  color: ColorConstants.secondaryTextColor,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (doctorAndPatientData.isNotEmpty) {
                        _selectCard(doctorAndPatientData[0].name);
                      }
                    },
                    child: Container(
                      child: Card(
                        elevation: _selectedCard ==
                                (doctorAndPatientData.isNotEmpty
                                    ? doctorAndPatientData[0].name
                                    : null)
                            ? 5
                            : 0,
                        color: _selectedCard ==
                                (doctorAndPatientData.isNotEmpty
                                    ? doctorAndPatientData[0].name
                                    : null)
                            ? ColorConstants.secondaryAppColor
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: _selectedCard ==
                                    (doctorAndPatientData.isNotEmpty
                                        ? doctorAndPatientData[0].name
                                        : null)
                                ? ColorConstants.secondaryAppColor
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Container(
                          width: screenWidth * 0.30,
                          height: screenHeight * 0.20,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(doctor_logo, height: 70),
                              SizedBox(height: 10),
                              Text(
                                doctorAndPatientData.isNotEmpty
                                    ? doctorAndPatientData[0].name
                                    : '',
                                style: TextStyle(
                                  color: _selectedCard ==
                                          (doctorAndPatientData.isNotEmpty
                                              ? doctorAndPatientData[0].name
                                              : null)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (doctorAndPatientData.length > 1) {
                        _selectCard(doctorAndPatientData[1].name);
                      }
                    },
                    child: Card(
                      elevation: _selectedCard ==
                              (doctorAndPatientData.length > 1
                                  ? doctorAndPatientData[1].name
                                  : null)
                          ? 5
                          : 0,
                      color: _selectedCard ==
                              (doctorAndPatientData.length > 1
                                  ? doctorAndPatientData[1].name
                                  : null)
                          ? ColorConstants.secondaryAppColor
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: _selectedCard ==
                                  (doctorAndPatientData.length > 1
                                      ? doctorAndPatientData[1].name
                                      : null)
                              ? ColorConstants.secondaryAppColor
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        width: screenWidth * 0.30,
                        height: screenHeight * 0.20,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(patient_logo, height: 70),
                            SizedBox(height: 10),
                            Text(
                              doctorAndPatientData.length > 1
                                  ? doctorAndPatientData[1].name
                                  : '',
                              style: TextStyle(
                                color: _selectedCard ==
                                        (doctorAndPatientData.length > 1
                                            ? doctorAndPatientData[1].name
                                            : null)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: ColorConstants.secondaryAppColor,
                ),
                child: IconButton(
                  onPressed: () => _navigateToLoginScreen(context),
                  icon: Icon(Icons.arrow_forward_outlined,
                      size: 25, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

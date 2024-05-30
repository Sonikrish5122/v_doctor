import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:v_doctor/API/PatientAPI/GetAllPrescriptionAPI.dart';
import 'package:v_doctor/Model/GetAllPrescriptionModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/Drawer/PatientDrawer.dart';
import 'package:v_doctor/Screen/GetAllPrescription/PrescriptionDeatils.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/colors.dart';

class GetAllPrescription extends StatefulWidget {
  const GetAllPrescription({Key? key}) : super(key: key);

  @override
  State<GetAllPrescription> createState() => _GetAllPrescriptionState();
}

class _GetAllPrescriptionState extends State<GetAllPrescription> {
  late double height;
  late double width;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  Dio dio = Dio();
  SessionManager? sessionManager;
  UserData? userData;
  GetAllPrescriptionModel? getAllPrescriptionModel;

  bool _isLoading = false;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    sessionManager = SessionManager();
    getPrescriptionInfo();

    super.initState();
  }

  void getPrescriptionInfo() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        getPrescriptionList();
      }
    });
  }

  void getPrescriptionList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      GetAllPrescriptionModel prescriptionModel =
          await GetPrescriptionListAPIService().getPrescriptionList(
        accessToken: userData!.accessToken,
        userId: userData!.userId,
        userType: userData!.userType,
      );

      setState(() {
        getAllPrescriptionModel = prescriptionModel;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackbar('Failed to fetch prescription data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _globalKey,
      backgroundColor: ColorConstants.primaryColor,
      drawer: PatientDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.08,
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu, color: ColorConstants.white),
                        onPressed: () {
                          _globalKey.currentState?.openDrawer();
                        },
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Prescription List",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.9,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.builder(
                          itemCount: getAllPrescriptionModel?.data?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            final appointment = getAllPrescriptionModel
                                ?.data?[index].appointment;
                            final doctorName = getAllPrescriptionModel
                                    ?.data?[index].doctor?.name ??
                                'N/A';
                            final appointmentId =
                                appointment?.uniqueId ?? 'N/A';
                            final appointmentModeType =
                                '${appointment?.mode ?? 'N/A'} / ${appointment?.type ?? 'N/A'}';
                            final appointmentTime = appointment?.time ?? 'N/A';
                            final appointmentDate = appointment?.date ?? 'N/A';
                            final prescriptionDate = getAllPrescriptionModel
                                    ?.data?[index].createdAt ??
                                'N/A';
                            return Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PrescriptionDetails(
                                                prescriptionId:
                                                    getAllPrescriptionModel
                                                            ?.data?[index]
                                                            .prescriptionId ??
                                                        ''),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(
                                      'Doctor Name: $doctorName',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Appointment ID: $appointmentId'),
                                        Text(
                                            'Appointment Mode / Type: $appointmentModeType'),
                                        Text(
                                            'Appointment Time: $appointmentTime'),
                                        Text(
                                            'Appointment Date: $appointmentDate'),
                                        Text(
                                            'Prescription Date: $prescriptionDate'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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

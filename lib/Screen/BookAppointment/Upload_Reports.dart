import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/PatientAPI/GetReportsAPI.dart';
import 'package:v_doctor/API/PatientAPI/UploadReportAPI.dart';
import 'package:v_doctor/Model/DiagnosisQuestionsModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Model/GetReportsModel.dart';
import 'package:v_doctor/Screen/BookAppointment/ShowBookingDetails.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/colors.dart';

class UploadReports extends StatefulWidget {
  final String name;
  final String doctor_id;
  final String fees;
  final String symptomsText;
  final String address;
  final DateTime selectedDate;
  final String selectedSlot;
  final String selectedDay;
  final String appointmentMode;
  final Map<int, dynamic> questionData;
  final Map<int, String> textFieldData;
  final List<Questions> questions;

  const UploadReports({
    Key? key,
    required this.name,
    required this.doctor_id,
    required this.fees,
    required this.questionData,
    required this.textFieldData,
    required this.questions,
    required this.symptomsText,
    required this.address,
    required this.selectedDate,
    required this.selectedSlot,
    required this.selectedDay,
    required this.appointmentMode,
  }) : super(key: key);

  @override
  State<UploadReports> createState() => _UploadReportsState();
}

class _UploadReportsState extends State<UploadReports> {
  bool isExpanded = false;
  bool isAddressExpanded = false;
  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = false;
  String? errorMessage;
  GetReportsModel? getReportsModel;
  String? fileName;
  File? selectedFile;
  TextEditingController _reportTitleController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _reportDateController = TextEditingController();
  Map<String, bool> checkedStatus = {};
  List<String> selectedReportNames = [];

  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    _initializeData();
    getReports();
  }

  void _initializeData() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        setState(() {
          userData = value;
        });
      }
    });
  }

  void fetchReports() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      getReportsModel = await GetReportsAPIService().getReports(
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

  void getReports() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        fetchReports();
      }
    });
  }

  void _openCamera(BuildContext context, StateSetter setStateDialog) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      setStateDialog(() {
        fileName = image.name;
      });
      setState(() {
        selectedFile = File(image.path);
      });
    }
  }

  void _openGallery(BuildContext context, StateSetter setStateDialog) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setStateDialog(() {
        fileName = image.name;
      });
      setState(() {
        selectedFile = File(image.path);
      });
    }
  }

  void _openFilePicker(BuildContext context, StateSetter setStateDialog) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setStateDialog(() {
        fileName = file.name;
      });
      setState(() {
        fileName = file.name;
        selectedFile = File(file.path!);
      });
    }
  }

  void _submitReport() async {
    String accessToken = userData!.accessToken;
    String userId = userData!.userId;
    String userType = userData!.userType;

    String reportName = _reportTitleController.text;
    String patientName = _patientNameController.text;
    String reportDate = _reportDateController.text;

    if (reportName.isEmpty ||
        patientName.isEmpty ||
        reportDate.isEmpty ||
        selectedFile == null) {
      setState(() {
        errorMessage = 'Please fill in all fields and select a file.';
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await UploadReportAPIService().uploadReport(
        file: selectedFile!,
        reportName: reportName,
        reportDate: reportDate,
        patientName: patientName,
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      fetchReports();

      setState(() {
        isLoading = true;
        fileName = selectedFile!.path.split('/').last;
      });

      _reportTitleController.clear();
      _patientNameController.clear();
      _reportDateController.clear();
      selectedFile = null;

      Navigator.of(context).pop();
    } catch (e) {
      print('Error uploading report: $e');
      setState(() {
        errorMessage = 'Failed to upload report. Please try again later.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearFields() {
    _reportTitleController.clear();
    _patientNameController.clear();
    _reportDateController.clear();
    setState(() {
      fileName = null;
      selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            icon: Icon(Icons.arrow_back_ios,
                                color: ColorConstants.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Reports",
                            style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.89,
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
                          : ListView.builder(
                              itemCount: getReportsModel?.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                var data = getReportsModel!.data![index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: data.reports?.length ?? 0,
                                      itemBuilder: (context, idx) {
                                        var report = data.reports![idx];
                                        return CheckboxListTile(
                                          title: Text(
                                            report.reportName ?? '',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          value: selectedReportNames
                                              .contains(report.reportName),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (value ?? false) {
                                                selectedReportNames
                                                    .add(report.reportName!);
                                              } else {
                                                selectedReportNames
                                                    .remove(report.reportName);
                                              }
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      onPressed: () async {
                        await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Upload Test Report',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black45,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.19,
                                              height: width * 0.25,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blue,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _openCamera(
                                                      context, setState);
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.blue,
                                                      size: width *
                                                          0.1, // Adjusted size
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text(
                                                      'Camera',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: width * 0.05),
                                            Container(
                                              width: width * 0.19,
                                              height: width * 0.25,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _openGallery(
                                                      context, setState);
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.photo,
                                                      color: Colors.green,
                                                      size: width * 0.1,
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text(
                                                      'Gallery',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: width * 0.05),
                                            Container(
                                              width: width * 0.19,
                                              height: width * 0.25,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.red,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _openFilePicker(
                                                      context, setState);
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.attach_file,
                                                      color: Colors.red,
                                                      size: width * 0.1,
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text(
                                                      'Files',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          fileName != null ? '$fileName' : '',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        SizedBox(height: 16),
                                        TextField(
                                          controller: _reportTitleController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Report Title',
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        TextField(
                                          controller: _patientNameController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Patient Name',
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        TextFormField(
                                          controller: _reportDateController,
                                          decoration: InputDecoration(
                                            labelText: 'Report Date',
                                            border: OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _selectDate(context);
                                              },
                                              icon: Icon(Icons.calendar_today),
                                            ),
                                          ),
                                          readOnly: true,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    _clearFields();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  onPressed: isLoading ? null : _submitReport,
                                  child: isLoading
                                      ? CircularProgressIndicator()
                                      : Text('Submit'),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Upload Report'),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      onPressed: () {
                        List<String> selectedReportIds = [];
                        for (var report in getReportsModel!.data!) {
                          for (var r in report.reports!) {
                            if (selectedReportNames.contains(r.reportName)) {
                              selectedReportIds.add(r.reportId!);
                            }
                          }
                        }
                        Get.to(
                          ShowBookingDetails(
                            name: widget.name,
                            doctor_id: widget.doctor_id,
                            fees: widget.fees,
                            questionData: widget.questionData,
                            textFieldData: widget.textFieldData,
                            questions: widget.questions,
                            symptomsText: widget.symptomsText,
                            selectedReportName: selectedReportNames,
                            selectedReportId: selectedReportIds,
                            address: widget.address,
                            selectedDate: widget.selectedDate,
                            selectedSlot: widget.selectedSlot,
                            selectedDay: DateFormat('EEEE').format(widget.selectedDate),
                            appointmentMode: widget.appointmentMode,
                          ),
                        );
                      },
                      child: Text('Confirm Booking'),
                    ),

                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      keyboardType: TextInputType.datetime,
      context: context,
      barrierDismissible: false,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      String formattedDate = DateFormat('dd-MMMM-yyyy').format(picked);
      setState(() {
        _reportDateController.text = formattedDate;
      });
    }
  }
}

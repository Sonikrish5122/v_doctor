import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/PatientAPI/GetReportsAPI.dart';
import 'package:v_doctor/API/PatientAPI/UploadReportAPI.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Model/GetReportsModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/colors.dart';

class LabReports extends StatefulWidget {
  const LabReports({Key? key}) : super(key: key);

  @override
  State<LabReports> createState() => _LabReportsState();
}

class _LabReportsState extends State<LabReports> {
  bool isExpanded = false;
  bool isAddressExpanded = false;
  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = false;
  String? errorMessage;
  GetReportsModel? getReportsModel;
  String? fileName;
  File? selectedFile;
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
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Table(
                                            children: [
                                              TableRow(
                                                children: <Widget>[
                                                  Text("Patient Name",
                                                      style: TextStyle(
                                                          fontSize: 16.0)),
                                                  TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .top,
                                                    child: Text("Report Name",
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                  Text("Report Date",
                                                      style: TextStyle(
                                                          fontSize: 16.0)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 3,
                                          color: Colors.black,
                                        ),
                                        SingleChildScrollView(
                                          child: Container(
                                            height:
                                                500, // Adjust the height according to your needs
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: ScrollPhysics(),
                                              itemCount:
                                                  data.reports?.length ?? 0,
                                              itemBuilder: (context, idx) {
                                                var report = data.reports![idx];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: Table(
                                                      children: [
                                                        TableRow(
                                                          children: <Widget>[
                                                            Text(report
                                                                    .patientName ??
                                                                ''),
                                                            TableCell(
                                                              verticalAlignment:
                                                                  TableCellVerticalAlignment
                                                                      .top,
                                                              child: Text(report
                                                                      .reportName ??
                                                                  ''),
                                                            ),
                                                            Text(report
                                                                    .reportDate ??
                                                                ''),

                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
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
        ],
      ),
    );
  }
}

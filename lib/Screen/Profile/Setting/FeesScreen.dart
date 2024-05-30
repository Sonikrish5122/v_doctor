import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:v_doctor/API/DoctorAPI/FeesAPI.dart';
import 'package:v_doctor/Model/DoctorModel/FeesStructureModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  TextEditingController _offlineFeesController = TextEditingController();
  TextEditingController _ongoingCaseFeesController = TextEditingController();

  TextEditingController _onlineongoingCaseFeesController =
  TextEditingController();
  TextEditingController _onlineFeesController = TextEditingController();

  bool _acceptOfflinePaymentMode = false;
  bool _acceptOnlinePaymentMode = false;

  bool isLoading = false;
  SessionManager sessionManager = SessionManager();
  UserData? userData;
  FeesStructureModel? feesStructureModel;
  String? errorMessage;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void getInfo() async {
    await sessionManager.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        getFeesStructure();
      }
    });
  }

  void getFeesStructure() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      feesStructureModel = await FeesAPIService().getFees(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      if (feesStructureModel!.success == true &&
          feesStructureModel!.data != null &&
          feesStructureModel!.data!.isNotEmpty) {
        Data data = feesStructureModel!.data![0];

        setState(() {
          isLoading = false;

          _acceptOnlinePaymentMode = data.acceptedPaymentMode!.contains("online");
          _acceptOfflinePaymentMode = data.acceptedPaymentMode!.contains("offline");

          _offlineFeesController.text = data.offlineNewCaseFees ?? '';
          _ongoingCaseFeesController.text = data.offlineOngoingCaseFees ?? '';
          _onlineFeesController.text = data.onlineNewCaseFees ?? '';
          _onlineongoingCaseFeesController.text =
              data.onlineOngoingCaseFees ?? '';
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please try again later.';
        isLoading = false;
      });
      print(e);
    }
  }

  void UpdateFreesStructure() async {
    Map<String, dynamic> feesStructure = {
      'offline_new_case_fees': _offlineFeesController.text,
      'offline_ongoing_case_fees': _ongoingCaseFeesController.text,
      'online_new_case_fees': _onlineFeesController.text,
      'online_ongoing_case_fees': _onlineongoingCaseFeesController.text,
      'accepted_payment_mode': [
        _acceptOnlinePaymentMode ? 'online' : '',
        _acceptOfflinePaymentMode ? 'offline' : '',
      ].where((element) => element.isNotEmpty).toList(), // Remove empty strings
    };

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      await dio.patch(
        API +
            'doctor/add-or-update-fees-structure/$userId?step=2&first_login=true',
        data: feesStructure,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'user-id': userId,
          'user-type': userType,
        }),
      );

      // Show success message
      showSnackbar('Fees structure updated successfully');
    } catch (e) {
      // Handle errors
      print(e);
      showSnackbar('Failed to update fees structure');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Fees Structure",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text(
                "Offline",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType:
                TextInputType.numberWithOptions(decimal: true),
                controller: _offlineFeesController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.currency_rupee,
                    color: Colors.black,
                  ),
                  labelText: 'New Case Fees',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _ongoingCaseFeesController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.currency_rupee,
                    color: Colors.black,
                  ),
                  labelText: 'Ongoing Case Fees',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Online",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _onlineFeesController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.currency_rupee,
                    color: Colors.black,
                  ),
                  labelText: 'New Case Fees',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _onlineongoingCaseFeesController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.currency_rupee,
                    color: Colors.black,
                  ),
                  labelText: 'Ongoing Case Fees',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text("Payment Acceptance Mode",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Container(
                child: Row(
                  children: [
                    Checkbox(
                      value: _acceptOnlinePaymentMode,
                      onChanged: (value) {
                        setState(() {
                          _acceptOnlinePaymentMode = value ?? false;
                        });
                      },
                    ),
                    Text("Online"),
                    SizedBox(width: 10),
                    Checkbox(
                      value: _acceptOfflinePaymentMode,
                      onChanged: (value) {
                        setState(() {
                          _acceptOfflinePaymentMode = value ?? false;
                        });
                      },
                    ),
                    Text("Offline"),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  UpdateFreesStructure();
                },
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

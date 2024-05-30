import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:v_doctor/API/DoctorAPI/GetClinicInfo.dart';
import 'package:v_doctor/Model/DoctorModel/GetClinicInfoModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';

class ClinicInfoScreen extends StatefulWidget {
  const ClinicInfoScreen({Key? key}) : super(key: key);

  @override
  State<ClinicInfoScreen> createState() => _ClinicInfoScreenState();
}

class _ClinicInfoScreenState extends State<ClinicInfoScreen> {
  final TextEditingController _addressControllerUrl = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  bool isLoading = false;
  SessionManager sessionManager = SessionManager();
  UserData? userData;
  GetClinicInfoModel? getClinicInfoModel;
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
        getClinicInfo();
      }
    });
  }

  void getClinicInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      getClinicInfoModel = await GetClinicInfoAPIService().getClinicInfo(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      if (getClinicInfoModel!.success == true &&
          getClinicInfoModel!.data != null) {
        Data clinicData = getClinicInfoModel!.data![0];

        setState(() {
          isLoading = false;
          _addressController.text = clinicData.address ?? '';
          _addressControllerUrl.text = clinicData.addressUrl ?? '';
          _countryController.text = clinicData.country ?? '';
          _stateController.text = clinicData.state ?? '';
          _cityController.text = clinicData.city ?? '';
          _zipCodeController.text = clinicData.zipCode ?? '';
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

  void UpdateClinicInfo() async {
    Map<String, dynamic> clinicInfoData = {
      'country': _countryController.text,
      'state': _stateController.text,
      'city': _cityController.text,
      'zipCode': _zipCodeController.text,
      'address': _addressController.text,
      'address_url': _addressControllerUrl.text,
    };
    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      await dio.patch(
        API +
            'doctor/add-or-update-clinic-info/$userId?step=1&first_login=true', // Replace this with your actual API endpoint
        data: clinicInfoData,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'user-id': userId,
          'user-type': userType,
        }),
      );

      showSnackbar('Clinic information updated successfully');
    } catch (e) {
      // Handle errors
      print(e);
      showSnackbar('Failed to update clinic information');
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
                    Text("Clinic Information",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _addressControllerUrl,
                      decoration: InputDecoration(
                        labelText: 'Address Url',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _countryController,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _zipCodeController,
                      decoration: InputDecoration(
                        labelText: 'Zip Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        UpdateClinicInfo();
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

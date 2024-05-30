import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/Model/GetProfileModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Model/UpdateProfileModel.dart';
import 'package:v_doctor/Screen/Drawer/PatientDrawer.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

import '../../API/PatientAPI/PatientDetails.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  late double height;
  late double width;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  String? _selectedGender;
  Dio dio = Dio();
  List<String> genderOptions = ['female', 'male'];

  List<PatientDetails> patientDetails = [];
  SessionManager? sessionManager;
  UserData? userData;
  late ProfileManager profileManager;

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
    profileManager = ProfileManager();
    getUserInfo();
    getData();
    super.initState();
  }

  void getUserInfo() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        getData();
      }
    });
  }

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      var response = await dio.get(
        API + 'patient/details/$userId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'user-id': userId,
            'user-type': userType,
          },
        ),
      );

      GetProfileModel profileModel = GetProfileModel.fromJson(response.data);


      if (profileModel.success) {
        PatientData patientData = profileModel.data.first;
        String name = _nameController.text;
        setState(() {
          _nameController.text = patientData.name;
          _phoneController.text = patientData.mobileNo;
          _dobController.text = patientData.dob;
          _selectedGender = patientData.gender;
        });
        await profileManager.saveName(name);
        showSnackbar('Profile data fetched successfully');
      } else {
        showSnackbar('Failed to fetch profile data');
      }
    } catch (e) {
      print(e);
      showSnackbar('Failed to fetch profile data');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void updateProfile() async {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String dob = _dobController.text;
    String gender = _selectedGender ?? '';

    if (name.isEmpty || phone.isEmpty || dob.isEmpty || gender.isEmpty) {
      showSnackbar('Please fill in all fields');
      return;
    }

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      var response = await dio.post(
        API + 'patient/updatePatient/$userId',
        data: {
          'name': name,
          'mobile_no': phone,
          'dob': dob,
          'gender': gender,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'user-id': userId,
            'user-type': userType,
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = UpdateProfileDataModel.fromJson(response.data);
        if (responseData.success != null && responseData.success!) {
          var updatedPatientData = responseData.data?.first;
          if (updatedPatientData != null) {
            setState(() {
              _nameController.text = updatedPatientData.name ?? '';
              _phoneController.text = updatedPatientData.mobileNo ?? '';
              _dobController.text = updatedPatientData.dob ?? '';
              _selectedGender = updatedPatientData.gender ?? '';
            });
            showSnackbar(
                responseData.message ?? 'Profile updated successfully');

            await profileManager.saveName(name);
          } else {
            showSnackbar('No data received');
          }
        } else {
          showSnackbar('Failed to update profile: ${responseData.message}');
        }
      } else {
        showSnackbar(
            'Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showSnackbar('Failed to update profile: $e');
    }
  }

  void _takePhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {});
    }
  }

  void _chooseFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _selectedGender = _selectedGender;
    return Scaffold(
      key: _globalKey,
      backgroundColor: ColorConstants.primaryColor,
      drawer: PatientDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.11,
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
                        "Profile",
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        SizedBox(height: 20,),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {},
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Mobile',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {},
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _dobController,
                              decoration: InputDecoration(
                                labelText: 'Birth Date',
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
                            SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                              items: genderOptions
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.toUpperCase()),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  updateProfile();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    'SAVE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        _dobController.text = formattedDate;
      });
    }
  }
}

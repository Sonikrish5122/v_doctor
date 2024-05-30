import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:v_doctor/API/DoctorAPI/GetAllDegreeAPI.dart';
import 'package:v_doctor/API/DoctorAPI/GetDoctorProfile.dart';
import 'package:v_doctor/API/PatientAPI/SpecialityAPIService.dart';
import 'package:v_doctor/Model/DoctorModel/DoctorDetailsModel.dart';
import 'package:v_doctor/Model/DoctorModel/GetAllDegreeModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Model/SpecialityModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _experienceController;
  late TextEditingController _aboutUsController;

  bool isLoading = false;
  SessionManager sessionManager = SessionManager();
  UserData? userData;
  DoctorDetailsModel? doctorDetailsModel;
  String? errorMessage;
  Dio dio = Dio();
  String? _selectedGender;
  List<String> genderOptions = ['female', 'male'];
  List<SpecialityData> specialities = [];
  List<DegreeData> degrees = [];
  List<DegreeData> _selectedDegrees = [];
  List<SpecialityData> _initialSelectedSpecialities = <SpecialityData>[];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mobileController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _experienceController = TextEditingController();
    _aboutUsController = TextEditingController();
    getDoctorDetails();
    fetchSpeciality();
    fetchAllDegree();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> fetchSpeciality() async {
    try {
      List<SpecialityData> fetchedSpecialities =
          await SpecialityAPIService().fetchSpecialities();

      setState(() {
        specialities = fetchedSpecialities;
      });
    } catch (e) {
      print('Error fetching specialities: $e');
    }
  }

  Future<void> fetchAllDegree() async {
    try {
      List<DegreeData> fetchedDegree =
          await GetAllDegreeAPIService().fetchDegree();

      setState(() {
        degrees = fetchedDegree;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void getDoctorDetails() async {
    await sessionManager.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        getDoctorInfo();
      }
    });
  }

  void getDoctorInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      GetDoctorDetailsAPIService doctorDetailsService =
          GetDoctorDetailsAPIService();

      DoctorDetailsModel doctorDetailsModel =
          await doctorDetailsService.getDoctor(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      setState(() {
        isLoading = false;

        if (doctorDetailsModel.data != null &&
            doctorDetailsModel.data!.isNotEmpty) {
          // Update the profile picture along with other details
          this.doctorDetailsModel = doctorDetailsModel;

          var doctorData = doctorDetailsModel.data![0];
          _nameController.text = doctorData.name ?? '';
          _mobileController.text = doctorData.mobileNo ?? '';
          _dateOfBirthController.text = doctorData.dob ?? '';
          _selectedGender = doctorData.gender;
          _experienceController.text = doctorData.experience?.toString() ?? '';
          _aboutUsController.text = doctorData.about ?? '';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please try again later.';
        isLoading = false;
      });
      print(e);
    }
  }

  void saveProfile() async {
    List<String?> selectedDegreeIds =
        _selectedDegrees.map((degree) => degree.sId).toList();
    List<String?> selectedSpecialityIds = _initialSelectedSpecialities
        .map((speciality) => speciality.sId)
        .toList();

    Map<String, dynamic> saveProfileData = {
      'gender': _selectedGender,
      'experience': int.tryParse(_experienceController.text) ?? 0,
      'mobile_no': _mobileController.text,
      'about': _aboutUsController.text,
      'name': _nameController.text,
      'speciality': selectedSpecialityIds.join(','),
      'degree': selectedDegreeIds.join(','),
      'dob': _dateOfBirthController.text,
    };

    try {
      String accessToken = userData!.accessToken!;
      String userId = userData!.userId!;
      String userType = userData!.userType!;

      await dio.patch(
        API + 'doctor/updateProfile/$userId?step=0&first_login=true',
        data: saveProfileData,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'user-id': userId,
          'user-type': userType,
        }),
      );

      showSnackbar('Profile updated successfully');
    } catch (e) {
      print(e);
      showSnackbar('Failed to update profile');
    }
  }

  void updateImage(String updatedImageUrl) async {
    Map<String, dynamic> updateImageData = {
      'profile_pic': updatedImageUrl,
    };

    try {
      String accessToken = userData!.accessToken!;
      String userId = userData!.userId!;
      String userType = userData!.userType!;

      await dio.patch(
        API + 'common/update-profile-image/$userId',
        data: updateImageData,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'user-id': userId,
          'user-type': userType,
        }),
      );

      showSnackbar('Profile image updated successfully');
    } catch (e) {
      print(e);
      showSnackbar('Failed to update profile image');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    _selectedGender = _selectedGender;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                doctorDetailsModel?.data?.first.profilePic ??
                                    profileTemp,
                              ),
                              radius: 60,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 80,
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.primaryColor,
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.camera),
                                color: Colors.white,
                                iconSize: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          personalDetailsText,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                        controller: _mobileController,
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
                        controller: _dateOfBirthController,
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
                        items: genderOptions.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.toUpperCase()),
                            );
                          },
                        ).toList(),
                      ),
                      SizedBox(height: 20),
                      MultiSelectDialogField<SpecialityData>(
                        items: specialities
                            .map((speciality) =>
                                MultiSelectItem<SpecialityData>(speciality,
                                    speciality.specialityName ?? ''))
                            .toList(),
                        initialValue: _initialSelectedSpecialities,
                        title: Text('Select Specialities'),
                        buttonText: Text('Select Specialities'),
                        onConfirm: (values) {
                          setState(() {
                            _initialSelectedSpecialities = values;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      MultiSelectDialogField<DegreeData>(
                        items: degrees
                            .map((degree) => MultiSelectItem<DegreeData>(
                                degree, degree.degreeName ?? ''))
                            .toList(),
                        initialValue: _selectedDegrees,
                        title: Text('Select Degrees'),
                        buttonText: Text('Select Degrees'),
                        onConfirm: (values) {
                          setState(() {
                            _selectedDegrees = values;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _experienceController,
                        decoration: InputDecoration(
                          labelText: experiencetxt,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {},
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            yeartxt,
                          )),
                      SizedBox(height: 20),
                      TextField(
                        controller: _aboutUsController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: aboutustxt,
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            saveProfile();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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
        _dateOfBirthController.text = formattedDate;
      });
    }
  }
}

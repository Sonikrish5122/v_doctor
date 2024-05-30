import 'package:flutter/material.dart';
import 'package:v_doctor/API/PatientAPI/DoctorDetailsAPI.dart';
import 'package:v_doctor/Common%20Widget/Common_card.dart';
import 'package:v_doctor/Model/DoctorDetailsModel/DoctorDetailsModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/Drawer/PatientDrawer.dart';
import 'package:v_doctor/Screen/View/view_details.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class DoctorSpecialityScreen extends StatefulWidget {
  final String? specialityName;
  final String specialityId;

  const DoctorSpecialityScreen({
    Key? key,
    required this.specialityName,
    required this.specialityId,
  }) : super(key: key);

  @override
  State<DoctorSpecialityScreen> createState() => _DoctorSpecialityScreenState();
}

class _DoctorSpecialityScreenState extends State<DoctorSpecialityScreen> {
  late double height;
  late double width;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  SessionManager? sessionManager;
  UserData? userData;
  DoctorProfileModel? doctorDetails;
  bool isLoading = false;
  String? errorMessage;

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
        getData();
      }
    });
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      doctorDetails =
          await DoctorDetailsAPIService().getDoctorDetailsBySpeciality(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
        specialityId: widget.specialityId,
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final specialityName = widget.specialityName ?? "";

    return Scaffold(
      key: _globalKey,
      backgroundColor: ColorConstants.primaryColor,
      drawer: PatientDrawer(),
      body: Column(
        children: [
          Container(
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
                    Expanded(
                      child: _showSearch
                          ? TextField(
                              controller: _searchController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                border: InputBorder.none,
                              ),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          : Text(
                              specialityName,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showSearch = !_showSearch;
                          if (!_showSearch) {
                            _searchController.clear();
                          }
                        });
                      },
                      icon: Icon(
                        _showSearch ? Icons.close : Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: doctorDetails != null && !isLoading
                  ? ListView.builder(
                      itemCount: doctorDetails!.data!.length,
                      itemBuilder: (context, index) {
                        final data = doctorDetails!.data![index];
                        final bool matchesSearch = _searchController
                                .text.isEmpty ||
                            data.doctorProfile!.name!.toLowerCase().contains(
                                  _searchController.text.toLowerCase(),
                                );

                        if (!matchesSearch) {
                          return SizedBox.shrink();
                        }
                        return CommonCard(
                          profileImageUrl:
                              data.doctorProfile?.profilePic ?? profileTemp,
                          name: data.doctorProfile?.name ?? '',
                          specialties: data.specialities
                                  ?.map((e) => e.specialityName)
                                  .join(', ') ??
                              '',
                          experience:
                              '${data.doctorProfile?.experience} years of experience',
                          address: data.clinicInfo?.first.address ?? '',
                          price: '${data.fees?.offlineNewCaseFees} ₹',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewDoctorDetails(
                                    doctorId: data.doctorId ?? ''),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text(
                            errorMessage ?? '',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_doctor/API/PatientAPI/SpecialityAPIService.dart';
import 'package:v_doctor/Model/SpecialityModel.dart';
import 'package:v_doctor/Screen/Drawer/PatientDrawer.dart';
import 'package:v_doctor/Screen/View/DoctorSpecialityScreen.dart';
import 'package:v_doctor/utils/colors.dart';

class ViewSpeciality extends StatefulWidget {
  const ViewSpeciality({Key? key}) : super(key: key);

  @override
  State<ViewSpeciality> createState() => _ViewSpecialityState();
}

class _ViewSpecialityState extends State<ViewSpeciality> {
  late double height;
  late double width;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  String specialityText = 'Speciality';
  List<SpecialityData> specialities = [];
  List<SpecialityData> filteredSpecialities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> fetchData() async {
    try {
      List<SpecialityData> fetchedSpecialities =
          await SpecialityAPIService().fetchSpecialities();

      setState(() {
        specialities = fetchedSpecialities;
        filteredSpecialities = specialities;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterSpecialities(String query) {
    List<SpecialityData> filteredList = specialities.where((speciality) {
      return speciality.specialityName!
          .toLowerCase()
          .startsWith(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSpecialities = filteredList;
    });
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        filteredSpecialities = specialities;
      });
    } else {
      filterSpecialities(_searchController.text);
    }

  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _globalKey,
      backgroundColor: ColorConstants.primaryColor,
      drawer: PatientDrawer(),
      body: Column(
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
                    Expanded(
                      child: _showSearch
                          ? TextField(
                              controller: _searchController,
                              autofocus: true,
                              onChanged: filterSpecialities,
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
                              specialityText,
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
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredSpecialities.isEmpty
                      ? Center(
                          child: Text(
                            'No specialities available',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredSpecialities.length,
                          itemBuilder: (context, index) {
                            final speciality = filteredSpecialities[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                  leading: Icon(Icons.medical_services),
                                  title: Text(speciality.specialityName ?? ''),
                                  onTap: () {
                                    Get.to(DoctorSpecialityScreen(
                                      specialityName:
                                          speciality.specialityName ?? '',
                                      specialityId: speciality.sId ?? '',
                                    ));
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

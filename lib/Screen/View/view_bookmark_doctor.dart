import 'package:flutter/material.dart';
import 'package:v_doctor/Screen/Drawer/PatientDrawer.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class ViewBookMarkDoctor extends StatefulWidget {
  const ViewBookMarkDoctor({Key? key}) : super(key: key);

  @override
  State<ViewBookMarkDoctor> createState() => _ViewBookMarkDoctorState();
}

class _ViewBookMarkDoctorState extends State<ViewBookMarkDoctor> {
  late double height;
  late double width;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  String bookmark = 'Bookmark doctors';

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
            padding: EdgeInsets.all(20.0),
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
                              style: TextStyle(color: Colors.black),
                            )
                          : Text(
                              bookmarkText,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // CommonCard(
                    //     profileImageUrl: profileTemp,
                    //     name: "John Doe",
                    //     specialties:
                    //     "Gastrologist,General, Gynecologist , Pediatrician , Homeopathic , Dentist , Orthopaedic",
                    //     experience: "5 years of experience",
                    //     address: "123 Main St, City, HMT",
                    //     price: "600 ₹",
                    //     isBookmarked: true,
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => ViewDoctorDetails(
                    //             profileImageUrl: profileTemp,
                    //             name: "John Doe",
                    //             specialties:
                    //             "Gastrologist , General , Gynecologist , Pediatrician , Homeopathic,Dentist , Orthopeadic",
                    //             experience: "5 years of experience",
                    //             address: "123 Main St, City, HMT",
                    //             price: "600 ₹", mobile: '',
                    //           ),
                    //         ),
                    //       );
                    //     }),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:v_doctor/utils/colors.dart';

class CommonCard extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final String specialties;
  final String experience;
  final String address;
  final String price;
  final VoidCallback? onTap;

  const CommonCard({
    Key? key,
    required this.profileImageUrl,
    required this.name,
    required this.specialties,
    required this.experience,
    required this.address,
    required this.price,
    this.onTap,
  }) : super(key: key);

  @override
  State<CommonCard> createState() => _CommonCardState();
}

class _CommonCardState extends State<CommonCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: Card(
          elevation: 20,
          shadowColor: Colors.black,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.profileImageUrl),
                      radius: 30,
                    ),
                    SizedBox(height: 10),
                    Text(widget.price),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.specialties,
                          style: TextStyle(
                              color: ColorConstants.secondaryTextColor),
                        ),
                        SizedBox(height: 2),
                        Text(
                          widget.experience,
                          style: TextStyle(
                              color: ColorConstants.secondaryTextColor),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.address,
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

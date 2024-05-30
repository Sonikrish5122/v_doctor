import 'package:flutter/material.dart';
import 'package:v_doctor/utils/colors.dart';

class AppointmentDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const AppointmentDetailItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black
            ,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: ColorConstants.LightGray,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

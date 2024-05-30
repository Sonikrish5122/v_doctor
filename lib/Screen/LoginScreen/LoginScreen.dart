// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:v_doctor/Common%20Widget/LogoTitle.dart';
// import 'package:v_doctor/Screen/OTPScreen/OTPScreen.dart';
// import 'package:v_doctor/utils/String.dart';
// import 'package:v_doctor/utils/colors.dart';
//
// class LoginScreen extends StatelessWidget {
//   final String selectedCard;
//
//   const LoginScreen({Key? key, required this.selectedCard}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Column(
//                 children: [
//                   LogoTitle(),
//                   SizedBox(height: 20),
//                   RichText(
//                     text: TextSpan(
//                       style: DefaultTextStyle.of(context)
//                           .style
//                           .copyWith(fontSize: 14),
//                       children: [
//                         TextSpan(
//                           text: continue_as,
//                           style: TextStyle(
//                             color: ColorConstants.secondaryTextColor,
//                             decoration: TextDecoration.none,
//                           ),
//                         ),
//                         TextSpan(
//                           text: ' $selectedCard',
//                           style: TextStyle(
//                             color: ColorConstants.primaryColor,
//                             decoration: TextDecoration.none,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     mobileText,
//                     style: TextStyle(color: ColorConstants.secondaryTextColor),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       vertical: 5,
//                       horizontal: MediaQuery.of(context).size.width * 0.05,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color(0xffeeeeee),
//                           blurRadius: 10,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.black.withOpacity(0.13)),
//                     ),
//                     child: Stack(
//                       children: [
//                         IntlPhoneField(
//                           decoration: InputDecoration(
//                             labelText: "Phone",
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 12.0, vertical: 8.0),
//                           ),
//                           initialCountryCode: 'IN',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: ColorConstants.secondaryAppColor,
//               ),
//               child: IconButton(
//                 onPressed: () {
//                   // Navigate to OTP Screen with selected card information
//                   Get.to(OTPScreen(selectedCard: selectedCard));
//                 },
//                 icon: Icon(Icons.arrow_forward_outlined,
//                     size: MediaQuery.of(context).size.width * 0.06,
//                     color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

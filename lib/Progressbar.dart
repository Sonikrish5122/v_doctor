import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color> valueColor;

  ProgressBar({
    required Key key,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    required this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];

    if (inAsyncCall) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          Center(
            child: CircularProgressIndicator(
              valueColor: valueColor,

            ),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}

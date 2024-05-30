import 'package:flutter/material.dart';
import 'package:v_doctor/Model/GetReportsModel.dart';

class ReportItemWidget extends StatefulWidget {
  final Reports report;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const ReportItemWidget({
    Key? key,
    required this.report,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ReportItemWidgetState createState() => _ReportItemWidgetState();
}

class _ReportItemWidgetState extends State<ReportItemWidget> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.report.reportName ?? ''),
      value: isChecked,
      onChanged: (value) {
        setState(() {
          isChecked = value ?? false;
        });
        widget.onChanged(value);
      },
    );
  }
}

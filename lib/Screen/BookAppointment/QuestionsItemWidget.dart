import 'package:flutter/material.dart';
import 'package:v_doctor/Model/DiagnosisQuestionsModel.dart';

class QuestionItemWidget extends StatefulWidget {
  final List<Questions> questions;
  final Function(int, String)? onTextFieldChanged;
  final Function(int, bool?)? onRadioButtonSelected;

  const QuestionItemWidget({
    Key? key,
    required this.questions,
    this.onTextFieldChanged,
    this.onRadioButtonSelected,
  }) : super(key: key);

  @override
  _QuestionItemWidgetState createState() => _QuestionItemWidgetState();
}

class _QuestionItemWidgetState extends State<QuestionItemWidget> {
  Map<int, bool?> selectedAnswers = {};
  Map<int, String> textFieldData = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.questions.length; i++) {
      selectedAnswers[i] = null;
      textFieldData[i] = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Center(
        child: Text(
          '',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              "Answer some Diagnosis Questions:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.questions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        question.question ?? "",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      if (question.inputType == 'text')
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Answer',
                            border: OutlineInputBorder(),
                            errorText: textFieldData[index]!.isEmpty
                                ? 'Please enter an answer'
                                : null,
                          ),
                          onChanged: (value) {
                            // Invoke callback when text field value changes
                            if (widget.onTextFieldChanged != null) {
                              widget.onTextFieldChanged!(index, value);
                              setState(() {
                                textFieldData[index] = value;
                              });
                            }
                          },
                        ),
                      if (question.inputType == 'radio')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Render radio buttons for Yes/No options
                                Radio<bool>(
                                  value: true,
                                  groupValue: selectedAnswers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswers[index] = value;
                                    });
                                    // Invoke callback when radio button is selected
                                    if (widget.onRadioButtonSelected != null) {
                                      widget.onRadioButtonSelected!(
                                          index, value);
                                    }
                                  },
                                ),
                                Text('Yes'),
                                Radio<bool>(
                                  value: false,
                                  groupValue: selectedAnswers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswers[index] = value;
                                    });
                                    // Invoke callback when radio button is selected
                                    if (widget.onRadioButtonSelected != null) {
                                      widget.onRadioButtonSelected!(
                                          index, value);
                                    }
                                  },
                                ),
                                Text('No'),
                              ],
                            ),
                            if (selectedAnswers[index] == null)
                              Text(
                                'Please select an option',
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

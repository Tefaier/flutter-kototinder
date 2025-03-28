import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/utils/logger.dart';

class InputWithDelete extends StatefulWidget {
  final void Function(String)? onChange;
  final String initText;

  const InputWithDelete({super.key, this.initText = "",  this.onChange});

  @override
  State<StatefulWidget> createState() => _InputWithDeleteState();
}

class _InputWithDeleteState extends State<InputWithDelete> {
  String currentText = "";
  late TextEditingController textController;

  void submitString(String str) {
    logger.info("String of $str was submitted");
    setState(() {
      currentText = str;
    });
    if (widget.onChange != null) {
      widget.onChange!(str);
    }
  }

  @override
  void initState() {
    super.initState();
    currentText = widget.initText;
    textController = TextEditingController(text: currentText);
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textController.value = TextEditingValue(
      text: currentText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: currentText.length),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Expanded(
            child: TextField(
              controller: textController,
              onChanged: submitString,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: currentText == "" ? 'Enter search filter by breed' : null,
          ),
        )),
        TextButton(
            onPressed: () {
              submitString("");
            },
            child: const Text(style: TextStyle(fontSize: 25), "Clear"))
      ],
    );
  }
}

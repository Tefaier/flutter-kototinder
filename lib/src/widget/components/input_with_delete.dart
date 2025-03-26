import 'package:flutter/material.dart';

class InputWithDelete extends StatefulWidget {
  final void Function(String)? onChange;

  const InputWithDelete({super.key, this.onChange});

  @override
  State<StatefulWidget> createState() => _InputWithDeleteState();
}

class _InputWithDeleteState extends State<InputWithDelete> {
  String currentText = "";

  void submitString(String str) {
    setState(() {
      currentText = str;
    });
    if (widget.onChange != null) {
      widget.onChange!(str);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Expanded(
            child: TextField(
              onSubmitted: submitString,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: currentText == "" ? 'Enter search filter by breed' : null,
          ),
        )),
        TextButton(
            onPressed: () {
              submitString("");
            },
            child: const Text("Clear"))
      ],
    );
  }
}

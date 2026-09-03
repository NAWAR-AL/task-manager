import 'package:flutter/material.dart';

class TaskField extends StatelessWidget {
  final TextEditingController fieldController;
  final String fieldLabel;
  TaskField({
    super.key,
    required this.fieldController,
    required this.fieldLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.blueGrey.shade100,
      ),
      child: TextField(
        controller: fieldController,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: fieldLabel,
        ),
      ),
    );
  }
}

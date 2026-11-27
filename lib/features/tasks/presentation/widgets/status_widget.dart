import 'package:flutter/material.dart';

Widget statusDown(String status, Function chooseStatus) {
  return Container(
    padding: const EdgeInsets.only(left: 8, right: 8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: Color(0xffB1E5E6),
    ),
    child: DropdownButtonFormField<String>(
      initialValue: status,
      decoration: const InputDecoration(
        labelText: 'Select Status',
        border: InputBorder.none,
      ),
      hint: Text("Select Status"),
      items: ['todo', 'in_progress', 'review', 'done']
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      onChanged: (value) => chooseStatus(() {
        status = value!;
      }),
    ),
  );
}

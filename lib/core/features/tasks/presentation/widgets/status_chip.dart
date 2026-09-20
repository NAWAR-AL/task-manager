import 'package:flutter/material.dart';

Widget _buildStatusChip(String status) {
  Color color;
  String status = '';
  switch (status.toLowerCase()) {
    case 'completed':
      color = Colors.green;
    case 'in_progress':
      color = Colors.orange;
    case 'done':
      color = Colors.blue;
    default:
      Colors.green;
  }
  return Chip(
    label: Text(status.toUpperCase(), style: TextStyle(color: Colors.white)),
    // backgroundColor: color,
  );
}

import 'package:flutter/material.dart';

Widget buildDetailRow({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Column(
    children: [
      Row(
        children: [
          Icon(icon, size: 20, color: Color(0xffF29191)),

          Text(title, style: TextStyle(fontSize: 15, color: Colors.black)),
          SizedBox(width: 12),
          Text(value, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
      Divider(height: 20, thickness: 2, color: Color(0xffCCFBFA)),
    ],
  );
}

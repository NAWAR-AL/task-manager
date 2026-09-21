import 'package:flutter/material.dart';

Widget buildDetailRow({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xffF29191)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),
        ],
      ),
      const Divider(height: 20, thickness: 2, color: Color(0xffCCFBFA)),
    ],
  );
}
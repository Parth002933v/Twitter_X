import 'package:flutter/material.dart';

IconButton iconButton({
  IconData icon = Icons.ac_unit_outlined,
  required VoidCallback onTap,
}) {
  return IconButton(
    onPressed: onTap,
    icon: Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(icon),
    ),
  );
}

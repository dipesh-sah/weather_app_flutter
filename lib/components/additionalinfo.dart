import 'package:flutter/material.dart';

class Additionalinfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const Additionalinfo(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(
            height: 5,
          ),
          Text(label),
          Text(value)
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HourlyForeCastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForeCastItem(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                maxLines: 1,
                overflow: TextOverflow.fade,
                time,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(temperature)
            ],
          ),
        ),
      ),
    );
  }
}

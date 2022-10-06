import 'package:flutter/material.dart';

class EventButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTab;

  const EventButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}

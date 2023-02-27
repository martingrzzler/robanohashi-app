import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.child,
    required this.color,
  });

  final Widget child;
  final dynamic color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ]),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: child),
    );
  }
}

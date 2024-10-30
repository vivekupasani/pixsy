import 'package:flutter/material.dart';

class BioBox extends StatefulWidget {
  final String bio;

  BioBox({super.key, required this.bio});

  @override
  State<BioBox> createState() => _BioBoxState();
}

class _BioBoxState extends State<BioBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 26.0),
      alignment: Alignment.centerLeft,
      child: Expanded(
        child: Text(
          widget.bio.isNotEmpty ? widget.bio : "Empty bio...",
          style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MySettingsTile extends StatefulWidget {
  final Widget? trailing;
  final Widget? title;
  const MySettingsTile(
      {super.key, required this.title, required this.trailing});

  @override
  State<MySettingsTile> createState() => _MySettingsTileState();
}

class _MySettingsTileState extends State<MySettingsTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(12.0),
        child: ListTile(title: widget.title, trailing: widget.trailing),
      ),
    );
  }
}

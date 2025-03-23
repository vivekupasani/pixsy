import 'package:flutter/material.dart';

class MagicBox extends StatelessWidget {
  final Widget? child;
  final double maxWidth;

  const MagicBox({
    super.key,
    required this.child,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      child: child,
    );
  }
}

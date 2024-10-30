import 'package:flutter/material.dart';

class ScaffoldResponsive extends StatelessWidget {
  final Widget? body;
  final AppBar? appBar;
  final Widget? drawer;
  const ScaffoldResponsive({super.key, this.body,  this.appBar, this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Center(
        child: ConstrainedBox(constraints: const BoxConstraints(
          maxWidth: 430
        ),
        child: body,),
      ),
    );
  }
}
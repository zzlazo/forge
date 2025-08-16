import 'package:flutter/material.dart';

class SharedWidgetTitle extends StatelessWidget {
  const SharedWidgetTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

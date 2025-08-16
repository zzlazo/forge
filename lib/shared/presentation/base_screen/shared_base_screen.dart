import 'package:flutter/material.dart';

import 'shared_app_bar.dart';

class SharedBaseScreen extends StatelessWidget {
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget body;

  const SharedBaseScreen({
    super.key,
    this.title,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? (title == null ? null : SharedAppBar(title: title!)),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}

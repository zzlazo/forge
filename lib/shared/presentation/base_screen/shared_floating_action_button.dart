import 'package:flutter/material.dart';

class SharedFloatingActionButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback? onPressed;
  const SharedFloatingActionButton({
    super.key,
    this.icon,
    this.label,
    required this.onPressed,
  }) : assert(
         icon != null || label != null,
         "Either icon or label must be provided.",
       );

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return FloatingActionButton(onPressed: onPressed, child: Icon(icon));
    } else {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        label: _SharedFloatingActionButtonLabel(label: label!),
      );
    }
  }
}

class _SharedFloatingActionButtonLabel extends StatelessWidget {
  final String label;
  const _SharedFloatingActionButtonLabel({
    // ignore: unused_element_parameter
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(label, style: Theme.of(context).textTheme.titleMedium);
  }
}

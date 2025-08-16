import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const SharedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPop = context.canPop();
    return AppBar(
      title: _SharedAppBarTitle(title: title),
      leading: leading ?? (canPop ? SharedAppBarBackButton() : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SharedAppBarTitle extends StatelessWidget {
  final String title;
  const _SharedAppBarTitle({
    // ignore: unused_element_parameter
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

class SharedAppBarBackButton extends StatelessWidget {
  const SharedAppBarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.pop();
      },
      icon: Icon(Icons.arrow_back),
    );
  }
}

class SharedAppBarSaveButton extends StatelessWidget {
  const SharedAppBarSaveButton({
    // ignore: unused_element_parameter
    super.key,
    required this.onPressed,
  });
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(Icons.check));
  }
}

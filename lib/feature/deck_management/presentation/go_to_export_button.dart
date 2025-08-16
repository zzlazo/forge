import 'package:flutter/material.dart';

import '../../../core/router/router/router.dart';

class GoToExportButton extends StatelessWidget {
  const GoToExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await ExportDeckRoute().push(context);
      },
      icon: Icon(Icons.image),
    );
  }
}

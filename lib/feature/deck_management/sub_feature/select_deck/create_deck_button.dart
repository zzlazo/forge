import 'package:flutter/material.dart';

import '../../../../core/router/router/router.dart';
import '../../../../shared/presentation/base_screen/shared_floating_action_button.dart';

class CreateDeckButton extends StatelessWidget {
  const CreateDeckButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedFloatingActionButton(
      onPressed: () async {
        await CreateDeckRoute().push(context);
      },
      icon: Icons.add,
      label: "Create Deck",
    );
  }
}

import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';

import 'ball_screen.dart';

class IOSARView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ARKitSceneView(
      onARKitViewCreated: (controller) {
        _onARKitViewCreated(controller, context);
      },
    );
  }

  void _onARKitViewCreated(ARKitController controller, BuildContext context) {
    controller.onNodeTap = (nodes) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BallScreen()),
      );
    };
  }
}

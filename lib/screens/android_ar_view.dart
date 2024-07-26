import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';

import 'ball_screen.dart';

class AndroidARView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ArCoreView(
      onArCoreViewCreated: (controller) {
        _onArCoreViewCreated(controller, context);
      },
      enableTapRecognizer: true,
    );
  }

  void _onArCoreViewCreated(ArCoreController controller, BuildContext context) {
    controller.onPlaneTap = (List<ArCoreHitTestResult> hits) {
      print("hits....$hits");
      if (hits.isNotEmpty) {
        final hit = hits.first;
        _addBall(controller, hit);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BallScreen()),
        );
      }
    };
  }

  void _addBall(ArCoreController controller, ArCoreHitTestResult hit) {
    final material = ArCoreMaterial(color: Colors.yellow);
    final sphere = ArCoreSphere(materials: [material], radius: 0.1);
    final node = ArCoreNode(
      shape: sphere,
      position: hit.pose.translation,
      rotation: hit.pose.rotation,
    );
    controller.addArCoreNodeWithAnchor(node);
  }
}

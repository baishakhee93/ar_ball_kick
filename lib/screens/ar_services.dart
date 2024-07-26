import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';

class ARService extends StatefulWidget {
  @override
  _ARServiceState createState() => _ARServiceState();
}

class _ARServiceState extends State<ARService> {
  ArCoreController? arCoreController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
  //  _addBall();
  }

  /*void _addBall() {
    final material = ArCoreMaterial(color: Colors.red);
    final sphere = ArCoreSphere(materials: [material], radius: 0.1);
    final node = ArCoreNode(
      shape: sphere,
      position: ArCoreVector3(0, 0, -1),
    );
    arCoreController?.addArCoreNode(node);
  }*/
}

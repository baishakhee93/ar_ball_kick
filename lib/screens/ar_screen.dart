import 'package:flutter/material.dart';
import 'ar_viewchecker.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'ios_ar_view.dart';

class ArScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR Screen')),
      body: kIsWeb
          ? const Center(child: Text('AR not supported on Web'))
          : (defaultTargetPlatform == TargetPlatform.android
          ? ARViewChecker()
          : IOSARView()),
    );
  }
}


import 'package:ar_ball_kick/leg_detector.dart';
import 'package:ar_ball_kick/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  //runApp(MyApp(cameras: cameras));
  runApp(
      ChangeNotifierProvider(
          create: (_)=> LegDetector(),
          child: MyApp(cameras: cameras)
      )

  );
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  MyApp({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(cameras: cameras),
    );
  }
}

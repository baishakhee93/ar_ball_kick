
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../leg_detector.dart';
import 'ar_screen.dart';

/*class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      _controller = CameraController(widget.cameras[0], ResolutionPreset.high);
      await _controller.initialize();
      setState(() {});
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Camera Feed')),
      body: CameraPreview(_controller),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArScreen()),
          );
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}*/


import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';

import 'ball_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isDetecting = false;
  late List<CameraDescription> _cameras;
  int _cameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _cameras = widget.cameras;
    _initializeCamera();
    Provider.of<LegDetector>(context, listen: false).addListener(_onLegDetected);
  }

  Future<void> _initializeCamera() async {

    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      _controller = CameraController(widget.cameras[0], ResolutionPreset.high);
      await _controller.initialize();
      setState(() {
        try {

          // _controller.initialize();
          if (!mounted) return;

          _controller.startImageStream((CameraImage image) {
            if (_isDetecting) return;
            _isDetecting = true;
            _processCameraImage(image);
          });

          setState(() {});
        } catch (e) {
          print("Error initializing camera: $e");
        }
      });
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission denied')),
      );
    }



  }
  Future<void> _processCameraImage(CameraImage image) async {
    final legDetector = Provider.of<LegDetector>(context, listen: false);
    final inputImage = _convertCameraImage(image);

    if (inputImage != null) {
      try {
        print("Starting pose detection...");
        final result = await legDetector.detectPose(inputImage);
        print("Pose detection result: ");
         bool isLegDetected=true;//dummy value
       // if (isLegDetected) {
       if (legDetector.isLegDetected) {
          print("Leg detected! Navigating to BallScreen.");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BallScreen()),
          );
          legDetector.resetDetection(); // Reset detection to avoid multiple navigations
        } else {
          print("Leg not detected.");
        }
      } catch (e) {
        print("Error during pose detection: $e");
      }
    } else {
      print("Failed to convert camera image.");
    }

    _isDetecting = false;
  }


  InputImage? _convertCameraImage(CameraImage image) {
    if (_cameras.isEmpty) return null;

    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      final deviceOrientation = _controller.value.deviceOrientation;
      final rotationCompensation = _orientations[deviceOrientation];
      if (rotationCompensation == null) return null;
      final adjustedRotation = camera.lensDirection == CameraLensDirection.front
          ? (sensorOrientation + rotationCompensation) % 360
          : (sensorOrientation - rotationCompensation + 360) % 360;
      rotation = InputImageRotationValue.fromRawValue(adjustedRotation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null || format != InputImageFormat.yuv_420_888) {
      print("Unsupported image format: ${image.format.raw}");
      return null;
    }

    if (image.planes.length != 3) {
      print("Unexpected number of planes: ${image.planes.length}");
      return null;
    }

    final nv21Bytes = convertYuv420888ToNv21(image);

    return InputImage.fromBytes(
      bytes: nv21Bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }


  void _onLegDetected() {
    final legDetector = Provider.of<LegDetector>(context, listen: false);

    if (legDetector.isLegDetected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BallScreen()),
      );
      legDetector.resetDetection(); // Reset detection to avoid multiple navigations
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('Camera Feed')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Camera Feed')),
      body: CameraPreview(_controller),
    );
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  Uint8List convertYuv420888ToNv21(CameraImage image) {
    final planeY = image.planes[0];
    final planeU = image.planes[1];
    final planeV = image.planes[2];

    final ySize = planeY.bytes.length;
    final uvSize = planeU.bytes.length + planeV.bytes.length;

    final nv21Bytes = Uint8List(ySize + uvSize);

    // Copy Y plane
    nv21Bytes.setRange(0, ySize, planeY.bytes);

    // Copy UV plane
    final uvBytes = Uint8List(uvSize);
    final uBytes = planeU.bytes;
    final vBytes = planeV.bytes;

    for (int i = 0; i < uBytes.length; i++) {
      uvBytes[i * 2] = vBytes[i];
      uvBytes[i * 2 + 1] = uBytes[i];
    }

    nv21Bytes.setRange(ySize, ySize + uvSize, uvBytes);

    return nv21Bytes;
  }
}


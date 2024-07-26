import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class LegDetector with ChangeNotifier {
  bool _isLegDetected = false;
  bool get isLegDetected => _isLegDetected;

  final poseDetector = GoogleMlKit.vision.poseDetector();

  Future<void> detectPose(InputImage inputImage) async {
    print("Starting pose detection...");
    final poses = await poseDetector.processImage(inputImage);
    print("Number of detected poses: ${poses.length}");

    if (poses.isEmpty) {
      print("No poses detected.");
    }

    bool legDetected = false;
    for (Pose pose in poses) {
      print("Detected ${poses.length} poses");

      for (PoseLandmark landmark in pose.landmarks.values) {
        print("PoseLandmark ${landmark.type} ");

        if (landmark.type == PoseLandmarkType.leftKnee || landmark.type == PoseLandmarkType.rightKnee) {
          legDetected = true;
          print("landmark ${legDetected} ");

          break;
        }
      }
      if (legDetected) break;
    }

    if (_isLegDetected != legDetected) {
      _isLegDetected = legDetected;
      notifyListeners();
    }
  }
  void detectLeg() {
    _isLegDetected = true;
    notifyListeners();
  }
  void resetDetection() {
    if (_isLegDetected) {
      _isLegDetected = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    poseDetector.close();
    super.dispose();
  }
}


/*
class LegDetector with ChangeNotifier {
  bool _isLegDetected = false;
  bool get isLegDetected => _isLegDetected;

  final poseDetector = GoogleMlKit.vision.poseDetector();

  Future<void> detectPose(InputImage inputImage) async {
    print("Starting pose detection...");

    try {
      final poses = await poseDetector.processImage(inputImage);
      print("Detected ${poses.length} poses");

      bool legDetected = false;

      for (Pose pose in poses) {
        print("Processing pose: $pose");
        print("Pose landmarks: ${pose.landmarks.values}");

        for (PoseLandmark landmark in pose.landmarks.values) {
          print("Landmark: ${landmark.type}");

          if (landmark.type == PoseLandmarkType.leftKnee ||
              landmark.type == PoseLandmarkType.rightKnee) {
            legDetected = true;
            break;
          }
        }

        if (legDetected) break;
      }

      _isLegDetected = legDetected;
      notifyListeners();
      print("Leg detected: $_isLegDetected");
    } catch (e) {
      print("Error during pose detection: $e");
      _isLegDetected = false;
      notifyListeners();
    }
  }

  void resetDetection() {
    _isLegDetected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    poseDetector.close();
    super.dispose();
  }
}
*/

/*
class LegDetector with ChangeNotifier {
  bool _isLegDetected = false;
  bool get isLegDetected => _isLegDetected;

  final poseDetector = GoogleMlKit.vision.poseDetector();

  Future<void> detectPose(InputImage inputImage) async {
    print("LegDetector..............$inputImage");
    final poses = await poseDetector.processImage(inputImage);
    for (Pose pose in poses) {
      print("LegDetector......pose........$pose");
      print("LegDetector......pose..values......${pose.landmarks.values}");

      for (PoseLandmark landmark in pose.landmarks.values) {
        print("LegDetector......landmark........${landmark.type}");

        if (landmark.type == PoseLandmarkType.leftKnee ||
            landmark.type == PoseLandmarkType.rightKnee) {
          _isLegDetected = true;
          notifyListeners();
          return;
        }
      }
    }
    _isLegDetected = false;
    notifyListeners();
  }

  void resetDetection() {
    _isLegDetected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    poseDetector.close();
    super.dispose();
  }
}
*/

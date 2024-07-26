// Widget to check AR services on Android
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'android_ar_view.dart';

class ARViewChecker extends StatelessWidget {
  static const platform = MethodChannel('com.baishakhee.ar_ball_kick/arcore');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _checkARServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to check AR services: ${snapshot.error}'));
        } else if (snapshot.data == 'SUPPORTED_INSTALLED') {
          return AndroidARView();
        } else if (snapshot.data == 'NEEDS_UPDATE') {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('AR services need to be updated.'),
                ElevatedButton(
                  onPressed: _launchGooglePlayServicesAR,
                  child: Text('Update AR Services'),
                ),
              ],
            ),
          );
        } else if (snapshot.data == 'UNSUPPORTED_DEVICE_NOT_CAPABLE') {
          return Center(child: Text('This device does not support AR'));
        } else {
          return Center(child: Text('AR services are not available or up to date.'));
        }
      },
    );
  }
  Future<String> _checkARServices() async {
    try {
      final String result = await platform.invokeMethod('checkArCoreAvailability');
      return result;
    } catch (e) {
      print("Failed to check ARCore availability: $e");
      return 'ERROR';
    }
  }

  void _launchGooglePlayServicesAR() async {
    const url = 'https://play.google.com/store/apps/details?id=com.google.ar.core';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  /*@override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _checkARServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to check AR services: ${snapshot.error}'));
        } else if (snapshot.data == 'SUPPORTED') {
          return AndroidARView();
        } else if (snapshot.data == 'UNSUPPORTED_DEVICE_NOT_CAPABLE') {
          return Center(child: Text('This device does not support AR'));
        } else {
          return Center(child: Text('AR services are not available or up to date.'));
        }
      },
    );
  }

  Future<String> _checkARServices() async {
    try {
      final String result = await platform.invokeMethod('checkArCoreAvailability');
      return result;
    } catch (e) {
      print("Failed to check ARCore availability: $e");
      return 'ERROR';
    }
  }*/
}


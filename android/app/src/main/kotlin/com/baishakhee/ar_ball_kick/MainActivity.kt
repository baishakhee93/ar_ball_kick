package com.baishakhee.ar_ball_kick

//import io.flutter.embedding.android.FlutterActivity

//class MainActivity: FlutterActivity()


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.ar.core.ArCoreApk
class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.baishakhee.ar_ball_kick/arcore"
   /* override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable AR-related functionality on ARCore supported devices only.
        maybeEnableArButton()

    }*/

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "checkArCoreAvailability") {
                checkArCoreAvailability(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun checkArCoreAvailability(result: MethodChannel.Result) {
        val availability = ArCoreApk.getInstance().checkAvailability(this)
        when (availability) {
            ArCoreApk.Availability.SUPPORTED_INSTALLED -> {
                result.success("SUPPORTED_INSTALLED")
            }
            ArCoreApk.Availability.SUPPORTED_APK_TOO_OLD,
            ArCoreApk.Availability.SUPPORTED_NOT_INSTALLED -> {
                result.success("NEEDS_UPDATE")
            }
            ArCoreApk.Availability.UNSUPPORTED_DEVICE_NOT_CAPABLE -> {
                result.success("UNSUPPORTED_DEVICE_NOT_CAPABLE")
            }
            else -> {
                result.success("UNKNOWN")
            }
        }
    }
    /*fun maybeEnableArButton() {
        ArCoreApk.getInstance().checkAvailabilityAsync(this) { availability ->
            if (availability.isSupported) {
                mArButton.visibility = View.VISIBLE
                mArButton.isEnabled = true
            } else { // The device is unsupported or unknown.
                mArButton.visibility = View.INVISIBLE
                mArButton.isEnabled = false
            }
        }
    }*/
}

/*class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.baishakhee.ar_ball_kick/arcore"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "checkArCoreAvailability") {
                val availability = ArCoreApk.getInstance().checkAvailability(this)
                if (availability.isTransient) {
                    // Wait for the availability to settle down.
                    Thread {
                        while (availability.isTransient) {
                            Thread.sleep(200)
                        }
                        checkAvailability(result)
                    }.start()
                } else {
                    checkAvailability(result)
                }
            } else {
                result.notImplemented()
            }
        }
    }
  *//*  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "checkArCoreAvailability") {
                val availability = ArCoreApk.getInstance().checkAvailability(this)
                if (availability.isTransient) {
                    // Wait for the availability to settle down.
                    Thread {
                        while (availability.isTransient) {
                            Thread.sleep(200)
                        }
                        checkAvailability(result)
                    }.start()
                } else {
                    checkAvailability(result)
                }
            } else {
                result.notImplemented()
            }
        }
    }*//*
    private fun checkAvailability(result: MethodChannel.Result) {
        val availability = ArCoreApk.getInstance().checkAvailability(this)
        result.success(availability.name) // Send the availability status to Flutter
    }
 *//*   private fun checkAvailability(result: MethodChannel.Result) {
        val availability = ArCoreApk.getInstance().checkAvailability(this)
        if (availability.isSupported) {
            result.success(true)
        } else {
            result.success(false)
        }
    }*//*
}*/

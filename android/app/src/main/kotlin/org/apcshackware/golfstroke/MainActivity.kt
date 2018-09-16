/**
 * Wear OS Ambient Mode interop portions are based on code written by Matt Sullivan.
 * https://medium.com/@mjohnsullivan/experimenting-with-flutter-on-wear-os-f789d843f2ef
 */
package org.apcshackware.golfstroke

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

import android.support.wear.ambient.AmbientMode

import org.apcshackware.golfstroke.FlutterAmbientCallback

class MainActivity: FlutterActivity(), AmbientMode.AmbientCallbackProvider {
  private var mAmbientController: AmbientMode.AmbientController? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    // Set the Flutter ambient callbacks
    mAmbientController = AmbientMode.attachAmbientSupport(this)
  }

  override fun getAmbientCallback(): AmbientMode.AmbientCallback {
    return FlutterAmbientCallback(getWearChannel(flutterView))
  }
}

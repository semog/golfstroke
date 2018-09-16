/**
 * Based on code written by Matt Sullivan.
 * https://medium.com/@mjohnsullivan/experimenting-with-flutter-on-wear-os-f789d843f2ef
 */
package org.apcshackware.golfstroke

import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterView

import android.os.Bundle

import android.support.wear.ambient.AmbientMode.AmbientCallback

private const val WEAR_CHANNEL_NAME = "wear"

fun getWearChannel(view: FlutterView): MethodChannel {
    return MethodChannel(view, WEAR_CHANNEL_NAME)
}

/*
 * Pass ambient callback back to Flutter
 */
class FlutterAmbientCallback(private val channel: MethodChannel) : AmbientCallback() {
    override fun onEnterAmbient(ambientDetails: Bundle) {
        channel.invokeMethod("enter", null)
        super.onEnterAmbient(ambientDetails)
    }

    override fun onExitAmbient() {
        channel.invokeMethod("exit", null)
        super.onExitAmbient()
    }

    override fun onUpdateAmbient() {
        channel.invokeMethod("update", null)
        super.onUpdateAmbient()
    }
}

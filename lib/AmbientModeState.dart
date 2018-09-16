import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

const MethodChannel _channel = const MethodChannel('wear');

/// Update the state when the ambient mode changes.
abstract class AmbientModeState<T extends StatefulWidget> extends State<T> {
  var isAmbient = false;
  var _stayOnAmbient = false;

  AmbientModeState();
  AmbientModeState.stayOnAmbient() {
    this._stayOnAmbient = true;
  }

  @virtual
  void onEnterAmbient() {
    if (_stayOnAmbient) {
      setState(() => isAmbient = true);
    } else {
      SystemNavigator.pop();
    }
  }

  @virtual
  void updateAmbient() {
    setState(() => isAmbient = true);
  }

  @virtual
  void onExitAmbient() {
    setState(() => isAmbient = false);
  }

  @override
  initState() {
    super.initState();

    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case 'enter':
          onEnterAmbient();
          break;
        case 'update':
          updateAmbient();
          break;
        case 'exit':
          onExitAmbient();
          break;
      }
    });
  }
}

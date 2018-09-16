/**
 * Based on code written by Matt Sullivan.
 * https://medium.com/@mjohnsullivan/experimenting-with-flutter-on-wear-os-f789d843f2ef
 */
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

const MethodChannel _channel = const MethodChannel('wear');

/// Builds a child for AmbientModeBuilder
typedef Widget AmbientModeWidgetBuilder(
  BuildContext context,
  bool isAmbient,
);

/// Widget that listens for when a Wear device enters full power or ambient mode,
/// and provides this in a builder. It optionally takes an update function that's
/// called every time the watch triggers an ambient update request. If an update
/// function is passed in, this widget will not perform an update itself.
class AmbientModeWidget extends StatefulWidget {
  AmbientModeWidget({Key key, @required this.builder, this.update})
      : assert(builder != null),
        super(key: key);
  final AmbientModeWidgetBuilder builder;
  final Function update;

  @override
  createState() => _AmbientModeState();
}

class _AmbientModeState extends State<AmbientModeWidget> {
  var isAmbient = false;

  @override
  initState() {
    super.initState();

    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case 'enter':
          setState(() => isAmbient = true);
          break;
        case 'update':
          if (widget.update != null) {
            widget.update();
          } else {
            setState(() => isAmbient = true);
          }
          break;
        case 'exit':
          setState(() => isAmbient = false);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, isAmbient);
}

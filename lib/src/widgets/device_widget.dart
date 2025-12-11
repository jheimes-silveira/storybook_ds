import 'package:flutter/material.dart';

/// Constants for device widget styling
class _DeviceWidgetConstants {
  static const double borderRadius = 8.0;
  static const double borderWidth = 4.0;
}

/// A widget that displays a component within a device frame.
class DeviceWidget extends StatefulWidget {
  final Widget Function(BuildContext context) buildComponentWidget;
  final EdgeInsets? margin;

  final double width;
  final double height;

  const DeviceWidget({
    super.key,
    required this.buildComponentWidget,
    this.margin,
    required this.width,
    required this.height,
  });

  @override
  State<DeviceWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          _DeviceWidgetConstants.borderRadius,
        ),
        border: Border.all(
          width: _DeviceWidgetConstants.borderWidth,
          color: Colors.black,
        ),
      ),
      child: widget.buildComponentWidget(context),
    );
  }
}

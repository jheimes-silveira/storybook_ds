import 'package:flutter/material.dart';

class DeviceWidget extends StatefulWidget {
  final Widget Function(BuildContext context) buildComponentWidget;
  final EdgeInsets? margin;

  final double width;
  final double height;

  const DeviceWidget({
    Key? key,
    required this.buildComponentWidget,
    this.margin,
    required this.width,
    required this.height,
  }) : super(key: key);

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
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 4,
          color: Colors.black,
        ),
      ),
      child: widget.buildComponentWidget(context),
    );
  }
}

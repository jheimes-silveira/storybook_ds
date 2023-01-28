import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeviceWidget extends StatefulWidget {
  final Widget Function(BuildContext context) buildComponentWidget;
  final EdgeInsets? margin;
  final Decoration? decoration;
  final double width;
  final double height;

  const DeviceWidget({
    Key? key,
    required this.buildComponentWidget,
    this.margin,
    this.decoration,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<DeviceWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return SizedBox(
        width: widget.width,
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 5,
                  ),
                ),
                margin: const EdgeInsets.all(16.0),
                child: widget.buildComponentWidget(context),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration,
      child: widget.buildComponentWidget(context),
    );
  }
}

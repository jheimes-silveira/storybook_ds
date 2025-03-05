
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:storybook_ds/src/device_preview/views/theme.dart';

import '../model/tools_panel_model.dart';
import '../state/store.dart';
import 'tool_panel/tool_panel.dart';

/// The tool layout when the screen is large.
class DevicePreviewLargeLayout extends StatefulWidget {
  const DevicePreviewLargeLayout({
    super.key,
    required this.tools,
    required this.isRight,
  });

  final ToolsPanelModel tools;
  final bool isRight;
  @override
  DevicePreviewLargeLayoutState createState() =>
      DevicePreviewLargeLayoutState();
}

class DevicePreviewLargeLayoutState extends State<DevicePreviewLargeLayout> {
  @override
  void initState() {
    // Forcing rebuild to update absolute postion in `_overlayKey`
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => setState(() {}),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final toolbarTheme = context.select(
      (DevicePreviewStore store) => store.settings.toolbarTheme,
    );
    return Theme(
      data: toolbarTheme.asThemeData(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Localizations(
          locale: const Locale('en', 'US'),
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: widget.isRight ? 0 : null,
                left: !widget.isRight ? 0 : null,
                bottom: 0,
                width: widget.tools.panelWidth,
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    padding: mediaQuery.padding.copyWith(left: 0) +
                         EdgeInsets.only(left: widget.isRight ? 40 : 0),
                  ),
                  child: Navigator(
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(
                          builder: (context) => ToolPanel(
                            slivers: widget.tools.tools,
                            isRight: widget.isRight,
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

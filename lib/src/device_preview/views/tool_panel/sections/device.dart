import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_ds/src/device_preview/views/tool_panel/widgets/target_platform_icon.dart';

import '../../../state/store.dart';
import '../widgets/device_type_icon.dart';
import 'section.dart';
import 'subsections/device_model.dart';

/// All the simulated properties for the device.
class DeviceSection extends StatelessWidget {
  /// Create a new menu section with simulated device properties.
  ///
  /// The items can be hidden with [model], [orientation], [frameVisibility],
  /// [virtualKeyboard] parameters.
  const DeviceSection({
    super.key,
    this.model = true,
    this.orientation = true,
    this.frameVisibility = true,
    this.virtualKeyboard = true,
    this.devicePreview = true,
  });

  /// Allow to edit the current simulated model.
  final bool model;

  /// Allow to edit the current simulated device orientation.
  final bool orientation;

  /// Allow to hide or show the device frame.
  final bool frameVisibility;

  /// Allow to show or hide a software keyboard mockup.
  final bool virtualKeyboard;

  /// Allow to show or hide the device preview.
  final bool devicePreview;

  @override
  Widget build(BuildContext context) {
    final deviceName = context.select(
      (DevicePreviewStore store) => store.deviceInfo.name,
    );
    final deviceIdentifier = context.select(
      (DevicePreviewStore store) => store.deviceInfo.identifier,
    );

    final canRotate = context.select(
      (DevicePreviewStore store) => store.deviceInfo.rotatedSafeAreas != null,
    );

    final orientation = context.select(
      (DevicePreviewStore store) => store.data.orientation,
    );

    final isVirtualKeyboardVisible = context.select(
      (DevicePreviewStore store) => store.data.isVirtualKeyboardVisible,
    );

    final isFrameVisible = context.select(
      (DevicePreviewStore store) => store.data.isFrameVisible,
    );

    final isEnabled = context.select(
      (DevicePreviewStore store) => store.data.isEnabled,
    );

    return ToolPanelSection(
      title: 'Device',
      children: [
        if (devicePreview)
          ListTile(
            key: const Key('devicePreview'),
            title: const Text('Device preview'),
            subtitle: Text(isEnabled ? 'Visible' : 'Hidden'),
            trailing: Opacity(
              opacity: isEnabled ? 1.0 : 0.3,
              child: const Icon(
                Icons.devices,
              ),
            ),
            onTap: () {
              final state = context.read<DevicePreviewStore>();
              state.data = state.data.copyWith(
                isEnabled: !isEnabled,
              );
            },
          ),
        if (model)
          ListTile(
            key: const Key('model'),
            title: const Text('Model'),
            subtitle: Text(deviceName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TargetPlatformIcon(
                  platform: deviceIdentifier.platform,
                ),
                const SizedBox(
                  width: 8,
                ),
                DeviceTypeIcon(
                  type: deviceIdentifier.type,
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
            onTap: () {
              final theme = Theme.of(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Theme(
                    data: theme,
                    child: const DeviceModelPicker(),
                  ),
                ),
              );
            },
          ),
        if (this.orientation && canRotate)
          ListTile(
            key: const Key('orientation'),
            title: const Text('Orientation'),
            subtitle: Text(
              orientation == Orientation.landscape ? 'Landscape' : 'Portrait',
            ),
            trailing: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transformAlignment: Alignment.center,
              transform: Matrix4.rotationZ(
                orientation == Orientation.landscape ? 2.35 : 0.75,
              ),
              child: const Icon(Icons.screen_rotation),
            ),
            onTap: () {
              final state = context.read<DevicePreviewStore>();
              state.rotate();
            },
          ),
        if (frameVisibility)
          ListTile(
            key: const Key('frame'),
            title: const Text('Frame visibility'),
            subtitle: Text(isFrameVisible ? 'Visible' : 'Hidden'),
            trailing: Opacity(
              opacity: isFrameVisible ? 1.0 : 0.3,
              child: Icon(
                isFrameVisible
                    ? Icons.border_outer_rounded
                    : Icons.border_clear_rounded,
              ),
            ),
            onTap: () {
              final state = context.read<DevicePreviewStore>();
              state.toggleFrame();
            },
          ),
        if (virtualKeyboard)
          ListTile(
            key: const Key('keyboard'),
            title: const Text('Virtual keyboard preview'),
            subtitle: Text(isVirtualKeyboardVisible ? 'Visible' : 'Hidden'),
            trailing: Opacity(
              opacity: isVirtualKeyboardVisible ? 1.0 : 0.3,
              child: Icon(
                isVirtualKeyboardVisible
                    ? Icons.keyboard
                    : Icons.keyboard_outlined,
              ),
            ),
            onTap: () {
              final state = context.read<DevicePreviewStore>();
              state.toggleVirtualKeyboard();
            },
          ),
      ],
    );
  }
}

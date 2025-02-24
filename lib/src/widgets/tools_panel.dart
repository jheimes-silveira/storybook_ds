import 'package:collection/collection.dart';
import 'package:device_frame/device_frame.dart';
import 'package:device_preview/src/state/store.dart';
import 'package:device_preview/src/views/tool_panel/widgets/device_type_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A page for picking a simulated device model.
class ToolsPanel extends StatefulWidget {
  /// Create a new page for picking a simulated device model.
  const ToolsPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<ToolsPanel> createState() => _ToolsPanelState();
}

class _ToolsPanelState extends State<ToolsPanel>
    with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(
    vsync: this,
    length: 2,
    initialIndex: 0,
  );

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device model'),
        bottom: TabBar(
          controller: controller,
          isScrollable: true,
          tabs: [
            Tab(
              icon: Icon(Icons.deblur),
              text: 'Custom 1',
            ),
            Tab(
              icon: Icon(Icons.tune),
              text: 'Custom',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ..._allPlatforms.map(
            (e) => _PlatformModelPicker(
              platform: e,
            ),
          ),
          CustomScrollView(
            slivers: [
              ListTile(title: Text('Test1 ')),
              ListTile(title: Text('Test1 ')),
              ListTile(title: Text('Test1 ')),
              ListTile(title: Text('Test1 ')),
              ListTile(title: Text('Test1 ')),
              ListTile(title: Text('Test1 ')),
              ListTile(title: Text('Test1 ')),
              ListTile(title: Text('Test1 ')),
              ListTile(title: Text('Test1 ')),
              // ...buildCustomDeviceTiles(context),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlatformModelPicker extends StatelessWidget {
  const _PlatformModelPicker({
    Key? key,
    required this.platform,
  }) : super(key: key);

  final TargetPlatform platform;

  @override
  Widget build(BuildContext context) {
    final devices = context.select(
      (DevicePreviewStore store) => store.devices
          .where(
            (x) => platform == x.identifier.platform,
          )
          .toList()
        ..sort((x, y) {
          final result = x.screenSize.width.compareTo(y.screenSize.width);
          return result == 0
              ? x.screenSize.height.compareTo(y.screenSize.height)
              : result;
        }),
    );
    final byDeviceType =
        groupBy<DeviceInfo, DeviceType>(devices, (d) => d.identifier.type);
    return ListView(
      children: [
        ...byDeviceType.entries
            .map(
              (e) => [
                _TypeSectionHeader(
                  type: e.key,
                ),
                ...e.value.map(
                  (d) => DeviceTile(
                    info: d,
                  ),
                ),
              ],
            )
            .expand((x) => x),
      ],
    );
  }
}

class _TypeSectionHeader extends StatelessWidget {
  _TypeSectionHeader({
    required this.type,
  }) : super(key: ValueKey(type));

  final DeviceType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 30, top: 30, bottom: 16),
      child: Text(
        () {
          switch (type) {
            case DeviceType.tablet:
              return 'Tablet';
            case DeviceType.desktop:
              return 'Desktop';
            case DeviceType.tv:
              return 'TV';
            case DeviceType.laptop:
              return 'Laptop';
            default:
              return 'Phone';
          }
        }()
            .toUpperCase(),
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.hintColor,
        ),
      ),
    );
  }
}

class DeviceTile extends StatelessWidget {
  const DeviceTile({
    Key? key,
    required this.info,
  }) : super(key: key);

  final DeviceInfo info;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(info.name),
      leading: DeviceTypeIcon(type: info.identifier.type),
      subtitle: Text(
        '${info.screenSize.width}x${info.screenSize.height} @${info.pixelRatio}',
        style: const TextStyle(
          fontSize: 10,
        ),
      ),
      onTap: () {
        final state = context.read<DevicePreviewStore>();
        state.selectDevice(info.identifier);
      },
    );
  }
}

const _allPlatforms = <TargetPlatform>[
  TargetPlatform.iOS,
  TargetPlatform.android,
  TargetPlatform.macOS,
  TargetPlatform.windows,
  TargetPlatform.linux,
];

const _allDeviceTypes = <DeviceType>[
  DeviceType.phone,
  DeviceType.tablet,
  DeviceType.desktop,
  DeviceType.laptop,
];

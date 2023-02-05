import 'package:flutter/material.dart';

import 'ds_dropdown_controller.dart';

class DSDropdownContainer extends StatefulWidget {
  final Widget child;
  final String? text;
  final String hintText;
  final double buttonHeight;
  final InputBorder enabledBorder;
  final InputBorder focusedBorder;
  final InputBorder disabledBorder;

  final DSDropdownController? controller;
  final BoxConstraints? constraints;
  final String? error;
  final String? label;

  const DSDropdownContainer({
    Key? key,
    required this.child,
    this.text,
    this.hintText = '',
    this.buttonHeight = 40,
    this.enabledBorder = InputBorder.none,
    this.focusedBorder = InputBorder.none,
    this.disabledBorder = InputBorder.none,
    this.controller,
    this.constraints,
    this.error,
    this.label,
  }) : super(key: key);

  @override
  State<DSDropdownContainer> createState() => _DSDropdownContainerState();
}

class _DSDropdownContainerState extends State<DSDropdownContainer>
    with TickerProviderStateMixin {
  late GlobalKey _actionKey;
  late OverlayEntry _floatingDropdown;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  late DSDropdownController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();

    _actionKey = LabeledGlobalKey(widget.text);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));

    _controller = widget.controller ?? DSDropdownController();

    _error = widget.error ?? _controller.error;

    _controller.addListener(
      () {
        if (_controller.error != _error) {
          setState(() {
            _error = _controller.error;
          });
        }

        if (_controller.isOpened) {
          _animationController.forward();
          setState(() {
            _floatingDropdown = _createFloatingDropdown();
            Overlay.of(context).insert(_floatingDropdown);
          });
        } else {
          _animationController.reverse().then(
                (_) => setState(() {
                  _floatingDropdown.remove();
                }),
              );
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant DSDropdownContainer oldWidget) {
    if (widget.error != oldWidget.error) {
      setState(() {
        _error = widget.error;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _WidgetInfo _getDropdownInfo() {
    final navigator = Navigator.of(context);
    final navigatorObject = navigator.context.findRenderObject();
    final itemBox = context.findRenderObject()! as RenderBox;

    final offset = itemBox.localToGlobal(
      Offset.zero,
      ancestor: navigatorObject,
    );

    return _WidgetInfo(offset: offset, size: itemBox.size);
  }

  OverlayEntry _createFloatingDropdown() {
    final parentInfo = _getDropdownInfo();

    return OverlayEntry(builder: (context) {
      return Stack(
        children: [
          GestureDetector(
            onTap: () => _controller.isOpened = false,
            behavior: HitTestBehavior.opaque,
          ),
          Container(
            width: parentInfo.size.width,
            margin: EdgeInsets.only(
              top: parentInfo.offset.dy + parentInfo.size.height,
              left: parentInfo.offset.dx,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SizeTransition(
              sizeFactor: _expandAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SingleChildScrollView(child: widget.child),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _actionKey,
      onTap: () => _controller.isOpened = true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null && widget.label!.isNotEmpty)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.constraints?.maxWidth ?? 360,
              ),
              child: Text(
                widget.label!,
              ),
            ),
          ConstrainedBox(
            constraints: widget.constraints ??
                BoxConstraints(
                  maxWidth: 360,
                  maxHeight: widget.buttonHeight,
                ),
            child: InputDecorator(
              decoration: InputDecoration(
                enabledBorder: widget.enabledBorder,
                disabledBorder: widget.disabledBorder,
                focusedBorder: widget.focusedBorder,
                contentPadding: EdgeInsets.zero,
                suffixIcon: RotationTransition(
                  turns: _rotateAnimation,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                  ),
                ),
              ),
              isFocused: _controller.isOpened,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  widget.text ?? widget.hintText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.4,
                        fontSize: 14,
                      ),
                ),
              ),
            ),
          ),
          if (_error != null && _error!.isNotEmpty)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.constraints?.maxWidth ?? 360,
              ),
              child: Text(
                _error!,
              ),
            ),
        ],
      ),
    );
  }
}

class _WidgetInfo {
  final Offset offset;
  final Size size;

  _WidgetInfo({
    required this.offset,
    required this.size,
  });
}

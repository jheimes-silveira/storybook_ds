import 'package:flutter/material.dart';

enum _TypeButton {
  elevated,
  text,
  outline,
}

class CustomButton extends StatefulWidget {
  final _TypeButton _type;
  final String text;
  final bool loading;
  final Function() onPressed;
  final Color? color;

  final double? borderRadius;
  const CustomButton._raw(
    this._type, {
    required this.text,
    required this.onPressed,
    required this.loading,
    required this.color,
    required this.borderRadius,
  });

  factory CustomButton.elevated({
    required String text,
    required Function() onPressed,
    bool loading = false,
    Color? color,
    double? borderRadius,
  }) {
    return CustomButton._raw(
      _TypeButton.elevated,
      text: text,
      onPressed: onPressed,
      loading: loading,
      color: color,
      borderRadius: borderRadius,
    );
  }
  factory CustomButton.text({
    required String text,
    required Function() onPressed,
    bool loading = false,
    Color? textColor,
  }) {
    return CustomButton._raw(
      _TypeButton.text,
      text: text,
      onPressed: onPressed,
      loading: loading,
      color: textColor,
      borderRadius: null,
    );
  }
  factory CustomButton.outline({
    required String text,
    required Function() onPressed,
    bool loading = false,
    Color? borderSideColor,
    double? borderRadius,
  }) {
    return CustomButton._raw(
      _TypeButton.outline,
      text: text,
      onPressed: onPressed,
      loading: loading,
      color: borderSideColor,
      borderRadius: borderRadius,
    );
  }

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    if (_TypeButton.elevated == widget._type) {
      return _buildElevated();
    }
    if (_TypeButton.outline == widget._type) {
      return _buildOutline();
    }
    return _buildText();
  }

  Widget _buildElevated() {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
        ),
      ),
      child: _buildChild(Theme.of(context).colorScheme.inversePrimary),
    );
  }

  Widget _buildOutline() {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
        ),
        side: widget.color == null ? null : BorderSide(color: widget.color!),
      ),
      child: _buildChild(widget.color ??Theme.of(context).colorScheme.primary),
    );
  }

  Widget _buildText() {
    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: widget.color),
        foregroundColor: widget.color,
      ),
      child: _buildChild(widget.color ?? Theme.of(context).colorScheme.primary),
    );
  }

  Stack _buildChild(Color loadingColor) {
    return Stack(
      children: [
        Positioned.fill(
          bottom: 0,
          top: 0,
          right: 0,
          left: 0,
          child: Opacity(
            opacity: widget.loading ? 1 : 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    color: loadingColor,
                    strokeWidth: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        Opacity(
          opacity: widget.loading ? 0 : 1,
          child: Text(widget.text),
        ),
      ],
    );
  }
}

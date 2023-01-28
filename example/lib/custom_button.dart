import 'package:flutter/material.dart';

enum _CustomTypeButton {
  contained,
  text,
  outline,
}

class CustomButton extends StatefulWidget {
  final _CustomTypeButton _type;
  final String text;
  final bool loading;
  final Function() onPressed;

  const CustomButton._raw(
    this._type, {
    required this.text,
    required this.onPressed,
    required this.loading,
  });

  factory CustomButton.contained({
    required String text,
    required Function() onPressed,
    bool loading = false,
  }) {
    return CustomButton._raw(
      _CustomTypeButton.contained,
      text: text,
      onPressed: onPressed,
      loading: loading,
    );
  }
  factory CustomButton.text({
    required String text,
    required Function() onPressed,
    bool loading = false,
  }) {
    return CustomButton._raw(
      _CustomTypeButton.text,
      text: text,
      onPressed: onPressed,
      loading: loading,
    );
  }
  factory CustomButton.outline({
    required String text,
    required Function() onPressed,
    bool loading = false,
  }) {
    return CustomButton._raw(
      _CustomTypeButton.outline,
      text: text,
      onPressed: onPressed,
      loading: loading,
    );
  }

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    if (_CustomTypeButton.contained == widget._type) {
      return _buildContained();
    }
    if (_CustomTypeButton.outline == widget._type) {
      return _buildOutline();
    }
    return _buildText();
  }

  Widget _buildContained() {
    return ElevatedButton(
      onPressed: widget.onPressed,
      child: _buildChild(Theme.of(context).colorScheme.inversePrimary),
    );
  }

  Widget _buildOutline() {
    return OutlinedButton(
      onPressed: widget.onPressed,
      child: _buildChild(Theme.of(context).colorScheme.primary),
    );
  }

  Widget _buildText() {
    return TextButton(
      onPressed: widget.onPressed,
      child: _buildChild(Theme.of(context).colorScheme.primary),
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

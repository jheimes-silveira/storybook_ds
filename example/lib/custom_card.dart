import 'package:flutter/material.dart';

extension EStyleCustomCard on StyleCustomCard {
  Color? get color {
    if (this == StyleCustomCard.inline) {
      return Colors.white;
    }

    return Colors.grey;
  }

  Color? get textColor {
    if (this == StyleCustomCard.inline) {
      return Colors.black;
    }

    return Colors.white;
  }

  BoxBorder? get border {
    if (this == StyleCustomCard.inline) {
      return Border.all(
        color: Colors.grey[500]!,
        width: 1,
      );
    }
    return null;
  }
}

enum StyleCustomCard {
  outline,
  inline,
}

class CustomCard extends StatefulWidget {
  final String title;
  final String? description;

  final StyleCustomCard style;

  final Function()? onPositive;
  final Function()? onNegative;
  final String? textPositive;
  final String? textNegative;
  final double? width;
  final double? height;

  const CustomCard({
    required this.title,
    this.description,
    this.style = StyleCustomCard.outline,
    this.onPositive,
    this.onNegative,
    this.textPositive,
    this.textNegative,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  factory CustomCard.outline({
    required String title,
    final String? description,
    final String? tag,
    final Function()? onPositive,
    final Function()? onNegative,
    final String? textPositive,
    final String? textNegative,
    final double? width,
    final double? height,
  }) {
    return CustomCard(
      title: title,
      style: StyleCustomCard.outline,
      description: description,
      onPositive: onPositive,
      onNegative: onNegative,
      textPositive: textPositive,
      textNegative: textNegative,
      width: width,
      height: height,
    );
  }
  factory CustomCard.inline({
    required String title,
    final String? description,
    final String? tag,
    final Function()? onPositive,
    final Function()? onNegative,
    final String? textPositive,
    final String? textNegative,
    final double? width,
    final double? height,
  }) {
    return CustomCard(
      title: title,
      style: StyleCustomCard.inline,
      description: description,
      onPositive: onPositive,
      onNegative: onNegative,
      textPositive: textPositive,
      textNegative: textNegative,
      width: width,
      height: height,
    );
  }

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
         
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            if (widget.description != null && widget.height != null)
              Expanded(child: _buildDescription()),
            if (widget.description != null && widget.height == null)
              _buildDescription(),
            _buildButtonAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        widget.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: widget.style.textColor,
            ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        widget.description!,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: widget.style.textColor,
            ),
      ),
    );
  }

  Widget _buildButtonAction() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (widget.onNegative != null)
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onNegative,
                child: Text(widget.textNegative ?? 'Fechar'),
              ),
            ),
          if (widget.onNegative != null && widget.onPositive != null)
            const SizedBox(width: 16),
          if (widget.onPositive != null)
            Expanded(
              child: ElevatedButton(
                onPressed: widget.onPositive,
                child: Text(widget.textPositive ?? 'Continuar'),
              ),
            ),
        ],
      ),
    );
  }
}

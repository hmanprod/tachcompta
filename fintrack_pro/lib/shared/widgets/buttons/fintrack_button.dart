import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

enum FinTrackButtonType {
  primary,
  secondary,
  danger,
}

class FinTrackButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FinTrackButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const FinTrackButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = FinTrackButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getTextColor(),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(),
      foregroundColor: _getTextColor(),
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: type == FinTrackButtonType.secondary
            ? BorderSide(color: FinTrackColors.primary, width: 1.5)
            : BorderSide.none,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return _getHoverColor().withOpacity(0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return _getPressedColor().withOpacity(0.2);
          }
          return null;
        },
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case FinTrackButtonType.primary:
        return FinTrackColors.primary;
      case FinTrackButtonType.secondary:
        return Colors.transparent;
      case FinTrackButtonType.danger:
        return FinTrackColors.error;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case FinTrackButtonType.primary:
      case FinTrackButtonType.danger:
        return Colors.white;
      case FinTrackButtonType.secondary:
        return FinTrackColors.primary;
    }
  }

  Color _getHoverColor() {
    switch (type) {
      case FinTrackButtonType.primary:
        return FinTrackColors.secondary;
      case FinTrackButtonType.secondary:
        return FinTrackColors.light;
      case FinTrackButtonType.danger:
        return FinTrackColors.error.withOpacity(0.8);
    }
  }

  Color _getPressedColor() {
    switch (type) {
      case FinTrackButtonType.primary:
        return FinTrackColors.secondary.withOpacity(0.8);
      case FinTrackButtonType.secondary:
        return FinTrackColors.light.withOpacity(0.8);
      case FinTrackButtonType.danger:
        return FinTrackColors.error.withOpacity(0.8);
    }
  }
}
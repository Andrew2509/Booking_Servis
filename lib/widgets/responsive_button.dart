import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final Widget? child;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const ResponsiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.child,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? ResponsiveHelper.getResponsiveHeight(context, 50),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.black,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          padding:
              padding ??
              EdgeInsets.symmetric(
                vertical: ResponsiveHelper.getResponsivePaddingValue(
                  context,
                  15,
                ),
                horizontal: ResponsiveHelper.getResponsivePaddingValue(
                  context,
                  20,
                ),
              ),
        ),
        child:
            isLoading
                ? SizedBox(
                  height: ResponsiveHelper.getResponsiveFontSize(context, 20),
                  width: ResponsiveHelper.getResponsiveFontSize(context, 20),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? Colors.white,
                    ),
                  ),
                )
                : child ??
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              16,
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.getResponsivePaddingValue(
                              context,
                              8,
                            ),
                          ),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              14,
                            ),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CreatoDisplay',
                          ),
                        ),
                      ],
                    ),
      ),
    );
  }
}

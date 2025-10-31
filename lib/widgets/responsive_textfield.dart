import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class ResponsiveTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final int? maxLines;
  final double? height;

  const ResponsiveTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? ResponsiveHelper.getResponsiveHeight(context, 50),
      width: double.infinity,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        maxLines: maxLines,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 10),
            fontWeight: FontWeight.w800,
            color: Colors.grey[400],
            fontFamily: 'CreatoDisplay',
          ),
          prefixIcon:
              prefixIcon != null
                  ? Icon(
                    prefixIcon,
                    color: Colors.grey[600],
                    size: ResponsiveHelper.getResponsiveFontSize(context, 14),
                  )
                  : null,
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.getResponsivePaddingValue(context, 15),
            horizontal: ResponsiveHelper.getResponsivePaddingValue(context, 12),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }
}

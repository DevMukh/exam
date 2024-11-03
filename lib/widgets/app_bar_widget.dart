import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLeadingPressed;
  final Widget? leadingIcon;
  final Color? backgroundColor;
  final Color? titleColor;

  const AppBarWidget({
    super.key,
    required this.title,
    this.onLeadingPressed,
    this.leadingIcon,
    this.backgroundColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      title: Text(
        title,
        style: TextStyle(
            color: titleColor ?? Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: leadingIcon ??
          IconButton(
            icon: Icon(Icons.arrow_back, color: titleColor ?? Colors.black),
            onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
          ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Default AppBar height
}

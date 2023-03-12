import 'package:flutter/material.dart';
import 'package:robanohashi/app_bar.dart';

class DeviceSizes {
  static const mobile = 900.0;
  static const tablet = 1200.0;
  static const desktop = 1600.0;
}

class Layout extends StatelessWidget {
  const Layout({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width < DeviceSizes.mobile
        ? 0.0
        : width < DeviceSizes.tablet
            ? 120.0
            : 320.0;

    if (width < DeviceSizes.mobile) {
      return Scaffold(
        appBar: CustomAppBar(
          padding: padding,
        ),
        body: Container(child: child),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        padding: padding,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: child,
      ),
    );
  }
}

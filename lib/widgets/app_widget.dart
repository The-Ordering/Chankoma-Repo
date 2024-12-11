import 'dart:ui';

import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget  implements PreferredSize{
  Widget appbar;
  AppWidget({super.key , required this.appbar});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        color: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30) ,
        child: appbar,
        ),
      ),
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => AppBar().preferredSize;

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}

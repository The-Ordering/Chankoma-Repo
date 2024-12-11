import 'package:elegant_spring_animation/elegant_spring_animation.dart';
import 'package:flutter/material.dart';

class RightToLeftRoute extends PageRouteBuilder {
  final Widget page;

  RightToLeftRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Start from the right
            const end = Offset.zero; // End at the center
            var curve = Easing.emphasizedDecelerate; // Smooth transition

            var tween = Tween(
                begin: begin, end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}


class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
            parent: animation, curve: Curves.easeOutSine),
        child: child,
      );
    },
    opaque: false, // This makes the previous screen visible
  );
}


import 'dart:async';

import 'package:flutter/material.dart';

class Donkey extends StatefulWidget {
  const Donkey({super.key});

  @override
  State<Donkey> createState() => _DonkeyState();
}

class _DonkeyState extends State<Donkey> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _eyesAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _scaleController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _eyesAnimation = Tween(begin: -.3, end: .4).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween(begin: 1.0, end: 1.1).animate(_scaleController);

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTapDown: (details) {
            _scaleController.forward();
          },
          onTapUp: (details) {
            _scaleController.reverse();
          },
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            child: Image.asset(
              'assets/images/eyeless-donkey.png',
              width: 200,
              height: 200,
            ),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
          ),
        ),
        Positioned(
          top: 68,
          child: AnimatedBuilder(
              animation: _eyesAnimation,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: 11,
                    height: 11,
                    decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle)),
                const SizedBox(width: 25),
                Container(
                    width: 11,
                    height: 11,
                    decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle)),
              ]),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_eyesAnimation.value * 20,
                      0), // Move the eyes horizontally
                  child: child,
                );
              }),
        )
      ],
    );
  }
}

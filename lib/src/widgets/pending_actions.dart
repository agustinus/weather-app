import 'package:flutter/material.dart';
import 'dart:math';

class PendingAction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PendingActionState();
}

class PendingActionState extends State<PendingAction>
    with TickerProviderStateMixin {
  AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
        vsync: this, duration: Duration(seconds: 2), upperBound: pi * 2);
    rotationController.forward();
    rotationController.addListener(() {
      setState(() {
        if (rotationController.status == AnimationStatus.completed) {
          rotationController.repeat();
        }
      });
    });
  }

  @override
  void dispose() {
    rotationController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: AnimatedBuilder(
            animation: rotationController,
            child: Image.asset('assets/ic_loading.png'),
            builder: (BuildContext context, Widget _widget) {
              return new Transform.rotate(
                angle: rotationController.value,
                child: _widget,
              );
            },
          ),
        ),
      ],
    );
  }
}

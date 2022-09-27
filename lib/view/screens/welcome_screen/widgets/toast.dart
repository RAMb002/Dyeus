import 'package:dyeus/view/css/css.dart';
import 'package:dyeus/view_model/provider/authenticiation_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyToast extends StatelessWidget {
  const MyToast({
    Key? key,
    required AnimationController animationController,
    required this.width,
  })  : _animationController = animationController,
        super(key: key);

  final AnimationController _animationController;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 45,
      child: Consumer<AuthenticationMessageProvider>(
        builder: (context, message, child) => IgnorePointer(
          child: FadeTransition(
            opacity: _animationController,
            child: Container(
              constraints: BoxConstraints(maxWidth: width - 40),
              // margin: EdgeInsets.all(100),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              // width: width - 40,
              // height: 40,
              // color: Colors.red,
              decoration: BoxDecoration(borderRadius: lBorderRadius, color: Colors.grey.shade800),
              child: Text(
                message.message,
                softWrap: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

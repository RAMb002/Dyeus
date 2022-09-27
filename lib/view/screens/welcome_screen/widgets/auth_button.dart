import 'package:dyeus/view/css/css.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
  super.key,
  required this.color,
  required this.text,
  required this.iconVisibility,
  required this.secondaryText,
  required this.onTap,
  this.textColor = Colors.black,
  this.fontSize = 14.0,
  this.icon = const Icon(Icons.arrow_forward_ios_rounded,

  )

  });

  final String text;
  final Color color;
  final Widget icon;
  final bool iconVisibility;
  final Color textColor;
  final double fontSize;
  final String secondaryText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      child: InkWell(
        splashColor: Colors.white10,
        borderRadius:const BorderRadius.all(Radius.circular(30)),
        onTap: onTap,
        child: Ink(
          height: 48,
          width:screenWidth,
          decoration: BoxDecoration(
            color: color ,
            border: Border.all(color: iconVisibility ? borderColor : Colors.transparent,width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(40)),

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                  visible: iconVisibility,
                  child: icon),
              Visibility(
                  visible: iconVisibility,
                  child: const SizedBox(width: 7,)),
              RichText(
                text: TextSpan(
                  text: text,
                  style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500
                  ),
                  children:  <TextSpan>[
                    TextSpan(text:secondaryText, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

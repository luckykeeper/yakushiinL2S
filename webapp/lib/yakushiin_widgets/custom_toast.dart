// YakushiinL2S. Convert Dual Language Lrc To Srt For YakushiinPlayer. (webapp)
// @CreateTime    : 2025/06/17 14:10
// @Author        : Luckykeeper
// @Email         : luckykeeper@luckykeeper.site
// @Project       : YakushiinL2S(webapp)

import 'dart:math';

import 'package:flutter/material.dart';
import '../theme/font.dart';

class CustomToast extends StatelessWidget {
  const CustomToast(this.msg, {super.key, this.toastIcon});

  final String msg;
  final IconData? toastIcon;

  @override
  Widget build(BuildContext context) {
    IconData thisIcon = Icons.done_rounded;
    if (toastIcon != null) {
      thisIcon = toastIcon!;
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: _randomColor(),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: Icon(thisIcon, color: _randomColor()),
            ),
            Text(msg, style: styleFontLxwk),
          ],
        ),
      ),
    );
  }

  Color _randomColor() {
    return Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1,
    );
  }
}

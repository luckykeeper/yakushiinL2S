// YakushiinL2S. Convert Dual Language Lrc To Srt For YakushiinPlayer. (webapp)
// @CreateTime    : 2025/06/17 14:10
// @Author        : Luckykeeper
// @Email         : luckykeeper@luckykeeper.site
// @Project       : YakushiinL2S(webapp)

import 'package:flutter/material.dart';
import 'package:webapp/theme/font.dart';

Future<dynamic> commonSuccessDialog(
  BuildContext context,
  String titleText,
  String contentText,
  String acknowledgeText, {
  Function? interactiveFunction,
  String customImageAssetsLocation = "assets/images/operationSuccessYuuka.jpg",
  double customImageWidth = 200,
  Widget? customContent,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(titleText, style: styleFontLxwk),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    if (customImageAssetsLocation.length > 1) {
                      return Image.asset(
                        customImageAssetsLocation,
                        width: customImageWidth,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
            Builder(
              builder: (context) {
                if (customContent == null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(contentText, style: styleFontLxwk)],
                  );
                } else {
                  return customContent;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (interactiveFunction == null) {
                Navigator.of(context).pop();
              } else {
                interactiveFunction();
              }
            },
            child: Text(acknowledgeText, style: styleFontLxwk),
          ),
        ],
      );
    },
  );
}

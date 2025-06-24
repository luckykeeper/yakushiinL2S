// YakushiinL2S. Convert Dual Language Lrc To Srt For YakushiinPlayer. (webapp)
// @CreateTime    : 2025/06/17 17:58
// @Author        : Luckykeeper
// @Email         : luckykeeper@luckykeeper.site
// @Project       : YakushiinL2S(webapp)

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CodeBoxText with ChangeNotifier {
  String? current;
}

final lrcCodeBoxRef = ChangeNotifierProvider<CodeBoxText>((ref) {
  return CodeBoxText();
});

final srtCodeBoxRef = ChangeNotifierProvider<CodeBoxText>((ref) {
  return CodeBoxText();
});

// YakushiinL2S. Convert Dual Language Lrc To Srt For YakushiinPlayer. (webapp)
// @CreateTime    : 2025/06/18 17:31
// @Author        : Luckykeeper
// @Email         : luckykeeper@luckykeeper.site
// @Project       : YakushiinL2S(webapp)

import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlWithBrowser(String url) async {
  Uri parsedUrl = Uri.parse(url);
  if (!await launchUrl(parsedUrl)) {
    throw Exception('Could not launch $url');
  }
}

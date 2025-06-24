// YakushiinL2S. Convert Dual Language Lrc To Srt For YakushiinPlayer. (webapp)
// @CreateTime    : 2025/06/18 11:20
// @Author        : Luckykeeper
// @Email         : luckykeeper@luckykeeper.site
// @Project       : YakushiinL2S(webapp)

class LrcToSrtServerReturn {
  String? targetSrtContent;
  int? statusCode;
  String? statusMessage;
  bool isSuccess = false;

  LrcToSrtServerReturn({
    this.targetSrtContent,
    this.statusCode,
    this.statusMessage,
  });

  LrcToSrtServerReturn.fromJson(Map<String, dynamic> json) {
    targetSrtContent = json['targetSrtContent'];
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['targetSrtContent'] = targetSrtContent;
    data['statusCode'] = statusCode;
    data['statusMessage'] = statusMessage;
    return data;
  }
}

class LrcToSrtAppRequest {
  int? startLine;
  bool? mergeNearestDuration;
  bool? mergeSameDuration;
  bool? persevereOnlyFirstLanguage;
  bool? persevereOnlySecondLanguage;
  String? originLrc;

  LrcToSrtAppRequest({
    this.startLine,
    this.mergeNearestDuration,
    this.mergeSameDuration,
    this.persevereOnlyFirstLanguage,
    this.persevereOnlySecondLanguage,
    this.originLrc,
  });

  LrcToSrtAppRequest.fromJson(Map<String, dynamic> json) {
    startLine = json['startLine'];
    mergeNearestDuration = json['mergeNearestDuration'];
    mergeSameDuration = json['mergeSameDuration'];
    persevereOnlyFirstLanguage = json['persevereOnlyFirstLanguage'];
    persevereOnlySecondLanguage = json['persevereOnlySecondLanguage'];
    originLrc = json['originLrc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startLine'] = startLine;
    data['mergeNearestDuration'] = mergeNearestDuration;
    data['mergeSameDuration'] = mergeSameDuration;
    data['persevereOnlyFirstLanguage'] = persevereOnlyFirstLanguage;
    data['persevereOnlySecondLanguage'] = persevereOnlySecondLanguage;
    data['originLrc'] = originLrc;
    return data;
  }
}

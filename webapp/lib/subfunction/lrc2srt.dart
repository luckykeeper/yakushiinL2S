import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:webapp/model/lrc_to_srt_app_exchange.dart';

Future<LrcToSrtServerReturn> lrc2srt(LrcToSrtAppRequest request) async {
  LrcToSrtServerReturn serverReturn = LrcToSrtServerReturn();
  try {
    final yuukaRequestClient = Dio();
    var response = await yuukaRequestClient.post<String>(
      "/api/v1/lrcToSrt",
      data: request.toJson(),
      options: Options(
        headers: {HttpHeaders.userAgentHeader: "YakushiinL2S By Luckykeeper"},
      ),
    );
    if (response.statusCode.toString().isNotEmpty) {
      serverReturn = LrcToSrtServerReturn.fromJson(jsonDecode(response.data!));
      if (response.statusCode == 200) {
        serverReturn.isSuccess = true;
        serverReturn.statusMessage = "✅请求成功！后端返回:${serverReturn.statusMessage}";
        return serverReturn;
      } else {
        serverReturn.isSuccess = false;
        serverReturn.statusMessage =
            "⛔请求出错！后端状态码:${serverReturn.statusCode} | 后端返回信息:${serverReturn.statusMessage}";
        return serverReturn;
      }
    } else {
      serverReturn.isSuccess = false;
      serverReturn.statusMessage = "⛔请求后端出错或超时，请检查后端运行情况";
      return serverReturn;
    }
  } catch (e) {
    serverReturn.isSuccess = false;
    serverReturn.statusMessage = "⛔请求后端异常！诊断信息:$e";
    return serverReturn;
  }
}

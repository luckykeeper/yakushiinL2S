// YakushiinL2S. Convert Dual Language Lrc To Srt For YakushiinPlayer. (webapp)
// @CreateTime    : 2025/06/17 14:25
// @Author        : Luckykeeper
// @Email         : luckykeeper@luckykeeper.site
// @Project       : YakushiinL2S(webapp)

import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:html' as html;
import 'package:webapp/model/code_box_text_ref.dart';
import 'package:webapp/model/lrc_to_srt_app_exchange.dart';
import 'package:webapp/subfunction/launch_url.dart';
import 'package:webapp/subfunction/lrc2srt.dart';
import 'package:webapp/theme/font.dart';
import 'package:webapp/yakushiin_widgets/code_editor/custom_code_box.dart';
import 'package:webapp/yakushiin_widgets/commin_question_dialog.dart';

class L2sAppPage extends ConsumerStatefulWidget {
  const L2sAppPage({super.key});

  @override
  ConsumerState<L2sAppPage> createState() => _L2sAppPageState();
}

class _L2sAppPageState extends ConsumerState<L2sAppPage> {
  bool persevereBothLanguage = true;
  bool persevereOnlyFirstLanguage = false;
  bool persevereOnlySecondLanguage = false;

  bool mergeNearestDuration = true;
  bool mergeSameDuration = false;
  bool doNotMerge = false;
  final TextEditingController _fileNameEditingController =
      TextEditingController();

  final TextEditingController _startLineEditingController =
      TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _startLineEditingController.text = "0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size scrSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("YakushiinL2S By Luckykeeper", style: styleFontLxwkBold),
            const Expanded(child: Text("")),
          ],
        ),
        backgroundColor: Colors.cyan,
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "双语 LRC 转换为 SRT ヾ(≧▽≦*)o",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: fontLxwkFontFamily,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    message: "打开项目 Github",
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await launchUrlWithBrowser(
                            "https://github.com/luckykeeper/yakushiinL2S",
                          );
                        } catch (e) {
                          BotToast.showSimpleNotification(
                            duration: const Duration(seconds: 2),
                            hideCloseButton: false,
                            backgroundColor: Colors.pink[300],
                            title: "链接打开失败:$e",
                            titleStyle: styleFontLxwk,
                          );
                        }
                      },
                      label: Text("Github", style: styleFontLxwk),
                      icon: const FaIcon(FontAwesomeIcons.github),
                    ),
                  ),
                  Tooltip(
                    message: "切换到日间模式",
                    child: IconButton(
                      onPressed: () => AdaptiveTheme.of(context).setLight(),
                      icon: const Icon(Icons.light_mode_rounded),
                    ),
                  ),
                  Tooltip(
                    message: "切换到夜间模式",
                    child: IconButton(
                      onPressed: () => AdaptiveTheme.of(context).setDark(),
                      icon: const Icon(Icons.dark_mode_rounded),
                    ),
                  ),
                  Tooltip(
                    message: "主题跟随系统",
                    child: IconButton(
                      onPressed: () => AdaptiveTheme.of(context).setSystem(),
                      icon: const Icon(Icons.brightness_auto_rounded),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("使用说明：", style: styleFontLxwk),
                Text("\t\t1、上传 LRC 文件或粘贴 LRC 文件的内容（双语）", style: styleFontLxwk),
                Text(
                  "\t\t2、根据需要，输入双语歌词的开头行号（LRC 歌词开头有编曲、歌手等情况）",
                  style: styleFontLxwk,
                ),
                Text("\t\t3、选择需要保留的语种", style: styleFontLxwk),
                Text("\t\t4、当选择【保留双语】时，选择时间轴合并方式", style: styleFontLxwk),
                Text("\t\t5、点击【在线转换】等待服务器返回转换好的结果", style: styleFontLxwk),
                Container(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: styleFontLxwk,
                        controller: _startLineEditingController,
                        decoration: InputDecoration(
                          labelText: "双语歌词起始行号",
                          labelStyle: styleFontLxwk,
                          hintText: "输入双语歌词从第几行开始",
                          hintStyle: styleFontLxwk,
                          errorStyle: styleFontLxwk,
                          icon: const Icon(Icons.start_rounded),
                        ),
                        validator: (value) {
                          try {
                            int.parse(value!);
                            return null;
                          } catch (e) {
                            return "输入必须是行号数字";
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "双语歌词处理方式：",
                          style: TextStyle(
                            fontFamily: fontLxwkFontFamily,
                            color: Colors.cyan,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.language_rounded),
                        Text("保留双语（默认）", style: styleFontLxwk),
                        Switch(
                          value: persevereBothLanguage,
                          onChanged: (value) {
                            persevereBothLanguage = true;
                            persevereOnlyFirstLanguage = false;
                            persevereOnlySecondLanguage = false;
                            mergeNearestDuration = true;
                            mergeSameDuration = false;
                            doNotMerge = false;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.looks_one_rounded),
                        Text("只保留第一种语言", style: styleFontLxwk),
                        Switch(
                          value: persevereOnlyFirstLanguage,
                          onChanged: (value) {
                            persevereBothLanguage = false;
                            persevereOnlyFirstLanguage = true;
                            persevereOnlySecondLanguage = false;
                            mergeNearestDuration = false;
                            mergeSameDuration = false;
                            doNotMerge = true;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.looks_two_rounded),
                        Text("只保留第二种语言", style: styleFontLxwk),
                        Switch(
                          value: persevereOnlySecondLanguage,
                          onChanged: (value) {
                            persevereBothLanguage = false;
                            persevereOnlyFirstLanguage = false;
                            persevereOnlySecondLanguage = true;
                            mergeNearestDuration = false;
                            mergeSameDuration = false;
                            doNotMerge = true;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Container(height: 10),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "时间轴处理方式：",
                          style: TextStyle(
                            fontFamily: fontLxwkFontFamily,
                            color: Colors.cyan,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.merge_rounded),
                        Text("合并相邻的时间轴（默认）", style: styleFontLxwk),
                        Switch(
                          value: mergeNearestDuration,
                          onChanged: (value) {
                            persevereBothLanguage = true;
                            persevereOnlyFirstLanguage = false;
                            persevereOnlySecondLanguage = false;
                            mergeNearestDuration = true;
                            mergeSameDuration = false;
                            doNotMerge = false;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer_rounded),
                        Text("合并完全相同的时间轴", style: styleFontLxwk),
                        Switch(
                          value: mergeSameDuration,
                          onChanged: (value) {
                            persevereBothLanguage = true;
                            persevereOnlyFirstLanguage = false;
                            persevereOnlySecondLanguage = false;
                            mergeNearestDuration = false;
                            mergeSameDuration = true;
                            doNotMerge = false;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.fork_left_rounded),
                        Text(
                          "不要合并（lrc 转 srt 标准通用转换模式，和其他网站的转换方式一致）",
                          style: styleFontLxwk,
                        ),
                        Switch(
                          value: doNotMerge,
                          onChanged: (value) {
                            mergeNearestDuration = false;
                            mergeSameDuration = false;
                            doNotMerge = true;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Container(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Tips: web 端，FilePicker 和 SmartDialog 冲突，不要在一起使用
                        FilePickerResult? lrcUploadResult = await FilePicker
                            .platform
                            .pickFiles(
                              dialogTitle: "请选择要转换的双语 LRC 歌词文件",
                              allowedExtensions: ["lrc"],
                              type: FileType.custom,
                              allowMultiple: false,
                            );
                        if (lrcUploadResult != null) {
                          try {
                            _fileNameEditingController.text = lrcUploadResult
                                .files[0]
                                .name
                                .split(".")[0];
                            String lrcContent = utf8.decode(
                              lrcUploadResult.files[0].bytes!,
                            );
                            TextEditingController thisController =
                                TextEditingController();
                            thisController.text = lrcContent;
                            commonQuestionDialog(
                              context,
                              "解析成功",
                              [
                                Text("解析结果如下：", style: styleFontLxwk),
                                Text(
                                  "确认解析结果无误，可点击右下【复制并关闭弹窗】，并将内容复制到 lrc 解析区",
                                  style: styleFontLxwk,
                                ),
                                Divider(),
                                TextField(
                                  maxLines: 10,
                                  controller: thisController,
                                  style: styleFontLxwk,
                                ),
                              ],
                              "取消",
                              "复制并关闭弹窗",
                              makeDialogScrollView: true,
                              interactiveFunction: () async {
                                try {
                                  await Clipboard.setData(
                                    ClipboardData(text: lrcContent),
                                  );
                                  BotToast.showSimpleNotification(
                                    duration: const Duration(seconds: 1),
                                    hideCloseButton: false,
                                    backgroundColor: Colors.green[300],
                                    title: "✅复制成功",
                                    titleStyle: styleFontLxwk,
                                  );
                                } catch (e) {
                                  BotToast.showSimpleNotification(
                                    duration: const Duration(seconds: 1),
                                    hideCloseButton: false,
                                    backgroundColor: Colors.green[300],
                                    title: "⛔复制失败:$e",
                                    titleStyle: styleFontLxwk,
                                  );
                                }
                              },
                            );
                          } catch (e) {
                            BotToast.showSimpleNotification(
                              duration: const Duration(seconds: 2),
                              hideCloseButton: false,
                              backgroundColor: Colors.pink[300],
                              title: "⛔上传失败：$e",
                              titleStyle: styleFontLxwk,
                            );
                          }
                        } else {
                          BotToast.showSimpleNotification(
                            duration: const Duration(seconds: 2),
                            hideCloseButton: false,
                            backgroundColor: Colors.pink[300],
                            title: "⛔上传失败：未选择文件",
                            titleStyle: styleFontLxwk,
                          );
                        }
                      },
                      label: Text("上传 lrc 文件", style: styleFontLxwk),
                      icon: Icon(Icons.upload_file_rounded),
                    ),
                    Container(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if ((_formKey.currentState as FormState).validate()) {
                          var startLine = int.tryParse(
                            _startLineEditingController.text,
                          );
                          LrcToSrtAppRequest appRequest = LrcToSrtAppRequest(
                            startLine: startLine,
                            mergeNearestDuration: mergeNearestDuration,
                            mergeSameDuration: mergeSameDuration,
                            persevereOnlyFirstLanguage:
                                persevereOnlyFirstLanguage,
                            persevereOnlySecondLanguage:
                                persevereOnlySecondLanguage,
                            originLrc: "${ref.watch(lrcCodeBoxRef).current}",
                          );
                          var result = await lrc2srt(appRequest);
                          if (result.isSuccess) {
                            TextEditingController thisController =
                                TextEditingController();
                            thisController.text = "${result.targetSrtContent}";
                            commonQuestionDialog(
                              context,
                              "转换成功",
                              [
                                Text("转换结果如下：", style: styleFontLxwk),
                                Text(
                                  "确认解析结果无误，可点击右下【复制、下载并关闭弹窗】，下载结果",
                                  style: styleFontLxwk,
                                ),
                                TextFormField(
                                  style: styleFontLxwk,
                                  controller: _fileNameEditingController,
                                  decoration: InputDecoration(
                                    labelText: "文件名",
                                    labelStyle: styleFontLxwk,
                                    hintText: "输入要下载的文件名，不需要输入文件扩展名【.srt】",
                                    hintStyle: styleFontLxwk,
                                    errorStyle: styleFontLxwk,
                                    icon: const Icon(Icons.file_open_rounded),
                                  ),
                                ),
                                Divider(),
                                TextField(
                                  maxLines: 10,
                                  controller: thisController,
                                  style: styleFontLxwk,
                                ),
                              ],
                              "取消",
                              "复制、下载并关闭弹窗",
                              makeDialogScrollView: true,
                              interactiveFunction: () async {
                                try {
                                  await Clipboard.setData(
                                    ClipboardData(
                                      text: "${result.targetSrtContent}",
                                    ),
                                  );
                                } catch (e) {
                                  BotToast.showSimpleNotification(
                                    duration: const Duration(seconds: 1),
                                    hideCloseButton: false,
                                    backgroundColor: Colors.green[300],
                                    title: "⛔复制失败:$e",
                                    titleStyle: styleFontLxwk,
                                  );
                                }
                                var blob = html.Blob(
                                  ["${result.targetSrtContent}"],
                                  'text/plain',
                                  'native',
                                );
                                html.AnchorElement(
                                    href: html.Url.createObjectUrlFromBlob(
                                      blob,
                                    ).toString(),
                                  )
                                  ..setAttribute(
                                    "download",
                                    "${_fileNameEditingController.text}.srt",
                                  )
                                  ..click();
                              },
                            );
                            BotToast.showSimpleNotification(
                              duration: const Duration(seconds: 1),
                              hideCloseButton: false,
                              backgroundColor: Colors.green[300],
                              title: "✅转换成功",
                              titleStyle: styleFontLxwk,
                            );
                          } else {
                            BotToast.showSimpleNotification(
                              duration: const Duration(seconds: 2),
                              hideCloseButton: false,
                              backgroundColor: Colors.pink[300],
                              title: "⛔转换失败:${result.statusMessage}",
                              titleStyle: styleFontLxwk,
                            );
                          }
                        } else {
                          BotToast.showSimpleNotification(
                            duration: const Duration(seconds: 2),
                            hideCloseButton: false,
                            backgroundColor: Colors.pink[300],
                            title: "⛔表单填写有误请检查",
                            titleStyle: styleFontLxwk,
                          );
                        }
                      },
                      label: Text("开始转换", style: styleFontLxwk),
                      icon: Icon(Icons.play_arrow_rounded),
                    ),
                  ],
                ),
                Container(height: 10),
                Divider(),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("lrc 编辑区", style: styleFontLxwk),
                    // Text("srt 编辑区", style: styleFontLxwk),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: scrSize.width - 100,
                      child: CustomCodeBox(
                        language: "lrc",
                        theme: "vs2015",
                        initialText: "",
                        ref: ref,
                        editorMode: "lrc",
                      ),
                    ),
                    // Container(width: 50),
                    // SizedBox(
                    //   width: scrSize.width / 2 - 100,
                    //   child: CustomCodeBox(
                    //     language: "srt",
                    //     theme: "vs2015",
                    //     initialText: "",
                    //     ref: ref,
                    //     editorMode: "srt",
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// YakushiinL2S. Convert Dual Language Lrc To Srt For YakushiinPlayer. (webapp)
// @CreateTime    : 2025/06/17 17:53
// @Author        : Luckykeeper
// @Email         : luckykeeper@luckykeeper.site
// @Project       : YakushiinL2S(webapp)

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/all.dart';
import 'package:webapp/model/code_box_text_ref.dart';
import 'package:webapp/yakushiin_widgets/code_editor/code_snippets.dart';
import 'package:webapp/yakushiin_widgets/code_editor/code_theme.dart';

class CustomCodeBox extends ConsumerStatefulWidget {
  final String language;
  final String theme;
  final String initialText;
  final WidgetRef ref;
  final String editorMode;
  final List<Widget>? optionalExplainWidgets;

  const CustomCodeBox({
    super.key,
    required this.language,
    required this.theme,
    required this.initialText,
    required this.ref,
    required this.editorMode,
    this.optionalExplainWidgets,
  });

  @override
  CustomCodeBoxState createState() => CustomCodeBoxState();
}

class CustomCodeBoxState extends ConsumerState<CustomCodeBox> {
  String? language;
  String? theme;
  String? initialText;

  final GlobalKey<InnerFieldState> _innerFieldKey =
      GlobalKey<InnerFieldState>();

  @override
  void initState() {
    super.initState();
    language = widget.language;
    theme = widget.theme;

    switch (widget.editorMode) {
      case "lrc":
        Timer.periodic(Durations.short1, (v) async {
          ref.read(lrcCodeBoxRef).current = getCurrentText();
        });
      case "srt":
        Timer.periodic(Durations.short1, (v) async {
          ref.read(srtCodeBoxRef).current = getCurrentText();
        });
        break;
      default:
    }
  }

  List<String?> get languageList {
    const top = <String>{"lrc", "srt"};
    return <String?>[
      ...top,
      null, // Divider
      ...codeSnippets.keys.where((el) => !top.contains(el)),
    ];
  }

  List<String?> get themeList {
    const top = <String>{
      "vs2015",
      "monokai-sublime",
      "a11y-dark",
      "an-old-hope",
      "vs",
      "atom-one-dark",
    };
    return <String?>[
      ...top,
      null, // Divider
      ...codeThemes.keys.where((el) => !top.contains(el)),
    ];
  }

  Widget buildDropdown(
    Iterable<String?> choices,
    String value,
    IconData icon,
    Function(String?) onChanged,
  ) {
    return DropdownButton<String>(
      value: value,
      items: choices.map((String? value) {
        return DropdownMenuItem<String>(
          value: value,
          child: value == null
              ? const Divider()
              : Text(value, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      icon: Icon(icon, color: Colors.white),
      onChanged: onChanged,
      dropdownColor: Colors.black87,
    );
  }

  String getCurrentText() {
    final text = _innerFieldKey.currentState?.getCurrentText() ?? '';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final codeDropdown = buildDropdown(languageList, language!, Icons.code, (
      val,
    ) {
      if (val == null) return;
      setState(() => language = val);
    });
    final themeDropdown = buildDropdown(themeList, theme!, Icons.color_lens, (
      val,
    ) {
      if (val == null) return;
      setState(() => theme = val);
    });
    final dropdowns = Row(
      children: [
        const SizedBox(width: 12.0),
        codeDropdown,
        const SizedBox(width: 12.0),
        themeDropdown,
        Container(width: 5),
      ],
    );

    final codeField = InnerField(
      // key: ValueKey("$language - $theme"),
      key: _innerFieldKey,
      language: language!,
      theme: theme!,
      initialText: widget.initialText,
    );
    return Column(children: [dropdowns, codeField]);
  }
}

class InnerField extends StatefulWidget {
  final String language;
  final String theme;
  final String initialText;

  const InnerField({
    super.key,
    required this.language,
    required this.theme,
    required this.initialText,
  });

  @override
  InnerFieldState createState() => InnerFieldState();
}

class InnerFieldState extends State<InnerField> {
  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    _initializeCodeController();
  }

  @override
  void didUpdateWidget(InnerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.language != oldWidget.language ||
        widget.theme != oldWidget.theme) {
      _initializeCodeController();
    }
  }

  void _initializeCodeController() {
    _codeController?.dispose();
    _codeController = CodeController(
      text: widget.initialText,
      patternMap: {
        r"\B#[a-zA-Z0-9]+\b": const TextStyle(color: Colors.red),
        r"\B@[a-zA-Z0-9]+\b": const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.blue,
        ),
        r"\B![a-zA-Z0-9]+\b": const TextStyle(
          color: Colors.yellow,
          fontStyle: FontStyle.italic,
        ),
      },
      stringMap: {"bev": const TextStyle(color: Colors.indigo)},
      language: allLanguages[widget.language],
    );
    setState(() {}); // Ensure the widget is rebuilt to apply the new controller
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  String getCurrentText() {
    return _codeController?.text ?? '';
  }

  void resetController() {
    setState(() {
      _codeController?.text = widget.initialText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = codeThemes[widget.theme];

    if (styles == null) {
      return _buildCodeField();
    }

    return CodeTheme(
      data: CodeThemeData(styles: styles),
      child: _buildCodeField(),
    );
  }

  Widget _buildCodeField() {
    return CodeField(
      controller: _codeController!,
      textStyle: const TextStyle(fontFamily: 'SourceCode'),
    );
  }
}

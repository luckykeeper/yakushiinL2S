// YakushiinL2S. Convert Dual Language Lrc To Srt For YakushiinPlayer. (webapp)
// @CreateTime    : 2025/06/17 14:10
// @Author        : Luckykeeper
// @Email         : luckykeeper@luckykeeper.site
// @Project       : YakushiinL2S(webapp)

import 'package:flutter/material.dart';

import '../theme/font.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({super.key, this.type = 0});

  final int type;

  @override
  CustomLoadingState createState() => CustomLoadingState();
}

class CustomLoadingState extends State<CustomLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(visible: widget.type == 0, child: _buildLoadingBasic()),
      ],
    );
  }

  Widget _buildLoadingBasic() {
    return Center(
      child: Container(
        height: 120,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Colors.cyan),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text('少女祈祷中...', style: styleFontLxwk),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

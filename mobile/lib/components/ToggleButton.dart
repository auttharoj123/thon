import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:lottie/lottie.dart';

class ToggleButton extends StatefulWidget {
  final double width;
  final String value;
  final Function(String value)? onChecked;
  const ToggleButton(
      {super.key, this.onChecked, this.value = "", this.width = 180});

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton>
    with TickerProviderStateMixin , AutomaticKeepAliveClientMixin {
  late final AnimationController _controller;

  var isChecked = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(covariant ToggleButton oldWidget) {
  //   _controller.animateTo(widget.isChecked ? 1 : 0,
  //       duration: Duration(milliseconds: 400));
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: FxSpacing.fromLTRB(10, 0, 10, 0),
      width: widget.width,
      height: 50,
      child: GestureDetector(
        onTap: () {
          isChecked = !isChecked;
          _controller.animateTo(isChecked ? 0.5 : 0,
              duration: Duration(milliseconds: 400));
          widget.onChecked?.call(widget.value);
        },
        child: Row(
          children: [
            Transform.scale(
              scale: 2,
              child: Lottie.asset(
                'assets/animations/lottie/toggle.json',
                controller: _controller,
                repeat: false,
              ),
            ),
            FxSpacing.width(10),
            Flexible(child: FxText.titleMedium(widget.value))
          ],
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

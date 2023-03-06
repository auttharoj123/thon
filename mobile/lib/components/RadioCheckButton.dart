import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RadioCheckButton extends StatefulWidget {
  final bool isChecked;

  const RadioCheckButton(this.isChecked, {super.key});

  @override
  State<RadioCheckButton> createState() => _RadioCheckButtonState();
}

class _RadioCheckButtonState extends State<RadioCheckButton>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

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

  @override
  void didUpdateWidget(covariant RadioCheckButton oldWidget) {
    _controller.animateTo(widget.isChecked ? 1 : 0, duration: Duration(milliseconds: 400));
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/lottie/radio-button.json',
      controller: _controller,
      repeat: false,
    );
  }
}

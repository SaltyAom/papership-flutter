import 'package:flutter/material.dart';

import 'package:niku/niku.dart';

class Progress extends StatelessWidget {
  const Progress({
    Key key,
    @required this.progress,
    this.color = Colors.white,
    this.background = Colors.white54,
  }) : super(key: key);

  final double progress;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(color: color)
        .niku()
        .fractionWidth(progress.isNaN ? 1 : progress)
        .height(3)
        .centerLeft()
        .container()
        .bg(background)
        .fullWidth()
        .height(3)
        .rounded()
        .build();
  }
}

// Flutter Hook + Niku
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:niku/niku.dart';

class Progress extends HookWidget {
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
  build(context) {
    final double progression = progress.isNaN ? 1 : progress;

    final animatedProgress = useAnimationController(
      duration: const Duration(milliseconds: 500),
      initialValue: progression,
    );

    useEffect(() {
      animatedProgress.animateTo(progression, curve: Curves.easeOutBack);

      return;
    }, [progression]);

    return ColoredBox(color: color)
        .niku()
        .builder(
          (child) => AnimatedBuilder(
            child: child,
            animation: animatedProgress,
            builder: (context, child) => FractionallySizedBox(
              widthFactor: animatedProgress.value,
              child: child,
            ),
          ),
        )
        .height(3)
        .centerLeft()
        .bg(background)
        .fullWidth()
        .height(3)
        .rounded()
        .build();
  }
}

// Normal Flutter
// import 'package:flutter/material.dart';

// class Progress extends StatefulWidget {
//   const Progress({
//     Key key,
//     @required this.progress,
//     this.color = Colors.white,
//     this.background = Colors.white54,
//   }) : super(key: key);

//   final double progress;
//   final Color color;
//   final Color background;

//   @override
//   _ProgressState createState() => _ProgressState();
// }

// class _ProgressState extends State<Progress>
//     with SingleTickerProviderStateMixin {
//   AnimationController animatedProgress;

//   @override
//   void initState() {
//     super.initState();
//     animatedProgress = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double progression = widget.progress.isNaN ? 1 : widget.progress;

//     animatedProgress.animateTo(progression, curve: Curves.easeOutBack);

//     return Container(
//       height: 3,
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
//       child: FractionallySizedBox(
//         widthFactor: 1,
//         child: ColoredBox(
//           color: widget.background,
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: SizedBox(
//               height: 3,
//               child: AnimatedBuilder(
//                 animation: animatedProgress,
//                 builder: (context, child) => FractionallySizedBox(
//                   widthFactor: animatedProgress.value,
//                   child: child,
//                 ),
//                 child: ColoredBox(
//                   color: widget.color,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

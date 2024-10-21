/*import 'dart:math';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class FooWidget extends StatefulWidget {
  @override
  State<FooWidget> createState() => _FooWidgetState();
}

class _FooWidgetState extends State<FooWidget> with TickerProviderStateMixin {
  final link = LayerLink();
  final followerKey = GlobalKey();
  late final transformController = AnimationController.unbounded(
    vsync: this,
    duration: const Duration(milliseconds: 1234),
  );
  late final borderController = AnimationController.unbounded(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );
  OverlayEntry? overlayEntry;
  final repaint = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPersistentFrameCallback(_forceRepaintCallback);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) => _toggleOverlay());
    _animateBorder();
    _animateTransform();
  }

  void _forceRepaintCallback(Duration timeStamp) {
    // debugPrint('timeStamp: $timeStamp');
    repaint.value++;
  }

  _animateTransform() async {
    while (true) {
      await transformController.animateTo(transformController.value + 8, curve: Curves.easeInOut);
      await Future.delayed(const Duration(milliseconds: 1300));
    }
  }

  _animateBorder() async {
    while (true) {
      await borderController.animateTo(borderController.value + 4.567 * pi, curve: Curves.ease);
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  static const kSize = Size(100, 100);
  static final kSizeCenter = kSize.center(Offset.zero);

  @override
  Widget build(BuildContext context) {
    // timeDilation = 10;
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, -0.5),
          child: AnimatedBuilder(
            animation: transformController,
            builder: (context, child) {
              return Transform(
                transform: composeMatrixFromOffsets(
                  anchor: kSizeCenter,
                  translate: kSizeCenter,
                  rotation: -transformController.value / 5,
                  scale: ui.lerpDouble(0.5, 4, pow(sin(transformController.value / 10), 2).toDouble())!,
                ),
                child: child,
              );
            },
            child: CompositedTransformTarget(
              link: link,
              child: SizedBox.fromSize(
                size: kSize,
                child: const FlutterLogo(),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.75),
          child: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.orange),
            ),
            onPressed: _toggleOverlay,
            child: Text(overlayEntry == null? 'add overlay' : 'remove overlay'),
          ),
        ),
      ],
    );
  }

  _toggleOverlay() {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(
        builder: (ctx) => CompositedTransformFollower(
          link: link,
          key: followerKey,
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            child: UnconstrainedBox(
              alignment: Alignment.topLeft,
              child: IgnorePointer(
                child: CustomPaint(
                  painter: FooWidgetPainter(
                    followerKey: followerKey,
                    borderController: borderController,
                    // repaint: Listenable.merge([transformController, borderController]),
                    repaint: repaint,
                  ),
                  child: SizedBox.fromSize(
                    size: link.leaderSize,
                    child: const Center(
                      child: Text('text and border come from the overlay', textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(overlayEntry!);
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) => overlayEntry!.markNeedsBuild());
    } else {
      overlayEntry!.remove();
      overlayEntry = null;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    transformController.dispose();
    borderController.dispose();
  }
}

class FooWidgetPainter extends CustomPainter {
  FooWidgetPainter({
    required this.followerKey,
    required this.borderController,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final AnimationController borderController;
  final GlobalKey followerKey;
  RenderFollowerLayer? renderFollowerLayer;

  @override
  void paint(ui.Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    renderFollowerLayer ??= followerKey.currentContext?.findRenderObject() as RenderFollowerLayer;
    final matrix = renderFollowerLayer?.layer?.getLastTransform();
    if (matrix == null) {
      debugPrint('cannot get last transform');
      return;
    }

    double scale = _getScaleFromMatrix(matrix);

    //
    // debugPrint('matrix: $matrix, rect: $rect, scale: $scale');
    //

    final shader = SweepGradient(
      colors: [Colors.black12, Colors.red.shade900, Colors.blue.shade900, Colors.black12],
      stops: const [0.375, 0.4, 0.6, 0.625],
      transform: GradientRotation(borderController.value),
    ).createShader(rect);
    // draws 6 px border no matter what [scale] is used
    final paint = Paint()
      ..shader = shader
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 6 / scale);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    for (int i = 0; i < 3; i++ ) {
      canvas.drawRRect(rrect, paint);
    }
  }

  /// find the scaleX factor of the [matrix]
  /// see Matrix4.getMaxScaleOnAxis() implementation
  double _getScaleFromMatrix(Matrix4 matrix) {
    final s = matrix.storage;
    return sqrt(s[0] * s[0] + s[1] * s[1] + s[2] * s[2]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Matrix4 composeMatrixFromOffsets({
  double scale = 1,
  double rotation = 0,
  Offset translate = Offset.zero,
  Offset anchor = Offset.zero,
}) {
  final double c = cos(rotation) * scale;
  final double s = sin(rotation) * scale;
  final double dx = translate.dx - c * anchor.dx + s * anchor.dy;
  final double dy = translate.dy - s * anchor.dx - c * anchor.dy;
  return Matrix4(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
}*/
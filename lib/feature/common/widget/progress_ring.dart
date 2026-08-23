import 'dart:math' as math;

import 'package:crying_time/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 홈 화면의 진행률 링. 가운데는 비워 두고 child 를 얹는다.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.progress,
    required this.color,
    required this.child,
    this.size = 216,
    this.thickness = 20,
    super.key,
  });

  /// 0.0 ~ 1.0. 범위를 벗어난 값은 그리는 쪽에서 잘라낸다.
  final double progress;

  final Color color;
  final Widget child;
  final double size;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: _ProgressRingPainter(
                progress: progress.clamp(0.0, 1.0),
                color: color,
                thickness: thickness,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.thickness,
  });

  final double progress;
  final Color color;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    // 스트로크는 경로를 가운데 두고 양옆으로 퍼지므로, 바깥 지름을 맞추려면
    // 반지름을 두께의 절반만큼 줄여야 한다.
    final Rect arcRect = (Offset.zero & size).deflate(thickness / 2);
    final double radius = arcRect.width / 2;

    final Paint trackPaint = Paint()
      ..color = AppColors.track
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    canvas.drawCircle(arcRect.center, radius, trackPaint);

    if (progress <= 0) {
      return;
    }

    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    // 12시(-pi/2)에서 출발해 시계방향으로 진행한다.
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.thickness != thickness;
  }
}

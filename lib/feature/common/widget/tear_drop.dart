import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 한쪽 모서리만 각진 물방울 심볼. 스플래시와 온보딩이 같이 쓴다.
///
/// CustomPainter 대신 세 모서리만 둥근 사각형을 45도 돌려 만든다. 모양이 단순해
/// 별도 Path 를 둘 이유가 없고, 색·크기만 받으면 두 화면이 같은 심볼을 쓴다.
/// 회전은 레이아웃 크기를 바꾸지 않으므로 부모는 대각선(size * 1.42)이 들어갈
/// 만큼 공간을 잡아야 한다.
class TearDrop extends StatelessWidget {
  const TearDrop({required this.size, required this.color, super.key});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(size / 2);

    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            topRight: radius,
            bottomLeft: radius,
            bottomRight: radius,
          ),
        ),
      ),
    );
  }
}

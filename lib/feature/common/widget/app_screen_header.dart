import 'package:crying_time/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 뒤로가기 화살표 + 제목으로 이루어진 화면 상단 행.
///
/// AppBar 를 쓰지 않는 디자인이라 Row 로 직접 조립한다.
class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    required this.title,
    this.onBack,
    this.trailing,
    super.key,
  });

  final String title;

  /// null 이면 화살표 자체를 그리지 않는다(루트 화면).
  final VoidCallback? onBack;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (onBack != null) ...<Widget>[
          // IconButton 은 48px 최소 크기와 자체 여백을 강제해 제목 정렬이 틀어진다.
          InkResponse(
            onTap: onBack,
            radius: 22,
            child: const Icon(
              Icons.arrow_back,
              size: 22,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ?trailing,
      ],
    );
  }
}

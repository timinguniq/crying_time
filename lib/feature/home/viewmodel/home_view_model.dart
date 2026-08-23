import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

/// 홈 화면이 보여줄 게시글 번호 목록.
///
/// 화면에는 리터럴을 두지 않는다는 원칙에 따라, 목록이 서버에서 오도록 바뀌더라도
/// 이 viewmodel 만 고치면 되게 한다.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  List<int> build() => const [1, 2, 3, 4, 5];
}

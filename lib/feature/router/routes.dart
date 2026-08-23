/// 경로 문자열을 한 곳에서만 관리한다.
abstract final class Routes {
  static const String home = '/';
  static const String post = '/posts/:id';

  static String postDetail(int id) => '/posts/$id';
}

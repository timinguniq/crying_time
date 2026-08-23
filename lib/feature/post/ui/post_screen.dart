import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/feature/common/failure_message.dart';
import 'package:crying_time/feature/post/ui/post_error_view.dart';
import 'package:crying_time/feature/post/viewmodel/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({required this.postId, super.key});

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPost = ref.watch(postViewModelProvider(postId));

    return Scaffold(
      appBar: AppBar(title: Text('Post #$postId')),
      body: switch (asyncPost) {
        AsyncData(:final value) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(value.body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        AsyncError(:final error) => PostErrorView(
          // viewmodel 은 Failure 만 던지지만, 그 외 예외가 올라와도
          // 내부 메시지를 화면에 노출하지 않는다.
          message: (error is Failure ? error : const UnknownFailure()).message,
          onRetry: () => ref.invalidate(postViewModelProvider(postId)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

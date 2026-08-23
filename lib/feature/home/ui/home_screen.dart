import 'package:crying_time/feature/home/viewmodel/home_view_model.dart';
import 'package:crying_time/feature/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postIds = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('crying_time')),
      body: ListView.separated(
        itemCount: postIds.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final postId = postIds[index];
          return ListTile(
            title: Text('Post #$postId'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.postDetail(postId)),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/widgets/empty_state.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: EmptyState(
        title: 'Page not found',
        message: "We couldn't find what you were looking for.",
        action: FilledButton(
          onPressed: () => context.go('/'),
          child: const Text('Go home'),
        ),
      ),
    );
  }
}

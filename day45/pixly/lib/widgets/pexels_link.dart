import 'package:flutter/material.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/utils/links.dart';

/// The visible link back to Pexels that its API guidelines ask for on
/// every screen that shows results from an API request.
class PexelsLink extends StatelessWidget {
  const PexelsLink({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => openLink(context, AppConstants.pexelsUrl),
      child: const Text('Photos by Pexels'),
    );
  }
}

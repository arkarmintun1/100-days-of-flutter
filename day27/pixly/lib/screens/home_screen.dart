import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pixly/config/assets.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/widgets/empty_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 12,
          children: [
            SvgPicture.asset(AppAssets.logo, width: 32, height: 32),
            const Text(AppConstants.appName),
          ],
        ),
      ),
      body: EmptyState(
        title: 'No photos yet',
        message: 'Beautiful photos from Pexels will show up here soon.',
        action: Image.asset(AppAssets.placeholder, width: 48, height: 48),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pixly/config/assets.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/widgets/empty_state.dart';
import 'package:pixly/widgets/photo_grid.dart';
import 'package:pixly/widgets/shimmer_grid.dart';
import 'package:provider/provider.dart';

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
      body: const _PhotosBody(),
    );
  }
}

class _PhotosBody extends StatelessWidget {
  const _PhotosBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PhotosProvider>();
    final photos = provider.photos;

    if (provider.isLoading && photos.isEmpty) {
      return const ShimmerGrid();
    }

    if (provider.error != null && photos.isEmpty) {
      return EmptyState(
        title: 'Something went wrong',
        message: provider.error!,
        action: FilledButton.icon(
          onPressed: () => context.read<PhotosProvider>().loadCurated(),
          icon: const Icon(Icons.refresh),
          label: const Text('Try again'),
        ),
      );
    }

    if (photos.isEmpty) {
      return const EmptyState(
        title: 'No photos yet',
        message: 'Beautiful photos from Pexels will show up here soon.',
      );
    }

    return PhotoGrid(photos: photos);
  }
}

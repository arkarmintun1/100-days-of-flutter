import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/providers/bookmarks_provider.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/providers/search_provider.dart';
import 'package:pixly/providers/theme_provider.dart';
import 'package:pixly/repositories/photo_repository.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/storage/bookmarks_storage.dart';
import 'package:pixly/storage/settings_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Show the Poppins font license on Flutter's licenses page.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Poppins'], license);
  });

  // Reads the saved values from the device once, so later reads are instant.
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: {PrefsBookmarksStorage.key, PrefsSettingsStorage.themeModeKey},
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => PhotoRepository(ApiClient())),
        ChangeNotifierProvider(
          create: (context) =>
              PhotosProvider(context.read<PhotoRepository>())..loadCurated(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(context.read<PhotoRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarksProvider(PrefsBookmarksStorage(prefs)),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(PrefsSettingsStorage(prefs)),
        ),
      ],
      child: PixlyApp(router: createRouter()),
    ),
  );
}

class PixlyApp extends StatelessWidget {
  const PixlyApp({super.key, required this.router});

  /// Created once in main(), not in build(): a new GoRouter on every rebuild
  /// would reset the navigation stack.
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Rebuilds the app with the other theme when the user switches.
      themeMode: context.watch<ThemeProvider>().themeMode,
      routerConfig: router,
    );
  }
}

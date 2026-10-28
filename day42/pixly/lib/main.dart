import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/providers/search_provider.dart';
import 'package:pixly/providers/theme_notifier.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/storage/bookmarks_storage.dart';
import 'package:pixly/storage/settings_storage.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;
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

  // Riverpod's container: holds the values of all Riverpod providers.
  // Created here (not by a ProviderScope widget) so main() can read from it
  // while the ChangeNotifiers below still use package:provider.
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) =>
                PhotosProvider(container.read(photoRepositoryProvider))
                  ..loadCurated(),
          ),
          ChangeNotifierProvider(
            create: (_) =>
                SearchProvider(container.read(photoRepositoryProvider)),
          ),
        ],
        child: PixlyApp(router: createRouter()),
      ),
    ),
  );
}

class PixlyApp extends ConsumerWidget {
  const PixlyApp({super.key, required this.router});

  /// Created once in main(), not in build(): a new GoRouter on every rebuild
  /// would reset the navigation stack.
  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Rebuilds the app with the other theme when the user switches.
      themeMode: ref.watch(themeModeProvider),
      routerConfig: router,
    );
  }
}

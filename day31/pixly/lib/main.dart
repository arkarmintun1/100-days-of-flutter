import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/repositories/photo_repository.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Show the Poppins font license on Flutter's licenses page.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Poppins'], license);
  });

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => PhotoRepository(ApiClient())),
        ChangeNotifierProvider(
          create: (context) =>
              PhotosProvider(context.read<PhotoRepository>())..loadCurated(),
        ),
      ],
      child: const PixlyApp(),
    ),
  );
}

class PixlyApp extends StatelessWidget {
  const PixlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/main.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/repositories/photo_repository.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'helpers/fake_repository.dart';

void main() {
  testWidgets('app starts on HomeScreen', (tester) async {
    final repo = FakePhotoRepository();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<PhotoRepository>.value(value: repo),
          ChangeNotifierProvider(
            create: (_) => PhotosProvider(repo)..loadCurated(),
          ),
        ],
        child: PixlyApp(router: createRouter()),
      ),
    );
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}

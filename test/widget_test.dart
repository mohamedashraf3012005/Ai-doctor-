import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:care360/main.dart';
import 'package:care360/core/di/service_locator.dart' as di;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Set up mock values for FlutterSecureStorage to prevent channel errors
    FlutterSecureStorage.setMockInitialValues({});

    // Mock the secure storage native channel call just in case
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.itrix.com.br/flutter_secure_storage'),
          (MethodCall methodCall) async {
            return null;
          },
        );

    await initializeDateFormatting('en');
    await di.init();
  });

  testWidgets('renders the home experience', (WidgetTester tester) async {
    await tester.pumpWidget(const Care360App());
    await tester.pump();

    // Verify app title exists in some widget (e.g. Header or Home section)
    expect(find.text('Smart Care 360'), findsWidgets);
    expect(
      find.text('Your Integrated Platform for Smart Medical Care'),
      findsWidgets,
    );
    expect(find.text('Platform Features'), findsWidgets);
  });
}

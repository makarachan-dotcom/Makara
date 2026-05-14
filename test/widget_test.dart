import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:makara_premium_app/core/providers/theme_provider.dart';
import 'package:makara_premium_app/core/theme/app_theme.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Center(child: Text('UNREAL ENGINE 5')),
          ),
        ),
      ),
    );

    expect(find.text('UNREAL ENGINE 5'), findsOneWidget);
  });
}

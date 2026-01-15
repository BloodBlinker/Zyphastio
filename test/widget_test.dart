import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zyphastio/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ZyphastioApp()));
    // Verifying it doesn't crash is enough for a smoke test
  });
}

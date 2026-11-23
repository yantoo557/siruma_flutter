
import 'package:flutter_test/flutter_test.dart';
import 'package:siruma_flutter/main.dart';

void main() {
  testWidgets('SIRUMA app berhasil ditampilkan', (WidgetTester tester) async {
    await tester.pumpWidget(const SirumaApp());

    expect(find.byType(SirumaApp), findsOneWidget);
  });
}

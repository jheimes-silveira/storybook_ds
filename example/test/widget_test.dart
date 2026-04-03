import 'package:flutter_test/flutter_test.dart';

import 'package:example/custom_card_storybook.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('Storybook exemplo monta sem erro', (WidgetTester tester) async {
    await tester.pumpWidget(const StorybookDemoApp());
    await tester.pump();

    expect(find.byType(CustomCardStorybook), findsOneWidget);
  });
}

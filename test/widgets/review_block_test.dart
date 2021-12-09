import 'package:flutter_test/flutter_test.dart';
import 'package:otlplus/widgets/review_block.dart';

import '../utils/extensions.dart';
import '../utils/samples.dart';

void main() {
  testWidgets('pump ReviewBlock', (WidgetTester tester) async {
    await tester.pumpWidget(ReviewBlock(review: SampleReview.shared).material);
  });

  testWidgets('hide buttons in ReviewBlock', (WidgetTester tester) async {
    await tester.pumpWidget(ReviewBlock(review: SampleReview.shared, isSimple: true,).material);

    final likeFinder = find.text('좋아요');
    final reportFinder = find.text('신고하기');

    expect(likeFinder, findsNothing);
    expect(reportFinder, findsNothing);
  });

  testWidgets('show buttons in ReviewBlock', (WidgetTester tester) async {
    await tester.pumpWidget(ReviewBlock(review: SampleReview.shared, isSimple: false,).material);

    final likeFinder = find.text('좋아요');
    final reportFinder = find.text('신고하기');

    expect(likeFinder, findsOneWidget);
    expect(reportFinder, findsOneWidget);
  });
}

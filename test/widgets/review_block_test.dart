import 'package:flutter_test/flutter_test.dart';
import 'package:otlplus/widgets/review_block.dart';

import '../utils/extensions.dart';
import '../utils/samples.dart';

void main() {
  testWidgets('pump ReviewBlock', (WidgetTester tester) async {
    await tester.pumpWidget(ReviewBlock(review: SampleReview.shared).material);
  });

  testWidgets('test buttons in ReviewBlock', (WidgetTester tester) async {
    await tester.pumpWidget(ReviewBlock(
      review: SampleReview.shared,
    ).material);

    final likeFinder = find.text('좋아요');
    final reportFinder = find.text('신고하기');

    expect(likeFinder, findsOneWidget);
    expect(reportFinder, findsOneWidget);
  });
}

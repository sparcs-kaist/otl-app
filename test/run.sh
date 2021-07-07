#!/bin/sh
file=test/coverage_helper_test.dart
echo "// This is a generated file; do not edit or check into version control.\n" > $file
echo "// Helper file to make coverage work for all dart files.\n" > $file
echo "// ignore_for_file: unused_import" >> $file
find lib -not -name '*.g.dart' -and -name '*.dart' | cut -c4- | awk -v package=$1 '{printf "import '\''package:timeplanner_mobile%s%s'\'';\n", package, $1}' >> $file
echo "void main(){}" >> $file

flutter test --coverage

lcov --remove coverage/lcov.info 'lib/*/*.freezed.dart' 'lib/*/*.g.dart' 'lib/*/*.part.dart' 'lib/generated/*.dart' 'lib/generated/*/*.dart' -o coverage/lcov.info
genhtml coverage/lcov.info -o coverage/html

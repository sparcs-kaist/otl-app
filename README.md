# OTL App

Online Timeplanner with Lectures Plus App @ KAIST

[![Lint](https://github.com/sparcs-kaist/otl-app/actions/workflows/lint.yml/badge.svg)](https://github.com/sparcs-kaist/otl-app/actions/workflows/lint.yml)
[![Build](https://github.com/sparcs-kaist/otl-app/actions/workflows/build.yml/badge.svg)](https://github.com/sparcs-kaist/otl-app/actions/workflows/build.yml)
[![Test](https://github.com/sparcs-kaist/otl-app/actions/workflows/test.yml/badge.svg)](https://github.com/sparcs-kaist/otl-app/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/sparcs-kaist/otl-app/branch/main/graph/badge.svg?token=6NJ2CXNXBT)](https://codecov.io/gh/sparcs-kaist/otl-app)

## Introduction

OTL: Online Timeplanner with Lectures Plus App @ KAIST

카이스트의 입학부터 졸업까지 모든 과목과 시간표는 OTL과 함께!

1. 홈
    - 모든 과목을 바로 검색하세요.
    - 오늘 나의 시간표를 한 눈에 확인하세요.
    - 수강신청, 수강변경, 개강, 종강 등 주요 일정을 알려드립니다.
2. 시간표
    - 이번 학기 나의 시간표를 확인하고 사진으로 저장하세요.
    - 다음 학기 시간표를 구성해 보고 학점, AU, 성적, 널널, 강의 등 다양한 지표를 비교하세요.
3. 과목사전
    - 카이스트의 모든 과목을 검색하세요.
    - 학과, 구분, 학년, 기간으로 필터링하고 다양한 기준으로 정렬하세요.
4. 과목후기
    - 최근 작성된 따끈따끈한 과목후기를 읽어보세요.
    - 유용하고 재미있는 과목후기에 좋아요를 눌러주세요.

계정 정보에서 학기 별 수강한 과목, 내 전공을 확인할 수 있습니다.

문의사항 & 피드백
otlplus@sparcs.org

## Quick Start

### Run

You need to install `flutter`

```bash
flutter run
```

### Test

- Unit & Widget test

```bash
flutter test
```

- Unit & Widget test with coverage

lcov가 필요합니다. macOS에서는 `brew install lcov`로 설치하실 수 있습니다.

```bash
sh ./test/run.sh
```

- Integration test

You need to start emulator/device.

```bash
flutter drive --target=test_driver/app.dart
```

### Apple Silicon JDK 8 설치

Apple Silicon은 aarch64로 컴파일된 JDK 8 버전을 설치하여야  
`sdkmanager`와 같은 Android SDK tool들을 사용할 수 있습니다.

```bash
brew tap mdogan/zulu
brew install zulu-jdk8
```

## How to contribute?

Please visit [CONTRIBUTING.md](https://github.com/sparcs-kaist/otl-app/blob/main/CONTRIBUTING.md)

## Credits

- [Winrobrine](https://github.com/Winrobrine): Developer 2020
- [Seungbin Oh](https://github.com/sboh1214): Developer 2021-2022
- [Star](https://github.com/snaoyam): Developer 2022
- [SungyeopJeong](https://github.com/SungyeopJeong): Developer 2022

Thanks to every [contributors](https://github.com/sparcs-kaist/otl-app/graphs/contributors).

## License

Copyright (c) 2021-2022 SPARCS.
Distribution of this application without the authors' explicit written approval is strictly prohibited.

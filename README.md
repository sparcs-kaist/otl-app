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

## How to develop

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

### Error on iOS Test

CI 환경에서 사용하는 mac의 메이저 버전을 업데이트 한 후
iOS Integration Test에서 Simulator 시작을 하지 못하는 에러가 발생합니다.
`.github/workflows/test.yml`의 Simulator 아이폰 버전을 하나 올려주면 됩니다.
ex) `/iPhone 12 Pro/` --> `/iPhone 13 Pro/`

## How to deploy

### Fastlane 설정

공식 홈페이지를 참고하였습니다.
[Continuous Delivery using fastlane with Flutter](https://flutter.io/docs/deployment/fastlane-cd)

```bash
gem install bundler
```

### Credentials

- `android/fastlane/otlplus-fastlane.json` : Google Play 서비스 계정 JSON 파일
- `android/fastlane/upload-keystore.jks` : Android App Signing Key for Upload Google Play
- `android/key.properties` : 아래와 같이 Signing Key 정보를 입력합니다.

```env
storeFile=../fastlane/upload-keystore.jks
storePassword=********
keyPassword=********
keyAlias=upload
```

- `ios/fastlane/.env.default` : 아래와 같이 Apple ID 계정 정보를 입력합니다.

```env
FASTLANE_USER=****@****.***
FASTLANE_PASSWORD=********
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=****-****-****-****
```

### 알파 버전 배포

- Android: Google Play 스토어 `비공개 테스트 - Alpha` 트랙으로 업로드
- iOS: TestFlight로 업로드

```bash
cd android && bundle exec fastlane alpha && cd ../ios && bundle exec fastlane alpha
```

배포 후 `pubspec.yaml`과 iOS Xcode 프로젝트 관련 파일들의 변경사항을 Discard 합니다.

## How to contribute?

Please visit [CONTRIBUTING.md](https://github.com/sparcs-kaist/otl-app/blob/main/CONTRIBUTING.md)

## Credits

- [Winrobrine](https://github.com/Winrobrine): Developer 2020
- [Seungbin Oh](https://github.com/sboh1214): Developer 2021-2023
- [Star](https://github.com/snaoyam): Developer 2022-2023
- [SungyeopJeong](https://github.com/SungyeopJeong): Developer 2022-2023
- [Seungho Jang](https://github.com/hoosong0235): Developer 2023
- [Soongyu Kwon](https://github.com/s8ngyu): Developer 2023

Thanks to every [contributors](https://github.com/sparcs-kaist/otl-app/graphs/contributors).

## License

Copyright (c) 2021-2023 SPARCS.
Distribution of this application without the authors' explicit written approval is strictly prohibited.

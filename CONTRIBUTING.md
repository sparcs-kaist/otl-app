# 기여하기

## Issue

1. [Issues](https://github.com/sparcs-kaist/otl-app/issues)에서 Issue를 생성합니다.
2. 기능 제안은 Feature request, 버그 제보는 Bug report를 선택합니다.
3. Issue 담당자를 지정하고 반영할 버전을 마일스톤 (ex. 1.2) 으로 선택합니다.

## Pull requests

1. 본인의 Github ID를 붙여 브랜치를 생성합니다. ex. `sboh1214-dev`
2. 담당한 Issue에 대한 코드를 작성합니다.
3. 아래 명령어를 통해 코드를 Foramt, Lint, Test 합니다.
```bash
flutter format .
flutter analyze
flutter test
```
4. PR을 생성합니다. Feature request Issue는 `Resolve`, Bug report Issue는 `Fix`로 제목을 정합니다.

아래와 같이 PR 제목을 생성 후 머지하면 자동으로 Issue가 닫히게 됩니다.
```
Resolve #14, Fix #13, #16, Update github actions
```
5. `enhancement`, `bug`, `documentation` 중 해당되는 종류를 태그로 달고 담당자에게 리뷰를 요청합니다.
6. Github actions 통과, 리뷰 후 머지합니다.

## Releases
1. [Releases](https://github.com/sparcs-kaist/otl-app/releases)에 갑니다.
2. 자동으로 정리된 PR 목록을 보고, 이번 버전에서 변경된 사항을 Changes에 작성합니다.
3. Pre-Release인지 체크하고, 배포합니다. **`pubspec.yaml`의 버전과 일치하는지 다시 한번 확인합니다.**
4. Actions에서 배포를 확인하고, iOS는 수동 배포해 줍니다.

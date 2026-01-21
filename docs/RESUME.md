# Number Drop Clone - 프로젝트 진행 요약

## 프로젝트 개요
- **게임명**: Number Drop (Drop The Number 클론)
- **원본**: SuperBox의 "Drop Merge: Number Puzzle"
- **플랫폼**: Flutter (Android, Web)
- **프로젝트 위치**: `D:\htdocs\test_\number_drop_clone\app`
- **Flutter SDK**: `C:\flutter\flutter`

---

## 완료된 Phase

### Phase 1: 기본 게임 구현 ✅
- **5x8 그리드 보드** 구현
- **블록 드롭 메커니즘**: 열 선택 시 블록 드롭
- **합체 로직**: BFS 알고리즘으로 인접 동일 숫자 탐색 및 합체
- **중력 시스템**: 합체 후 빈 공간으로 블록 낙하
- **점수 시스템**: 합체 시 점수 획득
- **게임 오버 조건**: 블록이 보드 상단에 도달

**관련 파일:**
- `lib/models/block.dart` - 블록 모델
- `lib/models/game_state.dart` - 게임 상태 및 로직
- `lib/config/colors.dart` - 숫자별 색상 정의
- `lib/config/constants.dart` - 게임 상수

### Phase 2: UI/UX 구현 ✅
- **메인 메뉴**: 최고점수, 코인, 게임 횟수 표시
- **드롭 그림자**: 블록이 떨어질 위치 미리보기
- **망치 모드**: 코인으로 블록 제거 (100 코인)
- **설정 화면**: 사운드, 진동 토글

**관련 파일:**
- `lib/screens/main_menu_screen.dart`
- `lib/screens/game_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/widgets/game_board.dart`
- `lib/widgets/block_widget.dart`

### Phase 3: 애니메이션 구현 ✅
- **블록 드롭 애니메이션**: Ease-out 효과
- **합체 애니메이션**: Scale + Fade
- **콤보 팝업**: 연쇄 합체 시 x2, x3... 표시
- **2048 글로우 효과**: 2048 블록에 특수 빛나는 효과

**관련 파일:**
- `lib/widgets/animated_block_widget.dart`
- `lib/widgets/animated_game_board.dart`
- `lib/widgets/score_popup.dart`

### Phase 4: 추가 기능 구현 ✅
- **사운드 서비스**: BGM, 효과음 (드롭, 합체, 콤보)
- **진동 서비스**: 햅틱 피드백
- **저장 서비스**: SharedPreferences로 데이터 저장
- **일일 보너스**: 매일 100 코인 지급

**관련 파일:**
- `lib/services/audio_service.dart`
- `lib/services/vibration_service.dart`
- `lib/services/storage_service.dart`
- `lib/models/user_data.dart`

### Phase 5: 수익화 ✅
- **Google AdMob**: 리워드 광고 (100-120 코인)
- **인앱 결제**: 코인 패키지 (500/1500/5000), 광고 제거, 프리미엄
- **상점 화면**: 구매 UI

**관련 파일:**
- `lib/services/ad_service.dart`
- `lib/services/iap_service.dart`
- `lib/screens/shop_screen.dart`

### Phase 6: 완성도 및 빌드 ✅
- **Android 설정**: AndroidManifest.xml에 AdMob, 권한 추가
- **웹 플랫폼 지원**: kIsWeb 체크로 광고/IAP 스킵
- **웹 빌드**: `build/web/` 폴더에 성공적으로 빌드

**관련 파일:**
- `android/app/src/main/AndroidManifest.xml`
- `android/app/build.gradle`

---

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── config/
│   ├── colors.dart           # 숫자별 색상 (2~4096)
│   ├── constants.dart        # 게임 상수 (그리드 크기, 코인 비용 등)
│   └── theme.dart            # 다크 테마
├── models/
│   ├── block.dart            # 블록 모델 (value, row, column)
│   ├── game_state.dart       # 게임 상태 (Provider ChangeNotifier)
│   └── user_data.dart        # 사용자 데이터 (점수, 코인, 통계)
├── screens/
│   ├── main_menu_screen.dart # 메인 메뉴
│   ├── game_screen.dart      # 게임 화면
│   ├── settings_screen.dart  # 설정 화면
│   └── shop_screen.dart      # 상점 화면
├── widgets/
│   ├── animated_block_widget.dart  # 애니메이션 블록
│   ├── animated_game_board.dart    # 애니메이션 보드
│   ├── block_widget.dart           # 기본 블록 위젯
│   ├── game_board.dart             # 기본 게임 보드
│   ├── next_block_preview.dart     # 다음 블록 미리보기
│   ├── score_display.dart          # 점수 표시
│   └── score_popup.dart            # 점수/콤보 팝업
└── services/
    ├── ad_service.dart       # Google AdMob
    ├── audio_service.dart    # 사운드
    ├── iap_service.dart      # 인앱 결제
    ├── storage_service.dart  # 로컬 저장
    └── vibration_service.dart # 진동
```

---

## 핵심 알고리즘

### 블록 합체 (BFS)
```dart
Set<Block> _findAdjacentSame(int row, int col, int value) {
  final result = <Block>{};
  final queue = <List<int>>[[row, col]];
  final visited = <String>{};

  while (queue.isNotEmpty) {
    final current = queue.removeAt(0);
    final r = current[0], c = current[1];
    final key = '$r,$c';

    if (visited.contains(key)) continue;
    visited.add(key);

    final block = _board[r][c];
    if (block != null && block.value == value) {
      result.add(block);
      // 상하좌우 탐색
      for (final dir in [[0,1],[0,-1],[1,0],[-1,0]]) {
        final nr = r + dir[0], nc = c + dir[1];
        if (nr >= 0 && nr < rows && nc >= 0 && nc < columns) {
          queue.add([nr, nc]);
        }
      }
    }
  }
  return result;
}
```

### 숫자별 색상
| 숫자 | 색상 | HEX |
|------|------|-----|
| 2 | 분홍 | #E91E63 |
| 4 | 민트 | #4DD0E1 |
| 8 | 청록 | #26C6DA |
| 16 | 보라 | #7E57C2 |
| 32 | 주황 | #FF7043 |
| 64 | 녹색 | #66BB6A |
| 128 | 회청 | #78909C |
| 256 | 핑크 | #EC407A |
| 512 | 녹색 | #4CAF50 |
| 1024 | 회색 | #90A4AE |
| 2048 | 금색 | #FFD700 |
| 4096 | 빨강 | #F44336 |

---

## 빌드 및 실행

### 웹 실행 (개발)
```bash
cd D:\htdocs\test_\number_drop_clone\app
C:\flutter\flutter\bin\flutter.bat run -d chrome
```

### 웹 빌드 (프로덕션)
```bash
C:\flutter\flutter\bin\flutter.bat build web
# 결과: build/web/
```

### Android APK 빌드
```bash
# Android SDK 필요
C:\flutter\flutter\bin\flutter.bat build apk --release
# 결과: build/app/outputs/flutter-apk/app-release.apk
```

---

## 프로덕션 배포 체크리스트

### Android
- [ ] `ad_service.dart`: 실제 AdMob 광고 단위 ID로 교체
- [ ] `AndroidManifest.xml`: 실제 AdMob 앱 ID로 교체
- [ ] Google Play Console에서 IAP 상품 등록
- [ ] 앱 서명 키 생성 및 설정
- [ ] 앱 아이콘 및 스플래시 이미지 교체

### 테스트 광고 ID (현재 설정)
- **AdMob App ID**: `ca-app-pub-3940256099942544~3347511713`
- **Rewarded Ad Unit**: `ca-app-pub-3940256099942544/5224354917`

### IAP 상품 ID
| 상품 | ID | 유형 |
|------|-----|------|
| 500 코인 | coins_500 | 소모성 |
| 1500 코인 | coins_1500 | 소모성 |
| 5000 코인 | coins_5000 | 소모성 |
| 광고 제거 | remove_ads | 비소모성 |
| 프리미엄 | premium | 비소모성 |

---

## 제외된 기능 (사용자 요청)
- ❌ 강제 광고 재생 (게임 중간 광고 없음)
- ❌ 소셜 기능 (친구 초대, 글로벌 랭킹)

---

## 알려진 이슈
1. **웹에서 광고/IAP 미지원**: 웹 플랫폼에서는 AdMob, IAP가 작동하지 않음 (정상)
2. **사운드 파일 미포함**: `audioplayers` 패키지 설정됨, 실제 사운드 파일 추가 필요

---

## 작성일
2026-01-21

# Number Drop Clone - 작업 내역서
**작업일**: 2026-02-05

---

## 1. Share 기능 구현

### 개요
게임 점수와 씨드를 공유할 수 있는 기능 추가

### 변경 파일
- `app/lib/screens/game_screen.dart`
- `app/lib/widgets/score_display.dart`

### 구현 내용

#### 1.1 게임 오버 화면 Share 버튼
- 위치: PLAY AGAIN 버튼 옆
- 색상: 초록색 (#25D366)
- 공유 내용:
  - 최종 점수
  - 최고 블록 값
  - 최고 기록
  - 게임 씨드

#### 1.2 일시정지 화면 Share 버튼
- 위치: NEW GAME 버튼 옆
- 현재 점수 표시 추가
- 공유 내용:
  - 현재 점수
  - 게임 씨드

#### 1.3 공유 메시지 형식

**게임 오버 시:**
```
Number Drop - I scored 12450 points!

Highest Block: 512
Best Score: 15000
Game Seed: 1738764000

Can you beat my score? Try the same game with seed: 1738764000
```

**일시정지 중:**
```
Number Drop - I'm playing a game!

Current Score: 5200
Game Seed: 1738764000

Challenge me! Play the same game with seed: 1738764000
```

---

## 2. Daily Challenge UI 구현

### 개요
매일 모든 플레이어가 동일한 씨드로 경쟁하는 Daily Challenge 모드 추가

### 새 파일
- `app/lib/screens/daily_challenge_screen.dart`

### 변경 파일
- `app/lib/models/user_data.dart`
- `app/lib/services/storage_service.dart`
- `app/lib/screens/main_menu_screen.dart`

### 구현 내용

#### 2.1 UserData 모델 확장 (`user_data.dart`)

**새 필드:**
```dart
int? lastDailyChallengeSeed;    // 마지막 플레이한 Daily Challenge 씨드
int dailyChallengeHighScore;     // 오늘의 최고 점수
int dailyChallengePlays;         // 오늘 플레이 횟수
```

**새 메서드:**
```dart
static int getTodaysSeed()       // 오늘의 씨드 생성 (년*10000 + 월*100 + 일)
bool get isNewDailyChallenge     // 새 날인지 확인
bool get hasPlayedTodaysChallenge // 오늘 플레이 여부
```

#### 2.2 StorageService 확장 (`storage_service.dart`)

**새 메서드:**
```dart
Future<bool> recordDailyChallengeScore(int score)
// Daily Challenge 점수 기록, 새 최고 기록이면 true 반환

Future<Map<String, dynamic>> getDailyChallengeStats()
// 오늘의 통계 반환: {played, plays, highScore, seed}
```

#### 2.3 메인 메뉴 화면 수정 (`main_menu_screen.dart`)

**변경 사항:**
- PLAY 버튼 아래에 DAILY CHALLENGE 버튼 추가
- 그라데이션 색상: #FF6B6B → #FF8E53 (오렌지-레드)
- 오늘의 최고 점수 배지 표시
- 화면 복귀 시 통계 새로고침

#### 2.4 Daily Challenge 전용 화면 (`daily_challenge_screen.dart`)

**헤더 구성:**
| 요소 | 설명 |
|------|------|
| DAILY 배지 | 날짜 표시 (예: DAILY 2/5) |
| 오늘의 최고 점수 | 🏆 아이콘과 함께 표시 |
| 현재 점수 | 중앙에 크게 표시 |
| 코인 | 우측에 표시 |
| 메뉴 버튼 | 일시정지 |

**하단 컨트롤:**
| 요소 | 설명 |
|------|------|
| PLAYS | 오늘 플레이 횟수 |
| AD | 광고 시청 (+111 코인) |
| Shuffle | 블록 교환 (120 코인) |
| Hammer | 블록 제거 (100 코인) |

**게임 오버 화면:**
- DAILY CHALLENGE 배지
- NEW BEST! 표시 (신기록 시)
- 큰 점수 표시
- Today's Best 표시
- Plays today 표시
- TRY AGAIN / SHARE 버튼
- MAIN MENU 링크

**일시정지 화면:**
- DAILY CHALLENGE 배지
- 현재 점수
- Today's Best 표시
- RESUME 버튼
- RESTART / SHARE 버튼
- MAIN MENU 링크

---

## 3. 기타 정리

### 제거된 미사용 import
- `app/lib/widgets/score_display.dart`: `share_plus`, `colors.dart` 제거

---

## 4. 테스트 확인

### Flutter Analyze 결과
- Daily Challenge 관련 파일: **No issues found**
- 기존 warning은 이전부터 존재하던 것으로 이번 작업과 무관

---

## 5. 파일 변경 요약

| 파일 | 변경 유형 | 설명 |
|------|----------|------|
| `game_screen.dart` | 수정 | Share 기능 추가 |
| `score_display.dart` | 수정 | 미사용 import 제거 |
| `daily_challenge_screen.dart` | 신규 | Daily Challenge 전용 화면 |
| `user_data.dart` | 수정 | Daily Challenge 필드 추가 |
| `storage_service.dart` | 수정 | Daily Challenge 메서드 추가 |
| `main_menu_screen.dart` | 수정 | Daily Challenge 버튼 추가 |

---

## 6. 향후 개선 사항 (미구현)

1. **Daily Challenge 전용 랭킹**
   - 현재는 일반 랭킹에 함께 제출됨
   - Daily 전용 Firestore 컬렉션 분리 권장

2. **Daily Challenge 보상**
   - 첫 플레이 보너스 코인
   - 신기록 달성 보너스

3. **Daily Challenge 알림**
   - 새 Daily Challenge 시작 알림
   - 푸시 알림 연동

4. **AdMob 프로덕션 ID**
   - `ad_service.dart`의 빈 프로덕션 ID 설정 필요

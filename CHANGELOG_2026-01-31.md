# 작업 내역서 (2026-01-31)

## 커밋 정보
- **커밋 해시**: `151cc9b`
- **브랜치**: `main`
- **커밋 메시지**: Fix bugs and implement missing features

---

## 수정된 버그

### 1. 게임오버 후 재시작 시 바로 게임오버 화면 표시되는 버그
**파일**: `app/lib/screens/game_screen.dart`

**원인**:
- `didChangeDependencies`에서 `newGame()` 호출 후에도 같은 빌드 프레임에서 Consumer가 이전 상태(`isGameOver=true`)로 빌드됨

**해결**:
```dart
// 점수가 0보다 클 때만 진짜 게임오버로 판단
final shouldShowGameOver = gameState.isGameOver && gameState.score > 0;
```

---

## 구현된 기능

### 2. Shuffle 기능 (화면 하단 세번째 버튼)
**파일**:
- `app/lib/config/constants.dart`
- `app/lib/models/game_state.dart`
- `app/lib/screens/game_screen.dart`

**기능**: 현재 블록과 다음 블록을 교환
**비용**: 120 코인

```dart
// game_state.dart
bool shuffle() {
  if (_coins < GameConstants.shuffleCost) return false;
  if (_currentBlock == null || _nextBlock == null) return false;

  _coins -= GameConstants.shuffleCost;

  // Swap current and next blocks
  final temp = _currentBlock;
  _currentBlock = _nextBlock;
  _nextBlock = temp;

  notifyListeners();
  return true;
}
```

### 3. Undo 기능 (우상단 세번째 아이콘)
**파일**: `app/lib/models/game_state.dart`

**기능**: 마지막 수를 되돌림 (1회만 가능)

```dart
// 상태 저장 변수
List<List<Block?>>? _savedBoard;
Block? _savedCurrentBlock;
Block? _savedNextBlock;
int _savedScore = 0;
int _savedCoins = 0;

// 블록 드롭 전 상태 저장
void _saveState() {
  _savedBoard = /* deep copy */;
  _savedCurrentBlock = _currentBlock?.copyWith();
  _savedNextBlock = _nextBlock?.copyWith();
  _savedScore = _score;
  _savedCoins = _coins;
  _canUndo = true;
}

// 되돌리기
void undo() {
  if (!_canUndo || _savedBoard == null) return;
  // 저장된 상태로 복원
  _board = /* restore */;
  _currentBlock = _savedCurrentBlock;
  _score = _savedScore;
  _coins = _savedCoins;
  _isGameOver = false;
  _canUndo = false;
  notifyListeners();
}
```

### 4. Leaderboard 버튼 (우상단 두번째 아이콘)
**파일**: `app/lib/widgets/score_display.dart`

**기능**: 게임 일시정지 후 랭킹 화면으로 이동

```dart
_buildIconButton(
  Icons.leaderboard,
  onTap: () {
    gameState.pause();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RankingScreen()),
    ).then((_) => gameState.resume());
  },
),
```

### 5. Share 버튼 (우상단 네번째 아이콘)
**파일**:
- `app/lib/widgets/score_display.dart`
- `app/pubspec.yaml` (share_plus 패키지 추가)

**기능**: 점수와 시드를 공유

```dart
_buildIconButton(
  Icons.share,
  onTap: () {
    Share.share(
      'I scored ${gameState.score} points in Number Drop! Can you beat me? 🎮\nSeed: ${gameState.gameSeed}',
    );
  },
),
```

---

## Battle 시스템 수정

### 6. odiserId → userId 필드명 수정
**파일**:
- `app/lib/models/battle.dart`
- `app/lib/services/battle_service.dart`
- `app/lib/screens/matchmaking_screen.dart`

**변경**: 오타인 `odiserId`를 `userId`로 일괄 변경

### 7. Transaction 내 Realtime DB 호출 문제 수정
**파일**: `app/lib/services/battle_service.dart`

**원인**: Firestore transaction 내에서 Realtime Database 호출 시 규칙 위반

**해결**: Transaction 완료 후 Realtime Database 호출
```dart
final result = await _firestore.runTransaction<Battle?>((transaction) async {
  // ... Firestore 작업
});

// Transaction 외부에서 Realtime DB 호출
if (result != null) {
  await _liveScoresRef.child(battleId).child(userId).set({...});
}
```

### 8. 오래된 배틀 필터링 추가
**파일**: `app/lib/services/battle_service.dart`

**변경**: 5분 이상 된 waiting 상태 배틀은 매칭에서 제외

```dart
final cutoffTime = DateTime.now().subtract(const Duration(minutes: 5));

final query = await _battlesRef
    .where('status', isEqualTo: BattleStatus.waiting.name)
    .where('createdAt', isGreaterThan: Timestamp.fromDate(cutoffTime))
    .orderBy('createdAt', descending: false)
    .limit(10)
    .get();
```

---

## 변경된 파일 목록

| 파일 | 변경 내용 |
|------|----------|
| `app/lib/config/constants.dart` | `shuffleCost = 120` 추가 |
| `app/lib/models/battle.dart` | `odiserId` → `userId` 변경 |
| `app/lib/models/game_state.dart` | Shuffle, Undo 기능 구현 |
| `app/lib/screens/battle_screen.dart` | 메인메뉴 이동 시 newGame() 호출 |
| `app/lib/screens/game_screen.dart` | 게임오버 버그 수정, Shuffle 피드백 |
| `app/lib/screens/matchmaking_screen.dart` | `odiserId` → `userId` 변경 |
| `app/lib/services/battle_service.dart` | Transaction 수정, 오래된 배틀 필터링 |
| `app/lib/widgets/score_display.dart` | Leaderboard, Share 버튼 연결 |
| `app/pubspec.yaml` | `share_plus: ^7.2.2` 추가 |

---

## Firebase 설정 필요사항

### Firestore 복합 인덱스
Firebase Console → Firestore → 인덱스 탭에서 생성:

| Collection | Fields | Query scope |
|------------|--------|-------------|
| `battles` | `status` (Asc), `createdAt` (Asc) | Collection |

---

## 빌드 명령어

```bash
cd app

# 웹 빌드
flutter build web --release

# Android APK 빌드
flutter build apk --release
```

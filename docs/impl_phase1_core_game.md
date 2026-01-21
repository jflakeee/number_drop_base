# Phase 1: 기본 게임 구현

## 개요
- **목표**: 핵심 게임플레이 구현 (MVP)
- **범위**: 게임 보드, 블록, 드롭, 합체 로직

---

## 구현 체크리스트

### 1.1 프로젝트 설정
- [ ] Flutter 프로젝트 생성
- [ ] 폴더 구조 설정 (lib/, config/, models/, screens/, widgets/, services/)
- [ ] pubspec.yaml 의존성 추가
- [ ] 기본 테마 설정

### 1.2 모델 클래스
- [ ] `Block` 모델 생성
  - [ ] value (int): 블록 숫자 값
  - [ ] row (int): 행 위치
  - [ ] column (int): 열 위치
  - [ ] id (String): 고유 식별자
  - [ ] color getter: 숫자별 색상 반환
- [ ] `GameState` 모델 생성
  - [ ] board (List<List<Block?>>): 5x8 그리드
  - [ ] score (int): 현재 점수
  - [ ] highScore (int): 최고 점수
  - [ ] currentBlock (Block): 현재 드롭 블록
  - [ ] nextBlock (Block): 다음 블록
  - [ ] isGameOver (bool): 게임 오버 상태
  - [ ] previousState (GameState?): 되돌리기용

### 1.3 색상 설정
- [ ] `GameColors` 클래스 생성
- [ ] 숫자별 색상 매핑 (2~4096+)
  - [ ] 2: #E91E63
  - [ ] 4: #4DD0E1
  - [ ] 8: #26C6DA
  - [ ] 16: #7E57C2
  - [ ] 32: #FF7043
  - [ ] 64: #66BB6A
  - [ ] 128: #78909C
  - [ ] 256: #EC407A
  - [ ] 512: #66BB6A
  - [ ] 1024: #90A4AE
  - [ ] 2048: #FF9800
  - [ ] 4096+: 그라데이션

### 1.4 게임 보드 UI
- [ ] `GameBoard` 위젯 생성
- [ ] 5열 x 8행 그리드 레이아웃
- [ ] 배경색 설정 (#2D2D2D)
- [ ] 열 구분선 표시
- [ ] 반응형 크기 조절

### 1.5 블록 위젯
- [ ] `BlockWidget` 위젯 생성
- [ ] 숫자 표시 (중앙 정렬, Bold)
- [ ] 배경 색상 (숫자별)
- [ ] 둥근 모서리 (radius: 8-12px)
- [ ] 그림자 효과

### 1.6 블록 드롭 메커니즘
- [ ] 열 탭 감지 (GestureDetector)
- [ ] 드롭 위치 계산 (해당 열의 가장 아래 빈 칸)
- [ ] 블록 배치 로직
- [ ] 다음 블록 생성

### 1.7 합체 로직
- [ ] `GameLogic` 서비스 생성
- [ ] 인접 블록 검사 (BFS/DFS)
- [ ] 같은 숫자 블록 찾기
- [ ] 블록 합체 실행
- [ ] 새 블록 생성 (2배 값)
- [ ] 중력 적용 (위 블록 아래로)
- [ ] 연쇄 합체 처리

### 1.8 점수 시스템
- [ ] 합체 시 점수 추가 (합쳐진 숫자 = 점수)
- [ ] 현재 점수 표시
- [ ] 최고 점수 갱신 로직

### 1.9 게임 오버
- [ ] 게임 오버 조건 검사 (상단 도달)
- [ ] 게임 오버 상태 설정
- [ ] 게임 오버 UI 표시

---

## 테스트 체크리스트 (Playwright)

### T1.1 프로젝트 설정 테스트
- [ ] 앱 빌드 성공 확인
- [ ] 메인 화면 로드 확인
- [ ] 스크린샷 캡처

### T1.2 게임 보드 테스트
- [ ] 5x8 그리드 렌더링 확인
- [ ] 배경색 확인
- [ ] 열 구분선 표시 확인
- [ ] 스크린샷: `test_game_board.png`

### T1.3 블록 위젯 테스트
- [ ] 블록 숫자 표시 확인
- [ ] 숫자별 색상 확인 (2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048)
- [ ] 둥근 모서리 확인
- [ ] 스크린샷: `test_block_colors.png`

### T1.4 블록 드롭 테스트
- [ ] 열 탭 시 블록 드롭 확인
- [ ] 올바른 위치에 착지 확인
- [ ] 연속 드롭 테스트
- [ ] 스크린샷: `test_block_drop.png`

### T1.5 합체 로직 테스트
- [ ] 같은 숫자 2개 합체 확인 (4+4=8)
- [ ] 같은 숫자 3개 이상 합체 확인
- [ ] 연쇄 합체 확인
- [ ] 점수 증가 확인
- [ ] 스크린샷: `test_merge.png`

### T1.6 게임 오버 테스트
- [ ] 블록이 상단 도달 시 게임 오버 확인
- [ ] 게임 오버 UI 표시 확인
- [ ] 스크린샷: `test_game_over.png`

---

## Playwright 테스트 코드 예시

```javascript
// tests/phase1_core_game.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Phase 1: Core Game', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:3000'); // Flutter web or emulator
  });

  test('T1.2 Game board renders correctly', async ({ page }) => {
    // 게임 보드 존재 확인
    const gameBoard = page.locator('[data-testid="game-board"]');
    await expect(gameBoard).toBeVisible();

    // 5열 확인
    const columns = page.locator('[data-testid="column"]');
    await expect(columns).toHaveCount(5);

    await page.screenshot({ path: 'test_game_board.png' });
  });

  test('T1.4 Block drops on column tap', async ({ page }) => {
    // 첫 번째 열 클릭
    await page.locator('[data-testid="column-0"]').click();

    // 블록이 해당 열에 존재하는지 확인
    const block = page.locator('[data-testid="block-0-7"]'); // row 7, col 0
    await expect(block).toBeVisible();

    await page.screenshot({ path: 'test_block_drop.png' });
  });

  test('T1.5 Blocks merge correctly', async ({ page }) => {
    // 같은 열에 같은 숫자 드롭하여 합체 테스트
    await page.locator('[data-testid="column-0"]').click();
    await page.waitForTimeout(500);
    await page.locator('[data-testid="column-0"]').click();

    // 합체 후 점수 확인
    const score = page.locator('[data-testid="score"]');
    await expect(score).not.toHaveText('0');

    await page.screenshot({ path: 'test_merge.png' });
  });
});
```

---

## 완료 기준
- [ ] 모든 구현 체크리스트 완료
- [ ] 모든 테스트 통과
- [ ] 코드 리뷰 완료

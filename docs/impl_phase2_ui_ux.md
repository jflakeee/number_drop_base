# Phase 2: UI/UX 구현

## 개요
- **목표**: 완성도 높은 사용자 인터페이스 구현
- **범위**: 메인 메뉴, 상단/하단 UI, 미리보기, 드롭 그림자

---

## 구현 체크리스트

### 2.1 메인 메뉴 화면
- [ ] `MainMenuScreen` 생성
- [ ] 상단 코인 표시
- [ ] 설정 버튼 (톱니바퀴)
- [ ] 게임 로고/타이틀
- [ ] 최고 점수 표시 (왕관 아이콘)
- [ ] 게임 시작 버튼
- [ ] 하단 메뉴 버튼들

### 2.2 게임 화면 상단 UI
- [ ] 코인 표시 (좌측)
  - [ ] 파란 배경
  - [ ] 노란 코인 아이콘
  - [ ] + 버튼 (코인 구매)
- [ ] 점수 표시 (중앙)
  - [ ] 현재 점수 (큰 글씨)
  - [ ] 최고 점수 (작은 글씨, 왕관 아이콘)
- [ ] 랭킹 표시 (우측)
  - [ ] 국기/지구본 아이콘
  - [ ] #순위 숫자

### 2.3 게임 화면 버튼
- [ ] 되돌리기 버튼 (좌측)
- [ ] 친구 초대 버튼 (좌측)
- [ ] 프리미엄 버튼 (우측)
- [ ] 메뉴 버튼 (우측, 햄버거)

### 2.4 블록 미리보기 영역
- [ ] `NextBlockPreview` 위젯 생성
- [ ] 현재 블록 표시 (큰 크기)
- [ ] 다음 블록 표시 (작은 크기)
- [ ] 블록 색상 적용

### 2.5 드롭 그림자 표시
- [ ] 드롭 예정 위치 계산
- [ ] 반투명 그림자 블록 표시
- [ ] 실시간 열 추적 (드래그 시)

### 2.6 게임 화면 하단 UI
- [ ] 마스코트 캐릭터 (좌측)
  - [ ] 코인 진행바 (예: 830/5,000)
- [ ] 아이템 버튼들
  - [ ] 광고 보상 버튼 (+코인)
  - [ ] 부스트 아이템 버튼
  - [ ] 망치 아이템 버튼

### 2.7 게임 오버 화면
- [ ] `GameOverScreen` 생성
- [ ] "GAME OVER" 텍스트
- [ ] 최종 점수 표시
- [ ] 최고 점수 표시
- [ ] 다시 하기 버튼
- [ ] 메인 메뉴 버튼
- [ ] 광고 시청으로 이어하기 버튼

### 2.8 설정 화면
- [ ] `SettingsScreen` 생성
- [ ] 사운드 ON/OFF 토글
- [ ] 진동 ON/OFF 토글
- [ ] 게임 초기화 버튼
- [ ] 버전 정보

### 2.9 상점 화면
- [ ] `ShopScreen` 생성
- [ ] 코인 패키지 목록
- [ ] 광고 제거 상품
- [ ] 가격 표시
- [ ] 구매 버튼

---

## 테스트 체크리스트 (Playwright)

### T2.1 메인 메뉴 테스트
- [ ] 메인 메뉴 화면 로드 확인
- [ ] 코인 표시 확인
- [ ] 최고 점수 표시 확인
- [ ] 게임 시작 버튼 클릭 → 게임 화면 전환 확인
- [ ] 스크린샷: `test_main_menu.png`

### T2.2 상단 UI 테스트
- [ ] 코인 표시 확인
- [ ] 점수 표시 확인 (초기값 0)
- [ ] 최고 점수 표시 확인
- [ ] 스크린샷: `test_top_ui.png`

### T2.3 블록 미리보기 테스트
- [ ] 현재 블록 미리보기 표시 확인
- [ ] 다음 블록 미리보기 표시 확인
- [ ] 블록 드롭 후 미리보기 갱신 확인
- [ ] 스크린샷: `test_block_preview.png`

### T2.4 드롭 그림자 테스트
- [ ] 열 호버 시 그림자 표시 확인
- [ ] 그림자 위치 정확성 확인
- [ ] 스크린샷: `test_drop_shadow.png`

### T2.5 하단 UI 테스트
- [ ] 마스코트 표시 확인
- [ ] 아이템 버튼 표시 확인
- [ ] 버튼 클릭 반응 확인
- [ ] 스크린샷: `test_bottom_ui.png`

### T2.6 게임 오버 화면 테스트
- [ ] 게임 오버 시 화면 전환 확인
- [ ] 점수 표시 확인
- [ ] 다시 하기 버튼 동작 확인
- [ ] 메인 메뉴 버튼 동작 확인
- [ ] 스크린샷: `test_game_over_screen.png`

### T2.7 설정 화면 테스트
- [ ] 설정 버튼 클릭 → 설정 화면 전환 확인
- [ ] 사운드 토글 동작 확인
- [ ] 진동 토글 동작 확인
- [ ] 스크린샷: `test_settings.png`

### T2.8 상점 화면 테스트
- [ ] 상점 화면 로드 확인
- [ ] 상품 목록 표시 확인
- [ ] 가격 표시 확인
- [ ] 스크린샷: `test_shop.png`

---

## Playwright 테스트 코드 예시

```javascript
// tests/phase2_ui_ux.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Phase 2: UI/UX', () => {
  test('T2.1 Main menu loads correctly', async ({ page }) => {
    await page.goto('http://localhost:3000');

    // 메인 메뉴 요소 확인
    await expect(page.locator('[data-testid="coin-display"]')).toBeVisible();
    await expect(page.locator('[data-testid="high-score"]')).toBeVisible();
    await expect(page.locator('[data-testid="start-button"]')).toBeVisible();

    await page.screenshot({ path: 'test_main_menu.png' });
  });

  test('T2.1 Start button navigates to game', async ({ page }) => {
    await page.goto('http://localhost:3000');

    // 게임 시작 버튼 클릭
    await page.locator('[data-testid="start-button"]').click();

    // 게임 화면으로 전환 확인
    await expect(page.locator('[data-testid="game-board"]')).toBeVisible();
  });

  test('T2.3 Block preview updates after drop', async ({ page }) => {
    await page.goto('http://localhost:3000/game');

    // 현재 블록 값 저장
    const currentBlock = await page.locator('[data-testid="current-block"]').textContent();

    // 블록 드롭
    await page.locator('[data-testid="column-0"]').click();
    await page.waitForTimeout(500);

    // 미리보기 갱신 확인 (현재 블록이 변경됨)
    const newCurrentBlock = await page.locator('[data-testid="current-block"]').textContent();
    expect(newCurrentBlock).not.toBe(currentBlock);

    await page.screenshot({ path: 'test_block_preview.png' });
  });

  test('T2.6 Game over screen appears', async ({ page }) => {
    await page.goto('http://localhost:3000/game?test=gameover');

    // 게임 오버 화면 확인
    await expect(page.locator('[data-testid="game-over-title"]')).toBeVisible();
    await expect(page.locator('[data-testid="final-score"]')).toBeVisible();
    await expect(page.locator('[data-testid="retry-button"]')).toBeVisible();

    await page.screenshot({ path: 'test_game_over_screen.png' });
  });
});
```

---

## 완료 기준
- [ ] 모든 구현 체크리스트 완료
- [ ] 모든 테스트 통과
- [ ] 원본 게임과 UI 비교 검증
- [ ] 코드 리뷰 완료

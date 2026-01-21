# Phase 4: 추가 기능 구현

## 개요
- **목표**: 게임 완성도를 높이는 추가 기능
- **범위**: 되돌리기, 아이템, 코인, 저장, 사운드

---

## 구현 체크리스트

### 4.1 되돌리기 (Undo) 기능
- [ ] 이전 상태 저장 로직
- [ ] 되돌리기 버튼 UI
- [ ] 상태 복원 로직
- [ ] 사용 횟수 제한 (1회 or 무제한)
- [ ] 코인 소비 로직 (선택적)
- [ ] 되돌리기 불가 상태 표시

### 4.2 망치 아이템
- [ ] 망치 버튼 UI
- [ ] 망치 모드 활성화 (블록 선택 대기)
- [ ] 블록 탭 시 제거
- [ ] 제거 후 중력 적용
- [ ] 코인 소비 로직 (100코인)
- [ ] 망치 아이템 사용 애니메이션
- [ ] 망치 모드 취소 기능

### 4.3 코인 시스템
- [ ] 코인 모델/상태 관리
- [ ] 코인 획득 로직
  - [ ] 게임 플레이 (점수 기반)
  - [ ] 일일 보너스
  - [ ] 광고 시청
  - [ ] 인앱 결제
- [ ] 코인 소비 로직
  - [ ] 아이템 구매
- [ ] 코인 표시 UI
- [ ] 코인 부족 알림

### 4.4 데이터 저장 (로컬)
- [ ] SharedPreferences 서비스 생성
- [ ] 저장 항목:
  - [ ] 최고 점수
  - [ ] 코인 잔액
  - [ ] 설정 (사운드, 진동)
  - [ ] 일일 보너스 수령 여부
  - [ ] 광고 제거 여부
- [ ] 앱 시작 시 데이터 로드
- [ ] 게임 종료 시 데이터 저장

### 4.5 사운드 효과
- [ ] AudioService 생성
- [ ] 사운드 파일 준비
  - [ ] 블록 드롭 사운드
  - [ ] 블록 합체 사운드
  - [ ] 게임 오버 사운드
  - [ ] 버튼 클릭 사운드
  - [ ] 코인 획득 사운드
  - [ ] 아이템 사용 사운드
- [ ] 사운드 ON/OFF 설정
- [ ] 배경 음악 (선택적)

### 4.6 진동 피드백
- [ ] Haptic feedback 구현
- [ ] 진동 트리거:
  - [ ] 블록 드롭 시
  - [ ] 블록 합체 시
  - [ ] 게임 오버 시
- [ ] 진동 ON/OFF 설정

### 4.7 일일 보너스
- [ ] 일일 보너스 팝업
- [ ] 보너스 코인 지급 (예: 100코인)
- [ ] 24시간 쿨다운
- [ ] 광고 시청 시 2배 보너스

### 4.8 마스코트 진행바
- [ ] 마스코트 캐릭터 UI
- [ ] 코인 진행바 (예: 830/5,000)
- [ ] 목표 달성 시 보상
- [ ] 진행바 애니메이션

### 4.9 콤보 시스템 (신규 발견)
- [ ] 연쇄 합체 카운트 로직
- [ ] 콤보 배지 UI (빨간 방패 + 골드 리본)
- [ ] 콤보 횟수별 코인 보상
  - [ ] 2-3 콤보: +1 코인
  - [ ] 4-5 콤보: +2 코인
  - [ ] 6+ 콤보: +3 코인
- [ ] 콤보 상태 관리

### 4.10 목표 시스템 (신규 발견)
- [ ] 게임 시작 목표 팝업
- [ ] 목표 블록 설정 (512 → 1024 → 2048 → 4096)
- [ ] 목표 달성 감지 로직
- [ ] 목표 달성 보상 지급
- [ ] 다음 목표 자동 갱신

### 4.11 랭크업 시스템 (신규 발견)
- [ ] 랭크업 조건 정의 (점수/블록 기반)
- [ ] "Rank Up" 배너 UI
- [ ] 랭크업 보상 (코인 대량 지급)
- [ ] 순위 갱신 로직

### 4.12 마스코트 상태 시스템 (신규 발견)
- [ ] 일반 상태 (평상시)
- [ ] 경고 상태 (블록이 높을 때 빨간 느낌표)
- [ ] 광고 준비 상태 (재생 버튼)
- [ ] 상태별 UI 변경

### 4.13 드롭 그림자 시스템 (신규 발견)
- [ ] 터치/호버 시 열 감지
- [ ] 해당 열 전체에 반투명 오버레이
- [ ] 착지 예정 위치 표시
- [ ] 실시간 위치 업데이트

---

## 테스트 체크리스트 (Playwright)

### T4.1 되돌리기 기능 테스트
- [ ] 되돌리기 버튼 표시 확인
- [ ] 블록 드롭 후 되돌리기 → 이전 상태 복원 확인
- [ ] 점수 복원 확인
- [ ] 사용 횟수 제한 확인
- [ ] 스크린샷: `test_undo.png`

### T4.2 망치 아이템 테스트
- [ ] 망치 버튼 표시 확인
- [ ] 망치 버튼 클릭 → 망치 모드 활성화 확인
- [ ] 블록 탭 → 블록 제거 확인
- [ ] 중력 적용 확인
- [ ] 코인 차감 확인
- [ ] 스크린샷: `test_hammer.png`

### T4.3 코인 시스템 테스트
- [ ] 초기 코인 표시 확인
- [ ] 게임 플레이 후 코인 획득 확인
- [ ] 아이템 사용 후 코인 차감 확인
- [ ] 코인 부족 시 알림 확인
- [ ] 스크린샷: `test_coins.png`

### T4.4 데이터 저장 테스트
- [ ] 게임 플레이 후 앱 종료
- [ ] 앱 재시작 후 최고 점수 유지 확인
- [ ] 코인 잔액 유지 확인
- [ ] 설정 유지 확인

### T4.5 사운드 효과 테스트
- [ ] 블록 드롭 시 사운드 재생 확인
- [ ] 합체 시 사운드 재생 확인
- [ ] 사운드 OFF 설정 후 무음 확인

### T4.6 진동 피드백 테스트
- [ ] 블록 드롭 시 진동 발생 확인 (실제 기기)
- [ ] 진동 OFF 설정 후 무진동 확인

### T4.7 일일 보너스 테스트
- [ ] 앱 첫 실행 시 일일 보너스 팝업 확인
- [ ] 보너스 수령 후 코인 증가 확인
- [ ] 24시간 내 재수령 불가 확인
- [ ] 스크린샷: `test_daily_bonus.png`

### T4.8 마스코트 진행바 테스트
- [ ] 마스코트 표시 확인
- [ ] 진행바 표시 확인
- [ ] 코인 획득 시 진행바 증가 확인
- [ ] 스크린샷: `test_mascot.png`

---

## Playwright 테스트 코드 예시

```javascript
// tests/phase4_features.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Phase 4: Features', () => {
  test('T4.1 Undo functionality', async ({ page }) => {
    await page.goto('http://localhost:3000/game');

    // 초기 점수 저장
    const initialScore = await page.locator('[data-testid="score"]').textContent();

    // 블록 드롭
    await page.locator('[data-testid="column-0"]').click();
    await page.waitForTimeout(500);

    // 점수 변경 확인
    const newScore = await page.locator('[data-testid="score"]').textContent();

    // 되돌리기 클릭
    await page.locator('[data-testid="undo-button"]').click();
    await page.waitForTimeout(300);

    // 점수 복원 확인
    const restoredScore = await page.locator('[data-testid="score"]').textContent();
    expect(restoredScore).toBe(initialScore);

    await page.screenshot({ path: 'test_undo.png' });
  });

  test('T4.2 Hammer item removes block', async ({ page }) => {
    await page.goto('http://localhost:3000/game?test=blocks');

    // 초기 코인 저장
    const initialCoins = await page.locator('[data-testid="coins"]').textContent();

    // 망치 버튼 클릭
    await page.locator('[data-testid="hammer-button"]').click();

    // 블록 클릭하여 제거
    await page.locator('[data-testid="block-0-7"]').click();
    await page.waitForTimeout(300);

    // 블록 제거 확인
    await expect(page.locator('[data-testid="block-0-7"]')).not.toBeVisible();

    // 코인 차감 확인
    const newCoins = await page.locator('[data-testid="coins"]').textContent();
    expect(parseInt(newCoins)).toBeLessThan(parseInt(initialCoins));

    await page.screenshot({ path: 'test_hammer.png' });
  });

  test('T4.3 Coins increase after game play', async ({ page }) => {
    await page.goto('http://localhost:3000/game');

    // 초기 코인 저장
    const initialCoins = parseInt(await page.locator('[data-testid="coins"]').textContent());

    // 게임 플레이 (합체 발생)
    await page.locator('[data-testid="column-0"]').click();
    await page.waitForTimeout(300);
    await page.locator('[data-testid="column-0"]').click();
    await page.waitForTimeout(500);

    // 게임 종료 후 코인 확인
    // (게임 오버 또는 일정 점수 달성 시 코인 획득)

    await page.screenshot({ path: 'test_coins.png' });
  });

  test('T4.4 Data persistence', async ({ page, context }) => {
    // 첫 번째 세션
    await page.goto('http://localhost:3000/game');
    await page.locator('[data-testid="column-0"]').click();
    await page.waitForTimeout(1000);

    const score = await page.locator('[data-testid="score"]').textContent();

    // 페이지 새로고침 (앱 재시작 시뮬레이션)
    await page.reload();

    // 데이터 유지 확인
    const highScore = await page.locator('[data-testid="high-score"]').textContent();
    expect(parseInt(highScore)).toBeGreaterThanOrEqual(parseInt(score));
  });

  test('T4.7 Daily bonus popup', async ({ page }) => {
    // 로컬 스토리지 초기화 (첫 실행 시뮬레이션)
    await page.goto('http://localhost:3000');
    await page.evaluate(() => localStorage.clear());
    await page.reload();

    // 일일 보너스 팝업 확인
    const bonusPopup = page.locator('[data-testid="daily-bonus-popup"]');
    await expect(bonusPopup).toBeVisible();

    // 수령 버튼 클릭
    await page.locator('[data-testid="claim-bonus"]').click();

    // 팝업 닫힘 확인
    await expect(bonusPopup).not.toBeVisible();

    await page.screenshot({ path: 'test_daily_bonus.png' });
  });
});
```

---

## 완료 기준
- [ ] 모든 구현 체크리스트 완료
- [ ] 모든 테스트 통과
- [ ] 데이터 저장/로드 정상 동작
- [ ] 사운드/진동 정상 동작
- [ ] 코드 리뷰 완료

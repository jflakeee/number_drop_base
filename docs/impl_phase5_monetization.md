# Phase 5: 수익화 구현

## 개요
- **목표**: 광고 및 인앱 결제를 통한 수익화
- **범위**: AdMob 연동, 보상형 광고, 인앱 결제, 상점

---

## 구현 체크리스트

### 5.1 Google AdMob 설정
- [ ] AdMob 계정 생성/설정
- [ ] 앱 등록 (Android)
- [ ] 광고 단위 생성
  - [ ] 보상형 광고 단위
  - [ ] 배너 광고 단위 (선택적)
- [ ] google_mobile_ads 패키지 추가
- [ ] AndroidManifest.xml 설정
- [ ] AdMob 앱 ID 설정

### 5.2 AdService 구현
- [ ] `AdService` 클래스 생성
- [ ] 초기화 로직
- [ ] 보상형 광고 로드
- [ ] 보상형 광고 표시
- [ ] 광고 콜백 처리
  - [ ] onAdLoaded
  - [ ] onAdFailedToLoad
  - [ ] onAdOpened
  - [ ] onAdClosed
  - [ ] onUserEarnedReward
- [ ] 광고 재로드 로직

### 5.3 보상형 광고 위치
- [ ] 하단 광고 버튼 (+코인)
  - [ ] 버튼 UI (영상 아이콘 + 보상 표시)
  - [ ] 클릭 → 광고 재생 → 코인 지급
  - [ ] 쿨다운 타이머 (선택적)
- [ ] 게임 오버 이어하기
  - [ ] "광고 시청하고 이어하기" 버튼
  - [ ] 광고 시청 → 게임 재개
  - [ ] 1회 제한
- [ ] 일일 보너스 2배
  - [ ] "광고 시청하고 2배 받기" 버튼
  - [ ] 광고 시청 → 보너스 2배 지급
- [ ] 무료 아이템
  - [ ] "광고 시청하고 망치 받기" 버튼
  - [ ] 광고 시청 → 아이템 지급

### 5.4 Google Play Billing 설정
- [ ] Google Play Console 설정
- [ ] 인앱 상품 등록
  - [ ] 코인 팩 S (consumable)
  - [ ] 코인 팩 M (consumable)
  - [ ] 코인 팩 L (consumable)
  - [ ] 광고 제거 (non-consumable)
  - [ ] 스타터 팩 (consumable)
- [ ] in_app_purchase 패키지 추가

### 5.5 PurchaseService 구현
- [ ] `PurchaseService` 클래스 생성
- [ ] 초기화 및 연결
- [ ] 상품 목록 조회
- [ ] 구매 처리
- [ ] 구매 완료 콜백
- [ ] 구매 복원 (광고 제거)
- [ ] 영수증 검증 (선택적)

### 5.6 상점 화면
- [ ] `ShopScreen` UI
- [ ] 코인 패키지 목록
  - [ ] 상품명
  - [ ] 코인 양
  - [ ] 가격
  - [ ] 구매 버튼
- [ ] 광고 제거 상품
- [ ] 스타터 팩 (신규 유저용)
- [ ] 구매 진행 중 로딩 표시
- [ ] 구매 완료/실패 알림

### 5.7 광고 제거 기능
- [ ] 광고 제거 구매 상태 저장
- [ ] 광고 제거 시:
  - [ ] 보상형 광고 버튼 숨김
  - [ ] 배너 광고 숨김 (있는 경우)
  - [ ] "광고 없음" 뱃지 표시
- [ ] 구매 복원 기능

### 5.8 코인 패키지 처리
- [ ] 구매 완료 시 코인 추가
- [ ] 코인 추가 애니메이션
- [ ] 구매 내역 기록 (선택적)

---

## 테스트 체크리스트 (Playwright)

### T5.1 AdMob 초기화 테스트
- [ ] 앱 시작 시 AdMob 초기화 확인
- [ ] 초기화 성공 로그 확인

### T5.2 보상형 광고 로드 테스트
- [ ] 광고 로드 성공 확인
- [ ] 광고 로드 실패 시 재시도 확인
- [ ] 테스트 광고 ID 사용 확인

### T5.3 보상형 광고 표시 테스트
- [ ] 광고 버튼 클릭 → 광고 표시 확인
- [ ] 광고 시청 완료 → 보상 지급 확인
- [ ] 광고 닫기 → 정상 복귀 확인
- [ ] 스크린샷: `test_rewarded_ad.png`

### T5.4 게임 오버 이어하기 테스트
- [ ] 게임 오버 시 "이어하기" 버튼 표시 확인
- [ ] 광고 시청 후 게임 재개 확인
- [ ] 1회 제한 확인
- [ ] 스크린샷: `test_continue_ad.png`

### T5.5 상점 화면 테스트
- [ ] 상점 화면 로드 확인
- [ ] 상품 목록 표시 확인
- [ ] 가격 표시 확인
- [ ] 스크린샷: `test_shop_screen.png`

### T5.6 인앱 결제 테스트 (테스트 환경)
- [ ] 상품 조회 성공 확인
- [ ] 테스트 구매 플로우 확인
- [ ] 구매 완료 후 코인 추가 확인
- [ ] 스크린샷: `test_purchase.png`

### T5.7 광고 제거 테스트
- [ ] 광고 제거 구매 후 광고 버튼 숨김 확인
- [ ] 앱 재시작 후 광고 제거 유지 확인
- [ ] 구매 복원 기능 확인

### T5.8 코인 부족 시 상점 연결 테스트
- [ ] 코인 부족 상태에서 아이템 사용 시도
- [ ] "코인 부족" 알림 + 상점 이동 버튼 확인
- [ ] 상점 이동 확인

---

## Playwright 테스트 코드 예시

```javascript
// tests/phase5_monetization.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Phase 5: Monetization', () => {
  test('T5.3 Rewarded ad button shows reward', async ({ page }) => {
    await page.goto('http://localhost:3000/game');

    // 초기 코인 저장
    const initialCoins = parseInt(await page.locator('[data-testid="coins"]').textContent());

    // 광고 버튼 확인
    const adButton = page.locator('[data-testid="rewarded-ad-button"]');
    await expect(adButton).toBeVisible();

    // 보상 표시 확인 (+100 등)
    await expect(adButton).toContainText('+');

    await page.screenshot({ path: 'test_rewarded_ad.png' });
  });

  test('T5.4 Continue with ad after game over', async ({ page }) => {
    await page.goto('http://localhost:3000/game?test=gameover');

    // 게임 오버 화면 확인
    await expect(page.locator('[data-testid="game-over-title"]')).toBeVisible();

    // 이어하기 버튼 확인
    const continueButton = page.locator('[data-testid="continue-with-ad"]');
    await expect(continueButton).toBeVisible();

    await page.screenshot({ path: 'test_continue_ad.png' });
  });

  test('T5.5 Shop screen displays products', async ({ page }) => {
    await page.goto('http://localhost:3000/shop');

    // 상점 화면 확인
    await expect(page.locator('[data-testid="shop-title"]')).toBeVisible();

    // 상품 목록 확인
    const products = page.locator('[data-testid="product-item"]');
    await expect(products).toHaveCount(5); // 5개 상품

    // 가격 표시 확인
    await expect(page.locator('[data-testid="product-price"]').first()).toContainText('$');

    await page.screenshot({ path: 'test_shop_screen.png' });
  });

  test('T5.7 Ad removal hides ad buttons', async ({ page }) => {
    // 광고 제거 구매 완료 상태 시뮬레이션
    await page.goto('http://localhost:3000/game');
    await page.evaluate(() => {
      localStorage.setItem('ad_removed', 'true');
    });
    await page.reload();

    // 광고 버튼 숨김 확인
    const adButton = page.locator('[data-testid="rewarded-ad-button"]');
    await expect(adButton).not.toBeVisible();
  });

  test('T5.8 Insufficient coins shows shop prompt', async ({ page }) => {
    // 코인 0 상태 설정
    await page.goto('http://localhost:3000/game');
    await page.evaluate(() => {
      localStorage.setItem('coins', '0');
    });
    await page.reload();

    // 망치 버튼 클릭 (100코인 필요)
    await page.locator('[data-testid="hammer-button"]').click();

    // 코인 부족 알림 확인
    const alert = page.locator('[data-testid="insufficient-coins-alert"]');
    await expect(alert).toBeVisible();

    // 상점 이동 버튼 확인
    await expect(page.locator('[data-testid="go-to-shop"]')).toBeVisible();
  });
});
```

---

## 광고 테스트 ID (개발용)

```dart
// 테스트용 광고 ID (실제 배포 시 실제 ID로 교체)
class AdTestIds {
  // Android
  static const String rewardedAd = 'ca-app-pub-3940256099942544/5224354917';
  static const String bannerAd = 'ca-app-pub-3940256099942544/6300978111';
}
```

---

## 완료 기준
- [ ] 모든 구현 체크리스트 완료
- [ ] 모든 테스트 통과
- [ ] 테스트 광고 정상 동작
- [ ] 테스트 결제 정상 동작
- [ ] 광고 제거 기능 정상 동작
- [ ] 코드 리뷰 완료

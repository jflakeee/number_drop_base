# Phase 6: 완성도 및 배포

## 개요
- **목표**: 앱 완성도 향상 및 Android 배포 준비
- **범위**: UI 다듬기, 앱 아이콘, 스플래시, 최적화, 빌드

---

## 구현 체크리스트

### 6.1 스플래시 화면
- [ ] 스플래시 이미지 디자인
- [ ] flutter_native_splash 패키지 사용
- [ ] 로고 중앙 표시
- [ ] 배경색 설정 (#2D2D2D)
- [ ] 로딩 애니메이션 (선택적)
- [ ] 2초 후 메인 메뉴로 전환

### 6.2 앱 아이콘
- [ ] 앱 아이콘 디자인 (512x512)
- [ ] flutter_launcher_icons 패키지 사용
- [ ] Android 적응형 아이콘
- [ ] 다양한 해상도 생성

### 6.3 앱 이름 및 패키지
- [ ] 앱 이름 설정 (표시명)
- [ ] 패키지 이름 설정 (com.yourcompany.numberdrop)
- [ ] 버전 코드/이름 설정

### 6.4 UI 다듬기
- [ ] 전체 UI 일관성 검토
- [ ] 폰트 통일
- [ ] 아이콘 통일
- [ ] 색상 팔레트 검토
- [ ] 여백/패딩 조정
- [ ] 반응형 레이아웃 검토

### 6.5 성능 최적화
- [ ] 불필요한 리빌드 제거
- [ ] 이미지 최적화
- [ ] 메모리 누수 확인
- [ ] 앱 시작 시간 최적화
- [ ] 프레임 드롭 확인

### 6.6 버그 수정
- [ ] 전체 기능 테스트
- [ ] 엣지 케이스 처리
- [ ] 에러 핸들링
- [ ] 크래시 수정

### 6.7 다국어 지원 (선택적)
- [ ] 한국어
- [ ] 영어
- [ ] 일본어

### 6.8 Android 빌드 설정
- [ ] build.gradle 설정
  - [ ] minSdkVersion (21+)
  - [ ] targetSdkVersion (34)
  - [ ] compileSdkVersion
- [ ] ProGuard 설정
- [ ] 서명 키 생성
- [ ] 릴리스 빌드 설정

### 6.9 APK/AAB 빌드
- [ ] 디버그 APK 빌드 테스트
- [ ] 릴리스 APK 빌드
- [ ] AAB (Android App Bundle) 빌드
- [ ] APK 크기 최적화

### 6.10 Google Play 준비
- [ ] 스토어 등록 정보 준비
  - [ ] 앱 제목
  - [ ] 짧은 설명
  - [ ] 긴 설명
  - [ ] 카테고리 (퍼즐)
- [ ] 스크린샷 준비 (최소 2장)
- [ ] 피처 그래픽 (1024x500)
- [ ] 개인정보처리방침 URL
- [ ] 앱 등급 설정

---

## 테스트 체크리스트 (Playwright)

### T6.1 스플래시 화면 테스트
- [ ] 앱 시작 시 스플래시 표시 확인
- [ ] 로고 표시 확인
- [ ] 메인 메뉴 전환 확인
- [ ] 스크린샷: `test_splash.png`

### T6.2 앱 아이콘 테스트
- [ ] 앱 아이콘 표시 확인 (런처)
- [ ] 다양한 크기에서 선명도 확인
- [ ] 스크린샷: `test_app_icon.png`

### T6.3 전체 UI 테스트
- [ ] 모든 화면 스크린샷 캡처
- [ ] 원본 게임과 비교
- [ ] UI 일관성 확인
- [ ] 스크린샷 폴더: `test_ui_screenshots/`

### T6.4 성능 테스트
- [ ] 앱 시작 시간 측정 (목표: 3초 이내)
- [ ] FPS 측정 (목표: 60fps)
- [ ] 메모리 사용량 측정
- [ ] 1시간 연속 플레이 안정성 테스트

### T6.5 다양한 해상도 테스트
- [ ] 1080x1920 (FHD)
- [ ] 1440x2560 (QHD)
- [ ] 720x1280 (HD)
- [ ] 태블릿 해상도

### T6.6 다양한 Android 버전 테스트
- [ ] Android 8.0 (API 26)
- [ ] Android 10 (API 29)
- [ ] Android 12 (API 31)
- [ ] Android 14 (API 34)

### T6.7 릴리스 빌드 테스트
- [ ] 릴리스 APK 설치 테스트
- [ ] 모든 기능 동작 확인
- [ ] 광고 동작 확인
- [ ] 결제 동작 확인

### T6.8 전체 E2E 테스트
- [ ] 신규 유저 플로우 테스트
  - [ ] 앱 설치 → 스플래시 → 메인 메뉴 → 게임 시작
  - [ ] 게임 플레이 → 게임 오버 → 점수 저장
  - [ ] 일일 보너스 수령
  - [ ] 아이템 사용
- [ ] 재방문 유저 플로우 테스트
  - [ ] 앱 시작 → 데이터 로드 확인
  - [ ] 최고 점수 유지 확인
  - [ ] 코인 유지 확인

---

## Playwright 테스트 코드 예시

```javascript
// tests/phase6_polish.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Phase 6: Polish & Release', () => {
  test('T6.1 Splash screen displays', async ({ page }) => {
    await page.goto('http://localhost:3000');

    // 스플래시 화면 확인
    const splash = page.locator('[data-testid="splash-screen"]');
    await expect(splash).toBeVisible();

    // 로고 확인
    await expect(page.locator('[data-testid="splash-logo"]')).toBeVisible();

    await page.screenshot({ path: 'test_splash.png' });

    // 메인 메뉴로 전환 대기
    await page.waitForSelector('[data-testid="main-menu"]', { timeout: 5000 });
  });

  test('T6.4 App startup time', async ({ page }) => {
    const startTime = Date.now();

    await page.goto('http://localhost:3000');
    await page.waitForSelector('[data-testid="main-menu"]');

    const loadTime = Date.now() - startTime;
    console.log(`App startup time: ${loadTime}ms`);

    // 3초 이내 로드
    expect(loadTime).toBeLessThan(3000);
  });

  test('T6.4 Performance - 60fps', async ({ page }) => {
    await page.goto('http://localhost:3000/game');

    // 5초간 게임 플레이 시뮬레이션
    for (let i = 0; i < 10; i++) {
      await page.locator(`[data-testid="column-${i % 5}"]`).click();
      await page.waitForTimeout(500);
    }

    // FPS 측정
    const fps = await page.evaluate(() => {
      return new Promise(resolve => {
        let frames = 0;
        const startTime = performance.now();
        function count() {
          frames++;
          if (performance.now() - startTime < 1000) {
            requestAnimationFrame(count);
          } else {
            resolve(frames);
          }
        }
        requestAnimationFrame(count);
      });
    });

    console.log(`FPS: ${fps}`);
    expect(fps).toBeGreaterThan(55);
  });

  test('T6.5 Responsive layout - FHD', async ({ page }) => {
    await page.setViewportSize({ width: 1080, height: 1920 });
    await page.goto('http://localhost:3000/game');

    await page.screenshot({ path: 'test_ui_screenshots/fhd.png' });
  });

  test('T6.5 Responsive layout - HD', async ({ page }) => {
    await page.setViewportSize({ width: 720, height: 1280 });
    await page.goto('http://localhost:3000/game');

    await page.screenshot({ path: 'test_ui_screenshots/hd.png' });
  });

  test('T6.8 Full E2E - New user flow', async ({ page }) => {
    // 로컬 스토리지 초기화 (신규 유저)
    await page.goto('http://localhost:3000');
    await page.evaluate(() => localStorage.clear());
    await page.reload();

    // 스플래시 → 메인 메뉴
    await page.waitForSelector('[data-testid="main-menu"]', { timeout: 5000 });

    // 일일 보너스 팝업
    const bonusPopup = page.locator('[data-testid="daily-bonus-popup"]');
    if (await bonusPopup.isVisible()) {
      await page.locator('[data-testid="claim-bonus"]').click();
    }

    // 게임 시작
    await page.locator('[data-testid="start-button"]').click();
    await expect(page.locator('[data-testid="game-board"]')).toBeVisible();

    // 게임 플레이
    for (let i = 0; i < 20; i++) {
      await page.locator(`[data-testid="column-${i % 5}"]`).click();
      await page.waitForTimeout(300);
    }

    // 점수 확인
    const score = await page.locator('[data-testid="score"]').textContent();
    expect(parseInt(score)).toBeGreaterThan(0);

    console.log('E2E Test completed successfully');
  });
});
```

---

## 빌드 명령어

```bash
# 디버그 APK 빌드
flutter build apk --debug

# 릴리스 APK 빌드
flutter build apk --release

# AAB 빌드 (Google Play용)
flutter build appbundle --release

# APK 크기 분석
flutter build apk --analyze-size
```

---

## 체크리스트 요약

### 배포 전 최종 확인
- [ ] 모든 Phase 완료
- [ ] 모든 테스트 통과
- [ ] 성능 목표 달성 (60fps, 3초 시작)
- [ ] 크래시 없음
- [ ] 광고 ID 실제 ID로 교체
- [ ] 서명 키 안전 보관
- [ ] 버전 번호 설정

---

## 완료 기준
- [ ] 모든 구현 체크리스트 완료
- [ ] 모든 테스트 통과
- [ ] 릴리스 APK/AAB 생성
- [ ] 실제 기기 테스트 완료
- [ ] Google Play 등록 정보 준비
- [ ] 최종 코드 리뷰 완료

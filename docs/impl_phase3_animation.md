# Phase 3: 애니메이션 구현

## 개요
- **목표**: 부드럽고 시각적으로 만족스러운 애니메이션
- **범위**: 블록 드롭, 합체, 점수 팝업, 특수 효과

---

## 구현 체크리스트

### 3.1 블록 드롭 애니메이션
- [ ] `AnimatedPositioned` 또는 `TweenAnimationBuilder` 사용
- [ ] 시작 위치: 미리보기 영역
- [ ] 종료 위치: 착지 위치
- [ ] Duration: 200-300ms
- [ ] Curve: `Curves.easeOutQuad` 또는 `Curves.bounceOut`
- [ ] 착지 시 약간의 바운스 효과

### 3.2 드롭 예정 그림자 애니메이션
- [ ] 열 선택 시 그림자 페이드인
- [ ] 그림자 투명도: 30%
- [ ] 펄스(pulse) 애니메이션 (선택적)

### 3.3 합체 애니메이션
- [ ] Phase 1: 블록들이 중앙으로 이동 (100ms)
- [ ] Phase 2: 스케일 확대 (1.0 → 1.2) (75ms)
- [ ] Phase 3: 스케일 축소 (1.2 → 1.0) (75ms)
- [ ] Phase 4: 새 블록 출현 + 색상 전환
- [ ] 합체되는 블록 페이드아웃

### 3.4 점수 팝업 애니메이션
- [ ] 합체 위치에서 시작
- [ ] Y축 -50px 이동
- [ ] 페이드 아웃 (1.0 → 0.0)
- [ ] Duration: 500ms
- [ ] 폰트: Bold, 점수 색상

### 3.5 연쇄 콤보 효과
- [ ] 연쇄 횟수 표시 (x2, x3...)
- [ ] 콤보 텍스트 애니메이션
- [ ] 화면 흔들림 효과 (선택적)
- [ ] 배경 플래시 효과

### 3.6 2048 블록 특수 효과
- [ ] 왕관 아이콘 추가
- [ ] 테두리 글로우 효과
- [ ] 반짝임 파티클 애니메이션
- [ ] 색상: 골든 오렌지 (#FF9800)

### 3.7 4096+ 블록 특수 효과
- [ ] 그라데이션 배경
- [ ] 무지개 글로우 효과
- [ ] 별 파티클 애니메이션

### 3.8 게임 오버 애니메이션
- [ ] 보드 어둡게 페이드
- [ ] "GAME OVER" 텍스트 줌인
- [ ] 버튼 순차적 페이드인

### 3.9 중력 애니메이션
- [ ] 합체 후 위 블록들이 아래로 떨어지는 애니메이션
- [ ] 자연스러운 낙하 효과
- [ ] Duration: 150ms per row

### 3.10 UI 전환 애니메이션
- [ ] 화면 전환 슬라이드/페이드
- [ ] 버튼 호버/탭 효과
- [ ] 팝업 등장/퇴장 애니메이션

### 3.11 콤보 시스템 애니메이션 (신규)
- [ ] 콤보 배지 등장 (scale bounce)
- [ ] 빨간 방패 배지 + 골드 리본
- [ ] 숫자 카운트업 애니메이션
- [ ] 별/반짝이 파티클 효과
- [ ] 코인 "+2" 팝업 + 떨어지는 애니메이션

### 3.12 목표 시스템 애니메이션 (신규)
- [ ] 게임 시작 목표 팝업 등장
- [ ] 목표 블록 광택/반짝임 효과
- [ ] 목표 달성 시 축하 애니메이션
- [ ] 다음 목표 전환 애니메이션

### 3.13 랭크업 애니메이션 (신규)
- [ ] "Rank Up" 배너 슬라이드 인
- [ ] 코인 폭발/쏟아지는 애니메이션
- [ ] 별 이펙트
- [ ] 순위 숫자 변경 애니메이션

### 3.14 마스코트 애니메이션 (신규)
- [ ] 마스코트 아이들 애니메이션 (미세한 움직임)
- [ ] 경고 상태 빨간 느낌표 깜빡임
- [ ] 광고 타이머 카운트다운
- [ ] 광고 완료 시 코인 획득 애니메이션

### 3.15 드롭 그림자 애니메이션 (신규)
- [ ] 열 선택 시 그림자 페이드인
- [ ] 그림자 영역 펄스 효과 (선택적)
- [ ] 터치 이동 시 실시간 그림자 이동

---

## 테스트 체크리스트 (Playwright)

### T3.1 블록 드롭 애니메이션 테스트
- [ ] 드롭 시 애니메이션 발생 확인
- [ ] 애니메이션 시간 측정 (200-300ms)
- [ ] 최종 위치 정확성 확인
- [ ] 비디오 녹화: `test_drop_animation.webm`

### T3.2 합체 애니메이션 테스트
- [ ] 합체 시 애니메이션 발생 확인
- [ ] 스케일 변화 확인
- [ ] 색상 전환 확인
- [ ] 비디오 녹화: `test_merge_animation.webm`

### T3.3 점수 팝업 애니메이션 테스트
- [ ] 합체 시 점수 팝업 출현 확인
- [ ] 위로 이동 + 페이드아웃 확인
- [ ] 비디오 녹화: `test_score_popup.webm`

### T3.4 연쇄 콤보 효과 테스트
- [ ] 연쇄 발생 시 콤보 표시 확인
- [ ] 콤보 횟수 정확성 확인
- [ ] 비디오 녹화: `test_combo_effect.webm`

### T3.5 2048 블록 특수 효과 테스트
- [ ] 2048 블록 생성 시 특수 효과 확인
- [ ] 왕관 아이콘 표시 확인
- [ ] 글로우 효과 확인
- [ ] 스크린샷: `test_2048_effect.png`

### T3.6 게임 오버 애니메이션 테스트
- [ ] 게임 오버 시 애니메이션 확인
- [ ] 순차적 요소 등장 확인
- [ ] 비디오 녹화: `test_gameover_animation.webm`

### T3.7 중력 애니메이션 테스트
- [ ] 합체 후 블록 낙하 애니메이션 확인
- [ ] 낙하 순서 정확성 확인
- [ ] 비디오 녹화: `test_gravity_animation.webm`

### T3.8 전체 애니메이션 성능 테스트
- [ ] FPS 측정 (목표: 60fps)
- [ ] 애니메이션 끊김 없음 확인
- [ ] 메모리 사용량 확인

---

## Playwright 테스트 코드 예시

```javascript
// tests/phase3_animation.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Phase 3: Animation', () => {
  test('T3.1 Block drop animation', async ({ page }) => {
    await page.goto('http://localhost:3000/game');

    // 비디오 녹화 시작
    await page.video().path();

    // 블록 드롭
    const startTime = Date.now();
    await page.locator('[data-testid="column-2"]').click();

    // 애니메이션 완료 대기
    await page.waitForSelector('[data-testid="block-2-7"]', { state: 'visible' });
    const endTime = Date.now();

    // 애니메이션 시간 확인 (200-400ms 범위)
    const animationTime = endTime - startTime;
    expect(animationTime).toBeGreaterThan(150);
    expect(animationTime).toBeLessThan(500);
  });

  test('T3.2 Merge animation', async ({ page }) => {
    await page.goto('http://localhost:3000/game?test=merge');

    // 같은 숫자 2개 배치된 상태에서 시작
    await page.locator('[data-testid="column-0"]').click();
    await page.waitForTimeout(300);

    // 합체 애니메이션 확인
    const mergedBlock = page.locator('[data-testid="merged-block"]');
    await expect(mergedBlock).toBeVisible();

    // 스케일 애니메이션 확인 (CSS transform)
    const transform = await mergedBlock.evaluate(el =>
      window.getComputedStyle(el).transform
    );
    console.log('Transform during animation:', transform);
  });

  test('T3.3 Score popup animation', async ({ page }) => {
    await page.goto('http://localhost:3000/game?test=merge');

    await page.locator('[data-testid="column-0"]').click();

    // 점수 팝업 확인
    const scorePopup = page.locator('[data-testid="score-popup"]');
    await expect(scorePopup).toBeVisible();

    // 500ms 후 사라짐 확인
    await page.waitForTimeout(600);
    await expect(scorePopup).not.toBeVisible();
  });

  test('T3.8 Animation performance - 60fps', async ({ page }) => {
    await page.goto('http://localhost:3000/game');

    // FPS 측정
    const fps = await page.evaluate(() => {
      return new Promise(resolve => {
        let frames = 0;
        const startTime = performance.now();

        function countFrame() {
          frames++;
          if (performance.now() - startTime < 1000) {
            requestAnimationFrame(countFrame);
          } else {
            resolve(frames);
          }
        }
        requestAnimationFrame(countFrame);
      });
    });

    console.log(`FPS: ${fps}`);
    expect(fps).toBeGreaterThan(55); // 최소 55fps
  });
});
```

---

## 완료 기준
- [ ] 모든 구현 체크리스트 완료
- [ ] 모든 테스트 통과
- [ ] 60fps 유지 확인
- [ ] 원본 게임과 애니메이션 비교 검증
- [ ] 코드 리뷰 완료

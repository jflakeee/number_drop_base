# Changelog - 2026-02-01

## 설정 시스템 구현 (Comprehensive Settings System)

### 개요
Number Drop Clone 게임에 사용자 정의 가능한 설정 시스템을 구현했습니다. 애니메이션 속도, Easing 커브, 병합 효과, 블록 테마 등을 조정할 수 있습니다.

---

## 신규 파일

### 1. 설정 모델 (`lib/config/game_settings.dart`)
- **EasingType** 열거형 (5종)
  - gravity (중력): 가속 낙하
  - magnet (자석): 끌림 + 튕김
  - cotton (솜): 부드러운 감속
  - metal (금속): 일정 속도
  - jelly (젤리): 바운스

- **MergeAnimationType** 열거형 (8종)
  - jelly (젤리): 늘어났다 줄어듦
  - water (물): 파동 효과
  - fire (불): 타오르는 효과
  - metalSpark (금속충돌불꽃): 금속 스파크
  - electricSpark (전기스파크): 번개 효과
  - iceShatter (얼음부서짐): 파편 흩어짐
  - lightScatter (빛산란): 방사형 빛
  - gemSparkle (보석반짝임): 난반사 효과

- **BlockTheme** 열거형 (9종)
  - classic (클래식): 기본 색상
  - metal (금속): 메탈릭 광택
  - gem (보석): 반짝이는 보석
  - glass (유리): 투명 유리
  - gravel (자갈): 거친 돌
  - wood (나무): 따뜻한 나무결
  - soil (흙): 흙색 톤
  - water (물): 유동적 물
  - fire (불): 타오르는 불꽃

- **GameSettings** 클래스
  - 애니메이션 속도: dropDuration, mergeDuration, mergeMoveDuration, gravityDuration
  - 게임플레이 옵션: allowDropDuringMerge, showGhostBlock, screenShakeEnabled
  - JSON 직렬화/역직렬화 지원

### 2. 설정 서비스 (`lib/services/settings_service.dart`)
- 싱글톤 패턴 (`SettingsService.instance`)
- ChangeNotifier 상속 (UI 반응형 업데이트)
- SharedPreferences 연동 (설정 영속화)
- 개별 setter 메서드 제공

### 3. 블록 테마 (`lib/config/block_themes.dart`)
- **BlockThemeData** 클래스
  - 블록 값별 색상 맵
  - 그라데이션 지원
  - 효과 플래그: hasGlow, hasReflection, opacity

- **BlockThemes** 컬렉션
  - 9개 테마별 색상 데이터 정의
  - getTheme(BlockTheme) 팩토리 메서드

### 4. Easing 커브 (`lib/animations/easing_curves.dart`)
- **GameEasings** 클래스
  - getCurve(EasingType): 드롭 애니메이션 커브
  - getDropCurve(), getMergeCurve(), getGravityCurve()
- **MagnetCurve**: 커스텀 overshoot 커브
- **ShakeCurve**: 화면 흔들림 커브

### 5. 병합 효과 (`lib/animations/merge_effects/`)
| 파일 | 효과 | 설명 |
|------|------|------|
| base_effect.dart | MergeEffect | 추상 베이스 클래스 |
| jelly_effect.dart | JellyEffect | Scale 바운스 |
| water_effect.dart | WaterEffect | 파동 CustomPainter |
| fire_effect.dart | FireEffect | 파티클 + 그라데이션 |
| spark_effects.dart | MetalSparkEffect, ElectricSparkEffect | 불꽃/번개 파티클 |
| ice_effect.dart | IceShatterEffect | 파편 파티클 |
| light_effects.dart | LightScatterEffect, GemSparkleEffect | 빛 산란/반짝임 |
| merge_effect_factory.dart | MergeEffectFactory | 효과 생성 팩토리 |

---

## 수정 파일

### 1. `lib/main.dart`
- SettingsService 초기화 추가
```dart
await SettingsService.instance.init();
```

### 2. `lib/screens/settings_screen.dart`
- **GAMEPLAY 섹션** 추가
  - Drop Speed 슬라이더 (0~1000ms)
  - Merge Speed 슬라이더 (0~1000ms)
  - Gravity Speed 슬라이더 (0~1000ms)
  - Ghost Block Preview 토글
  - Screen Shake 토글
  - Allow Drop During Merge 토글

- **ANIMATION 섹션** 추가
  - Easing Style 드롭다운 (5종)
  - Merge Effect 드롭다운 (8종)

- **THEME 섹션** 추가
  - Block Theme 버튼 그룹 (9종)

- Reset Settings 버튼 추가

### 3. `lib/widgets/animated_game_board.dart`
- 화면 흔들림 AnimationController 추가
- SettingsService에서 동적으로 duration 참조
- allowDropDuringMerge 설정 적용
- Easing 커브 동적 적용

### 4. `lib/widgets/animated_block_widget.dart`
- BlockThemes.getTheme() 사용하여 테마 색상 적용
- SettingsService에서 애니메이션 duration 참조

### 5. `lib/widgets/block_widget.dart`
- 테마 색상 적용 (프리뷰 블록)
```dart
final themeData = BlockThemes.getTheme(SettingsService.instance.blockTheme);
final themeColor = themeData.getColor(block.value);
```

### 6. `CLAUDE.md`
- 설정 시스템 관련 정보 추가

---

## 커밋 정보

```
d35f973 Implement comprehensive settings system with themes and animations
- 18개 파일 변경
- 2,614줄 추가
- 275줄 삭제
```

---

## 다음 단계 (선택 사항)

### Phase 4: 추가 기능
- [ ] 테마별 사운드 팩 구현
- [ ] 파티클 시스템 고도화
- [ ] 특수 블록 (폭탄, 와일드카드)
- [ ] 업적 시스템

### 테스트 필요
- [ ] 각 테마별 색상 확인
- [ ] 애니메이션 속도 조절 테스트
- [ ] Easing 커브별 시각적 차이 확인
- [ ] 병합 효과 애니메이션 테스트

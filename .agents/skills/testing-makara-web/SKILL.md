---
name: testing-makara-web
description: Test the Makara premium productivity app on Flutter Web. Use when verifying UI, navigation, or feature changes.
---

# Testing Makara Web App

## Build & Serve

```bash
cd /home/ubuntu/makara_premium_app
flutter build web --release
cd build/web && python3 -m http.server 8080 &
```

Then open `http://localhost:8080` in Chrome.

## App Structure

- **Splash screen**: 4.5s animation showing "UNREAL ENGINE 5" + "by Makara", then auto-transitions to home
- **Bottom nav** (5 tabs): Alarm (រោទ៍), Timer (កម្មវិធីកំណត់ពេល), Sleep (សម្រាកដេក), Study (ការសិក្សា), Chat (AI ជំនួយ)
- **Drawer** (swipe from left edge): Reminders, Insights, Settings — accessible via hamburger icon or swipe
- **Theme**: Dark (default), Light, System — controlled via Settings screen

## Known Web Issues

- **Drawer may be unreachable on web**: Due to nested Scaffolds (each screen has its own `Scaffold` inside `HomeScreen`'s `Scaffold`), the swipe gesture to open the drawer might not work in browsers. If this is still broken, Settings/Reminders/Insights screens will be blocked. A fix would be adding a `leading` hamburger icon to the inner AppBars.
- **Camera/ML Kit**: Not available on web. The snooze challenge screen shows a fallback message "មុខងារកាមេរ៉ាមិនអាចប្រើបានលើ Web" with a dismiss button.
- **Biometric auth**: `isAvailable` returns `false` on web, `authenticate()` auto-passes. The biometric toggle in Settings is disabled.
- **Audio playback**: Sleep sounds toggle UI state but actual audio playback requires audio asset files in `assets/sounds/`.

## Key Test Flows

1. **Timer**: Change preset (15/25/30/45/60), start, verify countdown, pause, reset
2. **Chat**: Type message, press Enter, verify demo response appears (no API key needed)
3. **Study**: Toggle session completion, switch between Today/Tomorrow tabs
4. **Alarm**: Click "+" to add alarm, verify time picker opens, confirm adds to list
5. **Sleep**: Click sound tile to toggle highlight state
6. **Settings** (if drawer works): Switch theme Dark→Light, verify background color changes

## Devin Secrets Needed

None required for basic testing. The chat runs in demo mode without a Gemini API key.

Optional for full functionality:
- `GEMINI_API_KEY` — for real AI chat responses
- Firebase config — for FCM/push notifications
- Telegram Bot Token — for admin broadcast notifications

## Lint & Test Commands

```bash
flutter analyze --no-fatal-infos
flutter test
flutter build web --release
```

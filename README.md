# ម៉ាការ៉ា — Makara Premium App

A premium, minimalist productivity & alarm application built with Flutter, designed with a monochromatic aesthetic and full Khmer language support.

**Made with Unreal Engine 5 by Makara**

---

## Features

### 🔔 Advanced Alarm with Snooze Challenge
- Smart alarm with eye-tracking and smile detection
- Uses Google ML Kit Face Detection via device camera
- Alarm stops only when the app detects open eyes AND a smile
- Requires consecutive successful detections for reliability

### ⏱ Focus Timer
- Sleek circular countdown timer for focus sessions
- Preset durations: 15, 25, 30, 45, 60 minutes
- Elegant progress ring animation

### 🌙 Sleep Sanctuary
- Background sleep sounds: Rain, Ocean, Forest, White Noise, Fireplace, Night Ambient
- Configurable sleep timer (15-90 minutes)
- Designed for background playback with screen locked

### 📚 Study Management (Khmer)
- **រំលឹកម៉ោងរៀន** (Study Reminders) — track daily study sessions
- **កាលវិភាគសម្រាប់រៀនថ្ងៃស្អែក** (Tomorrow's Study Schedule) — plan ahead
- Tab-based Today / Tomorrow views
- Add sessions with subject, time, duration, and notes

### 🤖 Gemini AI Chat
- Integrated chat interface for study help and general queries
- Conversational memory within session
- Demo mode when API key is not configured

### 📊 Productivity Insights
- Weekly study hours bar chart
- Focus time line chart
- Sleep quality tracking
- Study streak counter

### 🔐 Biometric Lock (FaceID)
- Optional FaceID/fingerprint lock for app access
- Toggle in Settings

### 📱 iOS Widget Support
- Widget service for Home Screen widgets
- Shows next alarm and study schedule
- Swift WidgetKit template included

### 📢 Telegram Admin Notifications
- Telegram Bot → Firebase Cloud Messaging (FCM) integration
- Admin sends `/broadcast Title | Body` via Telegram
- All app users receive push notification

### 🎨 Premium Design
- Monochromatic color palette (high contrast black/white)
- System / Dark / Light mode support
- Battambang Khmer font throughout
- Elegant animations via flutter_animate
- Cinematic splash screen with UE5 branding

---

## Architecture

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── app_strings.dart          # Full Khmer localization
│   ├── theme/
│   │   └── app_theme.dart            # Dark & Light themes
│   ├── providers/
│   │   └── theme_provider.dart       # Theme state management
│   └── services/
│       ├── biometric_service.dart     # FaceID/biometric auth
│       ├── notification_service.dart  # Local notifications
│       ├── storage_service.dart       # SQLite database
│       ├── fcm_telegram_service.dart  # Telegram→FCM bridge
│       └── widget_service.dart        # iOS Widget data
├── features/
│   ├── alarm/
│   │   ├── screens/
│   │   │   ├── alarm_screen.dart
│   │   │   └── snooze_challenge_screen.dart
│   │   └── services/
│   │       └── face_detection_service.dart  # ML Kit eye/smile detection
│   ├── timer/screens/timer_screen.dart
│   ├── sleep/screens/sleep_screen.dart
│   ├── study/
│   │   ├── screens/study_screen.dart
│   │   └── models/study_session.dart
│   ├── reminders/
│   │   ├── screens/reminders_screen.dart
│   │   └── models/reminder.dart
│   ├── insights/screens/insights_screen.dart
│   ├── chat/
│   │   ├── screens/chat_screen.dart
│   │   └── services/gemini_service.dart
│   ├── settings/screens/settings_screen.dart
│   ├── splash/screens/splash_screen.dart
│   └── home/home_screen.dart
└── widgets/
```

## Setup

```bash
flutter pub get
flutter run
```

### API Configuration

- **Gemini AI**: Set your API key in `GeminiService` constructor
- **Firebase**: Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- **Telegram Bot**: Configure bot token and FCM server key in `FcmTelegramService`

## Key Technologies

| Feature | Technology |
|---------|-----------|
| Face Detection | Google ML Kit |
| Camera | camera package |
| State Management | Provider |
| Local DB | SQLite (sqflite) |
| Charts | fl_chart |
| Animations | flutter_animate |
| Audio | just_audio + audio_service |
| Push Notifications | Firebase Cloud Messaging |
| Biometric Auth | local_auth |
| HTTP | http package |

## License

Proprietary — Made by Makara

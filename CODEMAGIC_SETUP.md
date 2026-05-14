# Codemagic CI/CD Setup Guide — ម៉ាការ៉ា

This guide walks you through connecting the Makara app to [Codemagic.io](https://codemagic.io) for automated building, testing, and deploying.

---

## Step 1: Connect Your Repository

1. Go to [codemagic.io](https://codemagic.io) and sign up / log in (GitHub login recommended)
2. Click **"Add application"**
3. Select **GitHub** as provider
4. Choose the **`makarachan-dotcom/Makara`** repository
5. Select **"Flutter App"** as project type
6. Choose **"codemagic.yaml"** as configuration (not the Workflow Editor)
7. Click **"Finish: Add application"**

The app will automatically detect the `codemagic.yaml` file in the repo root.

---

## Step 2: Understand the Workflows

The `codemagic.yaml` defines **3 workflows**:

| Workflow | Trigger | What it does |
|----------|---------|-------------|
| **Analyze & Test** | Every push / PR to any branch | Runs `flutter analyze` + `flutter test` |
| **Android Build** | Push to `main` or `release/*` | Builds release APK + AAB |
| **iOS Build** | Push to `main` or `release/*` | Builds signed IPA for App Store |

---

## Step 3: Run Your First Build

After connecting the repo, the **Analyze & Test** workflow runs automatically on every push.

To trigger it manually:
1. Go to your app in Codemagic dashboard
2. Click **"Start new build"**
3. Select the branch (e.g., `main`)
4. Select the workflow: **"Analyze & Test"**
5. Click **"Start new build"**

You'll see live build logs. Once it passes, you'll get a green checkmark.

---

## Step 4: Set Up Android Builds

### Basic APK Build (No signing required)
The Android workflow builds both APK and AAB automatically. The APK can be downloaded from the build artifacts without any signing setup.

### Google Play Publishing (Optional)
To auto-publish to Google Play:

1. Create a [Google Cloud Service Account](https://docs.codemagic.io/yaml-publishing/google-play/) with Google Play Developer API access
2. In Codemagic → **Teams** → **Global variables and secrets**:
   - Create a group named `google_credentials`
   - Add variable `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` with the JSON key file content
3. Uncomment the `google_play` section in `codemagic.yaml`

---

## Step 5: Set Up iOS Builds

### Prerequisites
- An [Apple Developer Account](https://developer.apple.com) ($99/year)
- Your app registered in App Store Connect

### Code Signing Setup

1. **In Codemagic** → Go to your app → **Settings** → **Integrations**
2. Click **"Connect"** next to **App Store Connect**
3. Enter your App Store Connect API Key:
   - Go to [App Store Connect → Users & Access → Keys](https://appstoreconnect.apple.com/access/api)
   - Click **"+"** to generate a new API key
   - Role: **App Manager** or **Developer**
   - Download the `.p8` file
   - Note the **Key ID** and **Issuer ID**
4. In Codemagic, enter the Key ID, Issuer ID, and upload the `.p8` file
5. Name the integration: **"Makara App Store"** (must match `codemagic.yaml`)

### Automatic Signing
Codemagic handles provisioning profiles and certificates automatically when the App Store Connect integration is set up. The `ios_signing` section in `codemagic.yaml` tells it which bundle ID to sign.

### TestFlight Publishing (Optional)
To auto-publish to TestFlight:
1. Set up App Store Connect integration (above)
2. Update `APP_STORE_APP_ID` in `codemagic.yaml` with your actual App Store app ID
3. Uncomment the `app_store_connect` publishing section in `codemagic.yaml`

---

## Step 6: Environment Variables (Optional)

If you want to use Gemini AI or Firebase in CI builds, add these in Codemagic:

1. Go to **Teams** → **Global variables and secrets**
2. Create a group (e.g., `app_secrets`)
3. Add variables:
   - `GEMINI_API_KEY` — Your Google Gemini API key
   - `FIREBASE_TOKEN` — From `firebase login:ci`
4. Add the group to the `environment.groups` list in `codemagic.yaml`

---

## Build Notifications

Email notifications are configured for `ddddcccc1060@gmail.com`. To change:
- Edit the `recipients` list under `publishing.email` in `codemagic.yaml`

You can also add Slack notifications:
```yaml
publishing:
  slack:
    channel: '#builds'
    notify_on_build_start: false
    notify:
      success: true
      failure: true
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails at `flutter pub get` | Check that `pubspec.yaml` has valid dependencies |
| iOS signing fails | Verify App Store Connect integration is set up correctly |
| Android build too slow | Increase `max_build_duration` in `codemagic.yaml` |
| Tests fail | Run `flutter test` locally first to debug |
| `flutter analyze` fails | Run `flutter analyze` locally and fix issues before pushing |

### Useful Codemagic CLI Commands

```bash
# Install Codemagic CLI tools locally (optional)
pip install codemagic-cli-tools

# Validate your codemagic.yaml
# (Codemagic validates automatically, but you can check locally)
cat codemagic.yaml | python -c "import yaml,sys; yaml.safe_load(sys.stdin.read()); print('Valid YAML')"
```

---

## Quick Reference

| Action | Where |
|--------|-------|
| View builds | [codemagic.io/apps](https://codemagic.io/apps) |
| Download artifacts | Build page → **Artifacts** tab |
| View test results | Build page → **Tests** tab |
| Manage secrets | Teams → Global variables and secrets |
| iOS signing | App settings → Integrations |

---

## Pricing Note

Codemagic offers:
- **Free tier**: 500 build minutes/month on macOS M2 (enough for testing)
- **Pay-as-you-go**: $0.095/min for macOS M2
- **Teams**: Additional features for team collaboration

For more details: [codemagic.io/pricing](https://codemagic.io/pricing)

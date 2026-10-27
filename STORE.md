# HOOPLAB store checklist

Display name: **HOOPLAB**. This is a coach tactics board, not an account product. There is no login, cloud sync, or paywall.

Support email placeholder: `support@hooplab.app` (replace before submission).

Privacy policy: `assets/privacy_policy.md`, opened in the app from 設定 → 隱私權政策.

## Permissions actually used

| Platform | Permission | Why |
| --- | --- | --- |
| Android | `INTERNET` | The 3D court loads Three.js from the network. Google Fonts may download Noto Sans TC once. |
| Android | none of camera, microphone, location, contacts, photos, storage | Share writes a temp MP4 and hands it to the system share sheet. |
| iOS | no usage-description permissions | Same. Do not add photo, camera, microphone, location, or tracking strings. |

Local plays and the “seen onboarding” flag use app-private storage (`SharedPreferences`). Nothing is uploaded.

## Screenshot checklist

Capture on a release or profile build, Traditional Chinese UI, status bar visible, no debug banner.

iPhone 6.7-inch (required): **1290 × 2796** portrait.

- Home with categories (半場戰術, 全場快攻, 底線/邊線界外, 最後5秒).
- 西班牙擋拆 on the 2D board, players placed, one drawn cut.
- 3D autoplay, front-on, both corners visible, ball in the air or net.
- System share sheet is optional; if the OS chrome hides the app, skip it and use the 3D frame instead.
- 我的戰術 with one saved play.

iPad 12.9-inch / 13-inch: **2048 × 2732** or **2064 × 2752** portrait. Same five moments. Check the court and the bottom dock are not clipped.

## First-launch path to record

1. Install fresh (or clear app data).
2. 30 秒上手 is the first screen.
3. Tap 看西班牙擋拆.
4. Tap 3D. Playback starts itself.
5. Tap 分享影片. The share sheet text is 西班牙擋拆.
6. Back out, 儲存到我的戰術, force-quit, reopen. The play is still under 我的戰術. Rename and delete it.

## Not in this build

Login, cloud sync, subscriptions, watermarks, comments, or a second language pack.

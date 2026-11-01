# digid SDK changelog

All four SDKs (Android, iOS, Flutter, Web) share one engine and one version number. Every
release is on its platform's registry: [Maven Central](https://central.sonatype.com/artifact/tz.co.digid/digid),
[Swift Package Manager](https://github.com/algolab-cloud/digid-ios),
[pub.dev](https://pub.dev/packages/digid) and [npm](https://www.npmjs.com/package/@algolab-africa/digid).
Updating never needs a new licence key.

## 0.1.3 - 2026-11-01

### All platforms
- The SDK sends its daily usage counts to digid by itself, so usage shows in the portal as it
  happens: when a licence key is applied, after each counted verification and when fingerprints
  join one, in the background. Counts only (licence, app, day, count and a random id per
  installation), never anything about the person; nothing in evaluation mode. A report that
  cannot be sent waits for the next one. Until now nothing was reported unless the app wired a
  sender, so usage went unmeasured.
- The counts are kept in the app's private storage between restarts by default: a
  `SharedPreferences` file on Android, a file in Application Support on iOS (not backed up), a
  file in the app's private storage in Flutter, `localStorage` on the web.
- `usageSender` now defaults to the digid cloud (`CloudUsageSender`, `cloudUsageSender()`); set it
  to relay the reports through your backend instead. `setUsageStore` replaces the default storage.
  `usageSender` and `setUsageStore` no longer take `null`.

### Android
- The SDK declares the `INTERNET` permission, for the usage reports.

### iOS
- A privacy manifest (`PrivacyInfo.xcprivacy`) in the framework: usage data, not linked to the
  user, no tracking. Reflect it in your App Store privacy details.
- `NidaCaptureAdapter` passes calendar time with each frame and notices a connection that
  mirrors its buffers (`isVideoMirrored`) by itself.

### Flutter
- The plugin declares `INTERNET` on Android and ships the iOS privacy manifest.

### Web
- The usage reports go to `https://digid.co.tz`: if your page has a Content Security Policy, add
  it to `connect-src`.

## 0.1.2 - 2026-11-01

### All platforms
- Back of the NIDA card: recognised in live camera frames even when its small print is too
  blurry to read. A card that is still front-up is asked to turn over, as before.
- The age and expiry checks always use the calendar date, whatever clock the camera's frames
  carry. On Android, the date of birth check could fail on every verification.

### Android
- First release on Maven Central: `tz.co.digid:digid` (models included) and
  `tz.co.digid:digid-nomodels`.
- The front of the card from one full-resolution photo, as the Flutter and web flows do:
  `NidaFrameAnalyzer.onFrameCheck` (or `checkFrame`) tells when the card is framed, and
  `session.pushStill(NidaImage.fromJpeg(…))` reads the photo. Sharper text and a sharper card
  portrait for the face match.
- `NidaFrameAnalyzer.resolutionSelector()`: 1080p analysis frames, which card text needs.
- `NidaFrameAnalyzer` passes calendar time with each frame.
- `mirrored` is documented as it is: camera frames are never mirrored, the front camera's
  included (only its preview is drawn that way). Setting it for the selfie made faces match the
  card less well.

### iOS
- `checkFrame` and `pushStill` on `NidaKycSession`, and the `FrameCheck` result: the front of
  the card from one full-resolution photo.
- `mirrored` documented as for Android.

### Flutter and Web
- The engine fixes above; no API changes.

## 0.1.1 - 2026-11-01

First public release, on npm, pub.dev and Swift Package Manager (Android followed in 0.1.2).
The packages contain compiled code only.

### Drop-in flow (Web, Flutter)
- Minimal layout by default, made to sit inside your app: a short instruction, the button and
  "Powered by digid". `theme.layout: "full"` keeps the showcase look.
- Your own pictures on the intro and the result, and optional result details: what passed, as
  Passed / To review / Failed.
- Your app owns the language: pass it in and change it at any time. The flow has no language
  switch or logo of its own.

### All platforms
- NIDA card back: recognised and read (the NIN, with or without a barcode). A back whose NIN
  matches the front is accepted on one read.
- Card and selfie: the card portrait is looked for across the whole card, and another photo of
  the front is asked for when none is found, so the face match is not skipped.
- Fingerprints (Flutter): every capture decision runs in the engine.

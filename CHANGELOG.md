# digid SDK changelog

All four SDKs (Android, iOS, Flutter, Web) share one engine and one version number. Every
release is on its platform's registry: [Maven Central](https://central.sonatype.com/artifact/tz.co.digid/digid),
[Swift Package Manager](https://github.com/algolab-cloud/digid-ios),
[pub.dev](https://pub.dev/packages/digid) and [npm](https://www.npmjs.com/package/@algolab-africa/digid).
Updating never needs a new licence key.

## 0.1.4 - 2026-11-01

### All platforms
- **Free plan support.** On the free plan every check asks digid.co.tz for a one-time
  permission before it starts, and the month's checks are counted there, when each check starts
  (an abandoned or repeated check counts too). The SDK does it by itself: creating a session (or
  a standalone card read or face compare, one permission per 30 minutes) fetches the permission
  before any work, through `checkSender` (the digid cloud by default; set it to relay through
  your backend). The request carries the licence, the app id, a random check id and the anonymous
  counter id, never images, names or ID numbers. Without a connection the check stops with
  `ConnectionRequired` (`reason: "check"`); once the month's checks are used up it stops with
  `QuotaReached`, and the next one is refused on the phone without a call. Verification starts
  again on the 1st (East Africa Time) or as soon as the product is upgraded. Other refusals carry
  the cloud's code and are kept in `lastCheckRefusal`. Paid plans keep working offline. When
  the cloud's answer is lost on the way back (the connection drops after it counted the check),
  "Try again" asks for the same check: the next session (or standalone read) within 30 minutes
  gets the same permission back and is not counted twice.
- **Connection required.** Licensed verification stops with `ConnectionRequired` until the phone
  reaches digid when a free or pay-as-you-go key is past its 7 days and 3 days of grace
  (`reason: "renewal"`), or when usage older than the plan's deadline is still unsent
  (`reason: "reports"`; 14 days on monthly plans, 10 on free and pay as you go, none for
  enterprise). It no longer falls back to evaluation mode. With no key at all the SDK is in
  evaluation mode, as before.
- **Keys renew by themselves.** Free and pay-as-you-go keys renew in the background when the
  phone is online (`renewalSender` defaults to the digid cloud), and the renewed key is kept with
  the usage counts and used at the next start. `online()` sends the reports and renews at once.
  `lastRenewalRefusal` holds the cloud's code when a renewal is refused.
- `LicenceStatus.quota` (`monthly`, `period`, `left`) and `LicenceStatus.connectionRequired`.
- Usage reports the cloud refuses are no longer dropped. Only a report for a day the cloud no
  longer takes is settled; any other refusal (the app is not registered for the licence, the
  licence is not accepted, the endpoint is wrong) keeps the report owed and is kept in
  `lastUsageRefusal` with the cloud's code (`UsageRefused`), until a report gets through.
  Timeouts, rate limits and server errors are tried again later, as before.
- Driving licence reads and face compares made on their own are counted like card reads: the
  same licence number counts once in 7 days, and a face compare right after a counted card read
  is that verification's ID check rather than a second one.
- A verification counts against the month's checks when it starts, not when its session was
  created: sessions created in advance cannot all run on the last check left.
- Checks completed while a renewal is on its way stay counted after the renewed key arrives.
- Turning the phone's clock back does not revive an expired key, and usage that went unsent for
  too long keeps verifications waiting until the phone reaches digid, even after the phone stops
  keeping the old days.
- Licences without these claims (existing monthly and enterprise keys issued before) behave as
  before.

### Web and Flutter
- The drop-in flows show "This month's checks are used up" (with the date checks start again),
  "Connect to the internet to continue" (with Try again), and "This app's licence could not be
  renewed" when the cloud refused the renewal; English and Swahili, overridable. `onError`
  receives the typed error.
- On the free plan the flows ask for the check's permission when capture starts (after the intro
  and consent), so opening the flow and leaving costs nothing. Without a connection they show
  "Connect to the internet to continue." with Try again (new string `connection_check` on the
  web, `error.connection_check.heading` in Flutter).

### Android and iOS
- `NidaKycSession.prepare()` fetches the check's permission ahead (Android: blocking, off the
  main thread; iOS: `async`); otherwise the first `pushFrame` / `pushStill` waits for it.
  `newSession` itself does no network work on Android, and starts the request in the background
  on iOS. Still reads and face compares wait for theirs too (`prepareCheck()` on iOS).

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

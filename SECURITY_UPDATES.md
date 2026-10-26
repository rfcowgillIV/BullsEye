# Security & Bug-Fix Update — October 2026

Everything changed in the `security-updates-2026` branch, and why.

## Security review result

**No security vulnerabilities found.** BullsEye makes no network calls, stores no data, and uses
no third-party libraries, so there's nothing for an attacker to reach. The changes below are bug
fixes and App Store readiness.

## 1. Score bug (the big one)

In `showAlert()`, the score was updated **before** the bonus was added:

```swift
var points = 100 - difference
score += points          // <- added here...
if difference == 0 {
    points += 100        // <- ...but the bonus came after
```

A perfect hit showed "You scored 200 points," but the score only went up by 100. Same for the +50
off-by-one bonus. **Fix:** the bonus is calculated first, then added to the score, so the alert and
the score always agree.

## 2. Other bugs

| Bug | Fix |
|---|---|
| The alert title was saved into `title`, the view controller's own screen-title property, so every round renamed the screen | Uses a local `alertTitle` constant |
| `sliderMoved` used `Int(slider.value)`, which chops decimals (49.9 → 49), while `viewDidLoad` rounded | Both round now, so dead center counts as dead center |
| The alert's closure captured `self` strongly | `[weak self]` |
| `#imageLiteral` slider images would crash if an image were renamed | `UIImage(named:)` with safe fallbacks |
| `@UIApplicationMain` is deprecated | `@main` |

## 3. App Store blocker: app icon

`AppIcon.appiconset` only had 2 of its 18 icon slots filled, and **the required 1024×1024 App Store
icon was missing**. App Store Connect rejects uploads without it. The full set of icon images was
sitting in a separate `Icons-1` folder that Xcode doesn't use as an app icon.

**Fix:** `AppIcon` now uses Xcode's single-size format (Xcode 14+), with one 1024×1024 image
copied from `Icons-1/Icon-1024.imageset`. It's RGB with no transparency, as Apple requires, and
Xcode generates every other size from it. The `Icons-1` folder was left alone and can be deleted
later.

## 4. Project settings

- **Minimum iOS version: 12.4 → 15.0.** Current Xcode no longer supports building for iOS 12.

## 5. Before resubmitting to the App Store

1. Open in the latest Xcode and accept any "Update to recommended settings" prompt.
2. Play a few rounds: hit dead center and check that the alert's points match the score increase.
3. Check that the app icon shows on the home screen in the simulator.
4. App Store requirements (2026): build with the iOS 26 SDK (current Xcode), add a privacy policy
   URL in App Store Connect, and set the App Privacy label to "Data Not Collected."

No Swift compiler was available where these changes were made, so the first Xcode build is the
real compile check.

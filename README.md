# Chicken On Fire

An iOS food-ordering app built with UIKit for the Chicken On Fire restaurant chain. Users can browse the menu, customize items, manage a basket, check out, track orders, leave reviews, and manage addresses/favourites — all backed by a REST API.

## Features

- **Menu browsing & customization** — categorized menu with item customization (extras, options) via `CustomizeViewController`
- **Basket & checkout** — add/edit items in the basket, apply vouchers, choose payment method (cash or card), and place orders
- **Order scheduling** — schedule orders for a later time
- **Addresses & locations** — save delivery addresses, pick a location on a map (Google Maps/Places), or select the nearest branch
- **User accounts & phone verification** — sign up/sign in with phone number verification, plus Facebook login
- **Favourites** — save favourite menu items for quick reordering
- **Reviews** — rate and review orders/branches
- **Vouchers & service charges** — apply discount vouchers and view service charges
- **Localization** — full English and Arabic (RTL) support
- **Side menu navigation**, in-app language switcher, and social sharing (Twitter/Instagram/Facebook)

## Tech Stack

- **Language:** Swift 5
- **UI Framework:** UIKit (Storyboards: `Main.storyboard`, `LaunchScreen.storyboard`)
- **Min iOS version:** 14.2
- **Dependency manager:** CocoaPods
- **Architecture:** Manager/API layer (`Helpers/*Manager.swift`, `APIs/*Api.swift`) feeding storyboard-based view controllers

### Dependencies (Podfile)

| Pod | Purpose |
|---|---|
| `GoogleMaps` / `GooglePlaces` | Maps, branch locations, place search |
| `FlagPhoneNumber` | Phone number input with country flag/code |
| `FBSDKLoginKit` | Facebook login |
| `ImageSlideshow` (+ `SDWebImage`) | Image carousels / remote image loading |
| `SideMenu` | Slide-out side menu navigation |
| `NicoProgress` | Loading/progress indicators |
| `CountryPickerSwift` | Country picker UI |
| `Cosmos` | Star rating control (reviews) |

## Project Structure

```
Chicken On Fire/
├── APIs/                  # Network calls to the backend (menu, orders, payments, reviews, etc.)
├── Helpers/               # Business logic / state managers (basket, orders, user account, vouchers, ...)
├── ViewControllers/       # Screen-level view controllers
├── SubViews/              # Reusable table/collection view cells and subview components
├── Widgets/               # Custom UI components (buttons, view controllers for popups, etc.)
├── Assets.xcassets/       # Images, icons, and colors
├── Base.lproj/            # Storyboards
├── en.lproj/, ar.lproj/   # Localized strings
├── AppDelegate.swift
├── SceneDelegate.swift
├── RestaurantInfoManager.swift   # App-wide config (backend URL, API key, Google API key)
└── MyExtensions.swift

Chicken On FireTests/       # Unit test target
Chicken On FireUITests/     # UI test target
```

## Getting Started

### Prerequisites

- Xcode 13+ (Swift 5, iOS 14.2 deployment target)
- [CocoaPods](https://cocoapods.org/)

### Setup

1. Clone the repository.
2. Install dependencies:
   ```bash
   pod install
   ```
3. Open the generated workspace (not the `.xcodeproj`):
   ```bash
   open "Chicken On Fire.xcworkspace"
   ```
4. Configure backend/API settings in `Chicken On Fire/RestaurantInfoManager.swift`:
   - `backendURL` — base URL of the REST API
   - `apiKey` — API authorization key
   - `googleApiKey` — Google Maps/Places API key

   > These values are currently hardcoded for development. For production builds, move secrets out of source control (e.g. an `.xcconfig` file excluded from git).
5. Build and run the `Chicken On Fire` scheme on a simulator or device.

## Localization

The app supports English (`en`) and Arabic (`ar`), including right-to-left layout. Strings are managed in `Localizable.strings` per language under `en.lproj/` and `ar.lproj/`.

## Testing

- `Chicken On FireTests` — unit test target
- `Chicken On FireUITests` — UI test target

Run tests via Xcode's Test navigator or:
```bash
xcodebuild test -workspace "Chicken On Fire.xcworkspace" -scheme "Chicken On Fire" -destination "platform=iOS Simulator,name=iPhone 14"
```

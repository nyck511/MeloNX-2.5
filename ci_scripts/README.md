# Xcode Cloud configuration

This directory prepares the MeloNX 2.5 production project for Xcode Cloud and deliberately rejects runners older than Xcode 27.

Configure the workflow with:

- Project: `MeloNX.xcodeproj`
- Scheme: `MeloNX`
- Platform: iOS
- Configuration: Release
- Xcode: an available Xcode 27 beta
- macOS: the macOS Tahoe version required by the selected Xcode 27 beta

The post-clone script installs the .NET SDK version declared in `global.json` into `$HOME/.dotnet`. The Xcode `Ryujinx` legacy target then runs `distribution/ios/build.sh` to publish `Ryujinx.Library` for `ios-arm64` before the Swift application is linked.

Code signing remains automatic and uses Apple Developer team `4RTSA47M5X` with the existing Xcode Cloud product bundle identifier `com.stossy11.wow.MeloKatie101`. Do not add certificates, provisioning profiles, private keys, or Apple credentials to this repository.

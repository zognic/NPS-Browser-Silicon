# NPS Browser Silicon

A native Apple Silicon build of NPS Browser for macOS.\
**Requires a Mac with Apple Silicon running macOS 11 or later.** Intel Macs are not supported: keep using the original app there.

![](/Screenshots/main.png?raw=true)

## Origin
NPS Browser Silicon is based on [NPS Browser for macOS][original] 1.4.6 by JK3Y, which was released into the public domain under the Unlicense. All credit for the original application goes to JK3Y and its contributors.

The original app only runs on Intel, so Apple Silicon Macs need Rosetta to run it, and Apple is phasing Rosetta out ([About Rosetta][rosetta]). This project makes the app native.

## Changes from NPS Browser 1.4.6
* Native arm64 only app, minimum macOS 11.0 (previously Intel only, macOS 10.12).
* Realm upgraded from 3.21 to 20.0.5, since Realm 3 has no Apple Silicon build. This changes the database file format, see [Switching from NPS Browser](#switching-from-nps-browser).
* `pkg2zip` rebuilt for arm64 from the maintained [lusid1 fork][pkg2zip]. It takes the same options, and PS Vita themes are still extracted in bgdl format.
* The `vitaupdatelinks` binary was removed: game update URLs are now computed in Swift with CommonCrypto, and they are identical.
* A database written by an unsupported Realm version is set aside instead of crashing the app.
* The Carthage dependencies are built for arm64 only by `carthage-bootstrap.sh`, which also works around Xcode 26 mistaking iOS schemes for macOS ones.
* The app is named NPS Browser Silicon, version 2.0.0. Its bundle identifier is unchanged (`JK3Y.NPS-Browser`), so it uses the preferences and the data folder of the original app.

## Switching from NPS Browser
1. Check your Mac: Apple menu > About This Mac must show an Apple chip (M1 or later) and macOS 11 or later.
2. Quit NPS Browser.
3. Back up `~/Library/Application Support/JK3Y.NPS-Browser/default.realm`. This file holds your bookmarks and the game list.
4. Convert the database if you want to keep your bookmarks. NPS Browser Silicon can't open databases written by the original app, so convert yours once with:
   ```
   tools/realm-upgrade/convert.sh
   ```
   The script is in this repository and in the release zip. It needs the Xcode Command Line Tools (`xcode-select --install`), downloads Realm 10.48.1, the last version that can read the old format, makes a copy of the database next to it, then converts it in place and prints what it contains. You can skip this step if you have no bookmarks: the game list can be downloaded again.
5. Move `NPS Browser.app` to the Trash and install `NPS Browser Silicon.app` in /Applications. Don't keep both: once the database is converted, the original app can't open it anymore.
6. Launch NPS Browser Silicon. Your preferences and download folder are kept. If you skipped step 4, the old database is renamed `default.unsupported-<timestamp>.realm` and a new one is created: download the game list again with Database > Reload (⌘R).

Good to know:
* If you launched NPS Browser Silicon before converting, you can still convert the set-aside file: `tools/realm-upgrade/convert.sh <path to default.unsupported-….realm>`, then quit the app and rename it back to `default.realm`.
* To go back to the original app, restore the `default.realm` you backed up in step 3.
* Release builds are signed ad hoc and not notarized, so macOS blocks them the first time. Try to open the app once, then go to System Settings > Privacy & Security and click Open Anyway, or run `xattr -dr com.apple.quarantine "/Applications/NPS Browser Silicon.app"`.
* Realm keeps copies of the database from before each format upgrade (`default.v9.backup.realm`, `default.v23.backup.realm`) for 3 months. Once everything works, you can delete them to free space.

## Features
* Localization in Simplified Chinese
* Bookmarks can be saved by clicking the star icon in the corner of the details panel
* Downloads can be started from the bookmark list
* Downloads can be stopped and resumed at any point, they can also be resumed if the app is closed during download
* Compatibility pack support for FW 3.61+
* Game updates are always the latest version
* Game artwork is displayed

## Usage
* Change or set URLs and extraction preferences in the Preferences window
* From the menu select Database > Reload or press ⌘R
* Compatibility pack URLs must be the raw text file.

## Removal
After moving to trash, run:
```
rm -r ~/Library/Application\ Support/JK3Y.NPS-Browser/
rm -r ~/Library/Caches/JK3Y.NPS-Browser
rm -r ~/Library/Caches/NPS\ Browser\ Silicon
defaults delete JK3Y.NPS-Browser
```
If you used the original app, also remove `~/Library/Caches/NPS Browser`.

## Building
Make sure you have Xcode 26 and [Carthage][] installed.
Open a terminal and build the dependencies (arm64 only, see `Carthage.xcconfig`):
```
./carthage-bootstrap.sh
```
Open the .xcodeproj file to open the project.

Build by going to Product > Build.

Export an app bundle by going to Product > Archive > Export.

#### pkg2zip
The bundled `pkg2zip` binary is built for arm64 from [pkg2zip][] (commit `6ee3df5`), leaving out the x86-only `*_x86.c` sources:
```
clang -std=c99 -O2 -DNDEBUG -D_GNU_SOURCE -arch arm64 -mmacosx-version-min=11.0 -o pkg2zip \
  pkg2zip.c pkg2zip_aes.c pkg2zip_crc32.c pkg2zip_out.c pkg2zip_psp.c pkg2zip_sys.c pkg2zip_zip.c pkg2zip_zrif.c \
  miniz_tdef.c puff.c
strip pkg2zip
```

#### [Changelog](CHANGELOG.md)

## License
NPS Browser Silicon is dedicated to the public domain under [CC0 1.0 Universal](LICENSE.md). The original NPS Browser is in the public domain under the Unlicense. Third-party components keep their own licenses, see [NOTICE.md](NOTICE.md).

## Thanks
* JK3Y and contributors for the original [NPS Browser for macOS][original]
* Ann0ying for app icon
* Luro02 and lusid1 for the [pkg2zip][] fork
* devnoname120 for [vitanpupdatelinks][]
* L1cardo for Simplified Chinese translation

[original]: https://github.com/JK3Y/NPS-Browser-macOS
[rosetta]: https://support.apple.com/102527
[Carthage]: https://github.com/Carthage/Carthage
[pkg2zip]: https://github.com/lusid1/pkg2zip
[vitanpupdatelinks]: https://github.com/devnoname120/vitanpupdatelinks

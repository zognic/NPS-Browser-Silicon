# Notices

## NPS Browser for macOS
NPS Browser Silicon is based on [NPS Browser for macOS](https://github.com/JK3Y/NPS-Browser-macOS) 1.4.6 by JK3Y and contributors, released under the following license:

```
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
```

## Third-party components
These components are not covered by CC0 and keep their own licenses. Apps built from this repository embed the frameworks and the `pkg2zip` binary, so include their license texts when you distribute a build (after running `carthage-bootstrap.sh`, they are in `Carthage/Checkouts/<name>/`).

| Component | Version | License | Used as |
|---|---|---|---|
| [pkg2zip](https://github.com/lusid1/pkg2zip) (lusid1 fork of mmozeiko/pkg2zip) | `6ee3df5` | Unlicense (public domain) | bundled binary |
| [Alamofire](https://github.com/Alamofire/Alamofire) | 4.9.1 | MIT | embedded framework |
| [AlamofireImage](https://github.com/Alamofire/AlamofireImage) | 3.6.0 | MIT | embedded framework |
| [Fuzi](https://github.com/cezheng/Fuzi) | 2.2.1 | MIT | embedded framework |
| [Promises](https://github.com/google/promises) | 1.2.9 | Apache 2.0 | embedded framework |
| [Queuer](https://github.com/FabrizioBrancati/Queuer) | 2.1.1 | MIT | embedded framework |
| [Realm](https://github.com/realm/realm-swift) | 20.0.5 | Apache 2.0 | embedded framework |
| [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver) | 1.9.1 | MIT | embedded framework |
| [SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults) | 4.0.0 | MIT | embedded framework |
| [Zip](https://github.com/marmelroy/Zip) | 1.1.0 | MIT, includes minizip (zlib license) | embedded framework |

`tools/realm-upgrade/convert.sh` downloads Realm 10.48.1 (Apache 2.0) at run time; it isn't part of the app.

The key used to compute game update URLs comes from [vitanpupdatelinks](https://github.com/devnoname120/vitanpupdatelinks) by devnoname120.

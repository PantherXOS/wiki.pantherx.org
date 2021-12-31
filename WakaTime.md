---
namespace: wakatime
description: "WakaTime is a fully automatic time tracking tool for programmers. Powered by open-source plugins for countless of IDE's, text editors and browsers, it gives powerful insights about when and how you code."
description-source: "https://en.wikipedia.org/wiki/Git"
categories:
  - type:
      - "Application"
  - location:
      - "Development"
      - "Time Tracking"
language: en
---

## Installation

Wakatime should be installed via the plugin system of the supported application. For ex. Atom, Emacs, Chrome, ...

[All supported applications](https://wakatime.com/plugins)

## Troubleshooting

### Browser Plugins

#### Chrome

##### Time missing

Unlike the editor plugins, the Chrome browser plugin relies on an active internet connection, to send heartbeats.

1. check that you're logged in
2. ensure your internet connection is stable
3. try using a _VPN_ or _Proxy_ if _WakaTime_ has connection issues

##### Unable to login

1. Open `https://api.wakatime.com/api/v1/users/current/heartbeats` to verify status (likely _Unauthorized_)
2. Delete all cookies related `api.wakatime.com`
3. Ppen your Dashboard at `https://wakatime.com/dashboard`
4. Refresh API page

Thanks to [vysinsky](https://github.com/wakatime/chrome-wakatime/issues/44#issuecomment-251362887)

### Editor Plugins

All editor plugins rely on the [WakaTime CLI](https://github.com/wakatime/wakatime) to store, and submit tracked data.

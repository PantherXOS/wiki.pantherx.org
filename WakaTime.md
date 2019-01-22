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

## Troubleshooting

### Browser Plugins

#### Chrome

##### Time missing

Unlike the editor plugins, the Chrome browser plugin relies on an active internet connection, to send heartbeats.

1. check that you're logged in
2. ensure your internet connection is stable
2. try using a _VPN_ or _Proxy_ if _WakaTime_ has connection issues

##### Unable to login

1. open `https://api.wakatime.com/api/v1/users/current/heartbeats` to verify status (likely _Unauthorized_)
2. delete all cookies related `api.wakatime.com`
3. open your Dashboard at `https://wakatime.com/dashboard`
4. refresh API page

Thanks to [vysinsky](https://github.com/wakatime/chrome-wakatime/issues/44#issuecomment-251362887)

### Editor Plugins

All editor plugins rely on the [WakaTime CLI](https://github.com/wakatime/wakatime) to store, and submit tracked data.
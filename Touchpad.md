---
---

To activation tap to click you can add an extra config to `xorg-configuration` in `sddm-service-type` part:

```scheme
         (service sddm-service-type
             (sddm-configuration
               (minimum-uid 1000)
               (theme "darkine")
               (xorg-configuration
                 (xorg-configuration
                   (extra-config `("Section \"InputClass\"\n"
                                   "   Identifier \"touchpad\"\n"
                                   "   Driver \"libinput\"\n"
                                   "   MatchIsTouchpad \"on\"\n"
                                   "   Option \"Tapping\" \"on\"\n"
                                   "EndSection\n"
                                   "\n"))))))
```

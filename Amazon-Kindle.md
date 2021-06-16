---
namespace: amazon
description: "Amazon Kindle is a series of e-readers designed and marketed by Amazon. Amazon Kindle devices enable users to browse, buy, download, and read e-books, newspapers, magazines and other digital media via wireless networking to the Kindle Store."
description-source: "https://en.wikipedia.org/wiki/Amazon_Kindle"
categories:
  - type:
      - "Hardware"
  - location:
      - "Hardware"
      - "Hardware eReader"
language: en
---

## Offline Device Updates

Fortunately updating Kindle works anywhere:

1. Download your update from [here](https://www.amazon.com/gp/help/customer/display.html?nodeId=GKMQC26VQQMM8XSW)
   - Depending on your model, you'll end up with a file like `update_kindle_voyage_5.13.6.bin`
2. Plugin the Kindle to USB. You should get a prompt whether to open the device.
3. Copy the `update_kindle_voyage_5.13.6.bin` to the Kindle
4. Eject the Kindle

Now simply execute the software update:

1. On your Kindle home screen, tap the Menu icon, and then tap Settings.
2. Tap the Menu icon again, and then tap Update Your Kindle.

## eBook Management

PantherX comes with a great e-book library manager called calibre.

Installation:

```bash
guix package -i calibre
```

Set-up is easy:

1. Select a location at which to store your eBooks
2. Select your eBook reader manufacturer and model (Amazon, ...)
3. Optionally: Add your Kindle email to automatically send books

Once you're done, close the setup. You should be on the main Calibre interface.

1. Plugin your Kindle (You might get a removable storage prompt, ignore that)
2. In Calibre, look for the "Device" icon and click on it

You should now be looking at a list of all eBooks on your Kindle.

To learn more about working with calibre, checkout the [calibre User Manual](https://manual.calibre-ebook.com/).

## See also

- [Manually Update Your Kindle E-Reader Software](https://www.amazon.com/gp/help/customer/display.html?nodeId=GFAE5G5UGCYA25DW)

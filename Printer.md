---
---

**If you are running PantherX Desktop, this is configured out of the box.**

Printing is handled by CUPS. Other applications like Libre Office rely on CUPS to have a printer configured, to print.

## Configuration

Depending on your printer, you might have to install some additional drivers:

- `brlaser`:  Brlaser is a CUPS driver for Brother laser printers.
- `hplip`: Hewlett-Packard printer drivers and PostScript Printer Description

### GUI

A basic utility is provided to add your printer via GUI. I have a Canon MX920 series to test with, so the following example will be based on this:

#### WiFi

1. You need to find your printer's IP on the network. I logged onto the router, and got it from there: `192.168.178.107`
2. Run `kde-add-printer --add-printer` and open up "Other Network Printers"
3. Select "Internet Printing Protocol (ipp)" and enter the IP like so: `ipp://192.168.178.107`

Next you will see a whole bunch of different manufacturers and printers to select from. Simply select your manufacturer and model and confirm with "Finish". If you do not see your printer (Canon and MX920 certainly don't show up), you'll need to get a "PPD" file from somewhere.

Lucky enough, someone made a PPD for the MX922 and posted it on reddit: [here](https://www.reddit.com/r/chromeos/comments/mnet0q/i_made_a_canon_mx922_ppd_file_that_works_on/).

With the PPD in hand, you can select "Manually Provide a PPD File" and confirm with "Finish".

Now you can use the printer as usual, for example to print documents from Libre Office. If you want to see the current document queue, or other related stats, you can visit the web interface at [http://localhost:631](http://localhost:631). During the setup I named the printer "CanonMX920" so it's always available at: [http://localhost:631/printers/CanonMX920](http://localhost:631/printers/CanonMX920).

#### USB

This should work via `kde-add-printer --add-printer` too but is untested (WiFi) is too convinient.

### Web interface

The web interface is available at [http://localhost:631/](http://localhost:631/) and provides access to all CUPS features.
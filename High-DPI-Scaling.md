If you have a WHQD or 4K display on a small screen, you probably want to look into scaling the interface to be more readable.

## Settings

### WHQD example

Here's an example of a WHQD display on a 14" Laptop. I have scaling set to 1.5.

Here's how you do that:

1. Open the Menu
2. Preferences
3. Advanced Settings
4. Session Sesttings
5. Environment (Advanded)

Simply click "Add" to add a new valiable.

```
GDK_DPI_SCALE 1.5
GDK_SCALE 1.5
QT_AUTO_SCREEN_SCALE_FACTOR 0
QT_SCALE_FACTOR 1.5
XCURSOR_SIZE 26
```

I have found that these work well for basically all Qt, and most modern GTK+ 3 applications. In fact, the entire desktop interface will adapt.

To apply these settings, 

- a reboot is best.
- Log-out, and Log-in should do too.

### 4K example

On a similiar screen with a higher resolution, a factor of 2 will probably work well.

```
GDK_DPI_SCALE 2
GDK_SCALE 2
QT_AUTO_SCREEN_SCALE_FACTOR 0
QT_SCALE_FACTOR 2
XCURSOR_SIZE 30
```

## Issues

This is far from perfect yet and we're working on a better (more user-friendly!) solution.

- If you attach a 2nd monitor, it will scale at the same rate (try xrandr?)
- Rarely you encounter applications that do not scale. Checkout their settings to see if there's an option for scaling (especially older applications)
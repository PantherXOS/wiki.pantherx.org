---
---

## Base

This provides the bare system with minimal dependencies.

- Libre kernel

```scheme
px-base-os
%px-base-packages
%px-base-services
```

## Desktop

This provides the default desktop environment.

- Non-libre kernel

```
px-desktop-os
%px-desktop-packages
%px-desktop-services
```

```scheme
{% include config-examples/base-desktop.scm %}
```

## Desktop Libre

This provides the default desktop environment with non-libre components stipped.

- Libre kernel

```
px-libre-desktop-os
%px-desktop-packages
%px-desktop-services
```

## Server

This provides the default server environment.

- Libre kernel

```scheme
px-server-os
%px-server-packages
%px-server-services
```

## See also

- [Guix Manual: Using the Configuration System](https://www.gnu.org/software/guix/manual/en/html_node/Using-the-Configuration-System.html)
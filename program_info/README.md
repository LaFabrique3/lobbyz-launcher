# Prism Launcher Program Info

This is Prism Launcher's program info which contains information about:

- Application name and logo (and branding in general)
- Various URLs and API endpoints
- Desktop file

## Lobbyz build

The Lobbyz rebrand lives entirely in this directory and in the `-D` flags
passed at configure time — no upstream `.cpp`/`.h`/`.ui` file is modified.

**Prerequisites**
- MSYS2 with the CLANG64 environment (same packages as the project's CI for
  the `windows_mingw` preset: Qt6, CMake, Ninja, clang toolchain, etc.)
- JDK Zulu 17 available in `PATH` (required by the Java-related build steps)

**Command** (run from an MSYS2 CLANG64 shell, JDK Zulu 17 already in `PATH`):

```bash
bash build-lobbyz.sh
```

This configures the `windows_mingw` preset with `Launcher_APP_BINARY_NAME=lobbyz`
plus the Lobbyz MSA client ID and login callback URL, then builds it.

**Known debt (tracked on purpose, not fixed by this rebrand pass)**
- Linux branding files (`fr.lobbyz.Lobbyz.svg` / `.metainfo.xml.in` /
  `.desktop.in`) are still upstream copies — they will be adapted when the
  final Lobbyz artwork exists (Windows-only stack today).
- The upstream `org.prismlauncher.PrismLauncher.*` files are kept on purpose
  to ease future upstream rebases.

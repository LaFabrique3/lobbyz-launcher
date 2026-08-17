#!/usr/bin/env bash
set -euo pipefail

# Type de build (Release par defaut). Generateur Ninja Multi-Config :
# la config se choisit AU BUILD et A L'INSTALL par --config, jamais a la
# configuration (methode amont : .github/workflows/build.yml ligne 131 et
# .github/actions/package/windows/action.yml).
BUILD_TYPE="${1:-Release}"

cmake --preset windows_mingw \
  -DLauncher_APP_BINARY_NAME=lobbyz \
  -DLauncher_MSA_CLIENT_ID=ea68b38e-e848-4a15-82b5-d4827dea89fa \
  -DLauncher_LOGIN_CALLBACK_URL=https://lobbyz.fr/connecte
cmake --build --preset windows_mingw --config "$BUILD_TYPE"
cmake --install build --config "$BUILD_TYPE"

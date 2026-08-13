#!/usr/bin/env bash
set -euo pipefail
cmake --preset windows_mingw \
  -DLauncher_APP_BINARY_NAME=lobbyz \
  -DLauncher_MSA_CLIENT_ID=ea68b38e-e848-4a15-82b5-d4827dea89fa \
  -DLauncher_LOGIN_CALLBACK_URL=https://lobbyz.fr/connecte
cmake --build --preset windows_mingw

#!/usr/bin/env bash
set -euo pipefail

# Type de build (Release par defaut). Generateur Ninja Multi-Config :
# la config se choisit AU BUILD et A L'INSTALL par --config, jamais a la
# configuration (methode amont : .github/workflows/build.yml ligne 131 et
# .github/actions/package/windows/action.yml).
BUILD_TYPE="${1:-Release}"

# JDK requis (libraries/launcher est du Java compile par javac). Le PATH
# minimal des login shells MSYS2 masque les JDK installes cote Windows :
# on complete depuis JAVA_HOME, sinon l'installation Zulu standard.
if ! command -v javac > /dev/null 2>&1; then
    for jdk in "${JAVA_HOME:-}" "/c/Program Files/Zulu"/zulu-*; do
        [ -n "$jdk" ] || continue
        jdk="$(cygpath -u "$jdk" 2> /dev/null || printf '%s' "$jdk")"
        if [ -x "$jdk/bin/javac.exe" ]; then
            export PATH="$PATH:$jdk/bin"
            break
        fi
    done
fi
if ! command -v javac > /dev/null 2>&1; then
    echo "ERREUR: javac introuvable - installer un JDK ou definir JAVA_HOME" >&2
    exit 1
fi

cmake --preset windows_mingw \
  -DLauncher_APP_BINARY_NAME=lobbyz \
  -DLauncher_MSA_CLIENT_ID=ea68b38e-e848-4a15-82b5-d4827dea89fa \
  -DLauncher_LOGIN_CALLBACK_URL=https://lobbyz.fr/connecte
cmake --build --preset windows_mingw --config "$BUILD_TYPE"
cmake --install build --config "$BUILD_TYPE"

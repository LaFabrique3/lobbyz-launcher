#!/usr/bin/env bash
set -euo pipefail

# S'execute DANS le shell MSYS2 CLANG64 (toolchain du preset) - garde explicite,
# sinon l'echec cmake plus bas est cryptique (revue qualite 17.08).
if [ "${MSYSTEM:-}" != "CLANG64" ]; then
    echo "ERREUR: lancer depuis MSYS2 CLANG64 (ex.: C:\\msys64\\clang64.exe bash -lc ./build-lobbyz.sh)" >&2
    exit 1
fi

# Type de build (Release par defaut). Generateur Ninja Multi-Config :
# la config se choisit AU BUILD et A L'INSTALL par --config, jamais a la
# configuration (methode amont : .github/workflows/build.yml ligne 131 et
# .github/actions/package/windows/action.yml).
BUILD_TYPE="${1:-Release}"

# JDK requis (libraries/launcher est du Java compile par javac). ATTENTION :
# JDK 8 a 19 UNIQUEMENT - libraries/launcher/CMakeLists.txt compile en
# -source 7, retire des JDK >= 20 ; si Zulu a ete mis a jour au-dela,
# pointer JAVA_HOME sur un JDK <= 19 (revue qualite 17.08 ; le glob
# ci-dessous prend la PREMIERE version par tri lexical, pas la plus recente).
# Le PATH minimal des login shells MSYS2 masque les JDK installes cote
# Windows : on complete depuis JAVA_HOME, sinon l'installation Zulu standard.
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

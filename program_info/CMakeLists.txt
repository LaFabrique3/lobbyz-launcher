if(UNIX)
    find_package(PkgConfig)
    if(PkgConfig_FOUND)
        pkg_search_module(SCDOC scdoc)
        if(SCDOC_FOUND)
            pkg_get_variable(SCDOC_SCDOC scdoc scdoc)
        endif()
    endif()
endif()

set(Launcher_CommonName "Lobbyz")
set(Launcher_DisplayName "Lobbyz")
set(Launcher_AppID "fr.lobbyz.Lobbyz")
set(Launcher_Domain "lobbyz.fr")
set(Launcher_Git "https://github.com/LaFabrique3/lobbyz-launcher")

set(Launcher_Name "${Launcher_CommonName}" PARENT_SCOPE)
set(Launcher_DisplayName "${Launcher_DisplayName}" PARENT_SCOPE)
set(Launcher_ENVName "PRISMLAUNCHER" PARENT_SCOPE)
set(Launcher_Domain "${Launcher_Domain}" PARENT_SCOPE)
set(Launcher_Git "${Launcher_Git}" PARENT_SCOPE)

set(Launcher_SVGFileName "${Launcher_AppID}.svg")
set(Launcher_Copyright "NOT AN OFFICIAL MINECRAFT SERVICE. NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.\\nVous (pas Mojang) etes responsable de ce que vous hebergez.\\n(c) 2026 Lobbyz - fork de Prism Launcher (GPL-3.0)\\n© 2022-2026 Prism Launcher Contributors\\n© 2021-2022 PolyMC Contributors\\n© 2012-2021 MultiMC Contributors")
set(Launcher_Copyright_Mac "© 2022-2026 Prism Launcher Contributors, © 2021-2022 PolyMC Contributors and © 2012-2021 MultiMC Contributors" PARENT_SCOPE)
set(Launcher_Copyright "${Launcher_Copyright}" PARENT_SCOPE)
# NOTE (rebrand Lobbyz) : version ASCII pure (1re ligne du disclaimer), pour la
# ressource Windows .rc (VALUE "LegalCopyright"). Mesure : le compilateur RC
# corrompt le "©" des lignes amont de Launcher_Copyright quand il est injecte
# via configure_file(@ONLY) dans lobbyz.rc.in -> "Â©" au lieu de "©" (UTF-8
# lu comme deux caracteres Latin-1 puis elargi en UTF-16). La chaine C++
# (BuildConfig.LAUNCHER_COPYRIGHT) reste correcte : seul ce chemin RC est
# fautif. On isole donc ici une ligne 100% ASCII qui ne le traverse jamais.
set(Launcher_CopyrightShort "NOT AN OFFICIAL MINECRAFT SERVICE. NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.")
set(Launcher_UserAgent "${Launcher_CommonName}/${Launcher_VERSION_NAME}" PARENT_SCOPE)
set(Launcher_ConfigFile "${Launcher_APP_BINARY_NAME}.cfg" PARENT_SCOPE)
set(Launcher_AppID "${Launcher_AppID}" PARENT_SCOPE)
set(Launcher_SVGFileName "${Launcher_SVGFileName}" PARENT_SCOPE)

set(Launcher_Desktop "program_info/${Launcher_AppID}.desktop" PARENT_SCOPE)
set(Launcher_MIMEInfo "program_info/${Launcher_AppID}.xml" PARENT_SCOPE)
set(Launcher_MetaInfo "program_info/${Launcher_AppID}.metainfo.xml" PARENT_SCOPE)
set(Launcher_PNG_256 "program_info/${Launcher_AppID}_256.png" PARENT_SCOPE)
set(Launcher_SVG "program_info/${Launcher_SVGFileName}" PARENT_SCOPE)
set(Launcher_Branding_ICNS "program_info/${Launcher_APP_BINARY_NAME}.icns" PARENT_SCOPE)
set(Launcher_Branding_MAC_ICON "program_info/${Launcher_CommonName}.icon" PARENT_SCOPE)
set(Launcher_Branding_ICO "program_info/${Launcher_APP_BINARY_NAME}.ico")
set(Launcher_Branding_ICO "${Launcher_Branding_ICO}" PARENT_SCOPE)
set(Launcher_Branding_WindowsRC "program_info/${Launcher_APP_BINARY_NAME}.rc" PARENT_SCOPE)
# NOTE (rebrand Lobbyz) : le nom du .qrc reste fige a "prismlauncher" (et non
# ${Launcher_APP_BINARY_NAME}) car launcher/main.cpp appelle en dur
# Q_INIT_RESOURCE(prismlauncher) ; ce macro genere qInitResources_prismlauncher()
# a l'edition de liens. Renommer le .qrc casse le link (symbole introuvable).
# main.cpp est un fichier C++ hors mandat (jamais touche) : on fixe donc ici,
# cote CMake, le seul nom qui doit rester stable quel que soit le binaire.
set(Launcher_Branding_LogoQRC "program_info/prismlauncher.qrc" PARENT_SCOPE)
set(Launcher_Authors "MultiMC & Prism Launcher Contributors")

set(Launcher_Portable_File "program_info/portable.txt" PARENT_SCOPE)

configure_file(${Launcher_AppID}.desktop.in ${Launcher_AppID}.desktop)
configure_file(${Launcher_AppID}.metainfo.xml.in ${Launcher_AppID}.metainfo.xml)
configure_file(${Launcher_APP_BINARY_NAME}.rc.in ${Launcher_APP_BINARY_NAME}.rc @ONLY)
configure_file(prismlauncher.qrc.in prismlauncher.qrc @ONLY)
configure_file(${Launcher_APP_BINARY_NAME}.manifest.in ${Launcher_APP_BINARY_NAME}.manifest @ONLY)
configure_file(${Launcher_APP_BINARY_NAME}.ico ${Launcher_APP_BINARY_NAME}.ico COPYONLY)
configure_file(${Launcher_SVGFileName} ${Launcher_SVGFileName} COPYONLY)
configure_file(${Launcher_AppID}.mime.xml ${Launcher_AppID}.xml COPYONLY)

if(MSVC)
    set(Launcher_MSVC_Redist_NSIS_Section [=[
!ifdef haveNScurl
Section "Visual Studio Runtime"
    Var /GLOBAL vc_redist_exe
    ${If} ${IsNativeARM64}
        StrCpy $vc_redist_exe "vc_redist.arm64.exe"
    ${Else}
        StrCpy $vc_redist_exe "vc_redist.x64.exe"
    ${EndIf}
    DetailPrint 'Downloading Microsoft Visual C++ Redistributable...'
    NScurl::http GET "https://aka.ms/vs/17/release/$vc_redist_exe" "$INSTDIR\vc_redist\$vc_redist_exe" /INSIST /CANCEL /Zone.Identifier /END
    Pop $0
    ${If} $0 == "OK"
        DetailPrint "Download successful"
        ExecWait "$INSTDIR\vc_redist\$vc_redist_exe /install /passive /norestart"
    ${Else}
        DetailPrint "Download failed with error $0"
    ${EndIf}
SectionEnd
!endif
]=])
endif()

configure_file(win_install.nsi.in win_install.nsi @ONLY)

if(SCDOC_FOUND)
    configure_file(${Launcher_APP_BINARY_NAME}.6.scd.in ${Launcher_APP_BINARY_NAME}.6.scd @ONLY)

    set(in_scd "${CMAKE_CURRENT_BINARY_DIR}/${Launcher_APP_BINARY_NAME}.6.scd")
    set(out_man "${CMAKE_CURRENT_BINARY_DIR}/${Launcher_APP_BINARY_NAME}.6")
    add_custom_command(
        DEPENDS "${in_scd}"
        OUTPUT "${out_man}"
        COMMAND ${SCDOC_SCDOC} < "${in_scd}" > "${out_man}"
    )
    add_custom_target(man ALL DEPENDS ${out_man})
    set(Launcher_ManPage "program_info/${Launcher_APP_BINARY_NAME}.6" PARENT_SCOPE)
endif()

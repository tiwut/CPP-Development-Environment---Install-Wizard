#!/bin/bash
set -e

if command -v apt-get &> /dev/null; then
    PKG_MGR="apt"
    PM_REMOVE="sudo apt-get remove -y"
elif command -v dnf &> /dev/null; then
    PKG_MGR="dnf"
    PM_REMOVE="sudo dnf remove -y"
elif command -v pacman &> /dev/null; then
    PKG_MGR="pacman"
    PM_REMOVE="sudo pacman -R --noconfirm"
else
    echo "Unsupported Package Manager."
    exit 1
fi

if ! command -v whiptail &> /dev/null; then
    echo "Error: whiptail is not installed."
    exit 1
fi

get_system_pkg() {
    case $1 in
        "GCC")          [[ "$PKG_MGR" == "apt" ]] && echo "build-essential" || ([[ "$PKG_MGR" == "dnf" ]] && echo "gcc-c++ make" || echo "base-devel") ;;
        "Clang")        echo "clang" ;;
        "CMake")        echo "cmake" ;;
        "Ninja")        [[ "$PKG_MGR" == "apt" || "$PKG_MGR" == "dnf" ]] && echo "ninja-build" || echo "ninja" ;;
        "Make")         echo "make" ;;
        "GDB")          echo "gdb" ;;
        "LLDB")         echo "lldb" ;;
        "Valgrind")     echo "valgrind" ;;
        "Cppcheck")     echo "cppcheck" ;;
        "CCache")       echo "ccache" ;;
        "Doxygen")      echo "doxygen" ;;
        "ClangFormat")  [[ "$PKG_MGR" == "apt" || "$PKG_MGR" == "dnf" ]] && echo "clang-format" || echo "clang" ;;
        "ClangTidy")    [[ "$PKG_MGR" == "apt" || "$PKG_MGR" == "dnf" ]] && echo "clang-tidy" || echo "clang" ;;
        "Boost")        [[ "$PKG_MGR" == "apt" ]] && echo "libboost-all-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "boost-devel" || echo "boost") ;;
        "fmt")          [[ "$PKG_MGR" == "apt" ]] && echo "libfmt-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "fmt-devel" || echo "fmt") ;;
        "json")         [[ "$PKG_MGR" == "apt" ]] && echo "nlohmann-json3-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "json-devel" || echo "nlohmann-json") ;;
        "spdlog")       [[ "$PKG_MGR" == "apt" ]] && echo "libspdlog-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "spdlog-devel" || echo "spdlog") ;;
        "Catch2")       [[ "$PKG_MGR" == "apt" ]] && echo "catch2" || ([[ "$PKG_MGR" == "dnf" ]] && echo "catch-devel" || echo "catch2") ;;
        "GTest")        [[ "$PKG_MGR" == "apt" ]] && echo "libgtest-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "gtest-devel" || echo "gtest") ;;
        "cURL")         [[ "$PKG_MGR" == "apt" ]] && echo "libcurl4-openssl-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "libcurl-devel" || echo "curl") ;;
        "OpenSSL")      [[ "$PKG_MGR" == "apt" ]] && echo "libssl-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "openssl-devel" || echo "openssl") ;;
        "SQLite3")      [[ "$PKG_MGR" == "apt" ]] && echo "libsqlite3-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "sqlite-devel" || echo "sqlite") ;;
        "Poco")         [[ "$PKG_MGR" == "apt" ]] && echo "libpoco-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "poco-devel" || echo "poco") ;;
        "Eigen")        [[ "$PKG_MGR" == "apt" ]] && echo "libeigen3-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "eigen3-devel" || echo "eigen") ;;
        "yaml-cpp")     [[ "$PKG_MGR" == "apt" ]] && echo "libyaml-cpp-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "yaml-cpp-devel" || echo "yaml-cpp") ;;
        "zlib")         [[ "$PKG_MGR" == "apt" ]] && echo "zlib1g-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "zlib-devel" || echo "zlib") ;;
        "Qt5")          [[ "$PKG_MGR" == "apt" ]] && echo "qtbase5-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "qt5-qtbase-devel" || echo "qt5-base") ;;
        "Qt6")          [[ "$PKG_MGR" == "apt" ]] && echo "qt6-base-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "qt6-qtbase-devel" || echo "qt6-base") ;;
        "SDL2")         [[ "$PKG_MGR" == "apt" ]] && echo "libsdl2-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "SDL2-devel" || echo "sdl2") ;;
        "SFML")         [[ "$PKG_MGR" == "apt" ]] && echo "libsfml-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "SFML-devel" || echo "sfml") ;;
        "OpenCV")       [[ "$PKG_MGR" == "apt" ]] && echo "libopencv-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "opencv-devel" || echo "opencv") ;;
        "wxWidgets")    [[ "$PKG_MGR" == "apt" ]] && echo "libwxgtk3.0-gtk3-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "wxGTK-devel" || echo "wxwidgets-gtk3") ;;
        "GTKmm")        [[ "$PKG_MGR" == "apt" ]] && echo "libgtkmm-3.0-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "gtkmm30-devel" || echo "gtkmm3") ;;
        "GLEW")         [[ "$PKG_MGR" == "apt" ]] && echo "libglew-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "glew-devel" || echo "glew") ;;
        "GLFW")         [[ "$PKG_MGR" == "apt" ]] && echo "libglfw3-dev" || ([[ "$PKG_MGR" == "dnf" ]] && echo "glfw-devel" || echo "glfw-x11") ;;
    esac
}

get_vcpkg_pkg() {
    case $1 in
        "json") echo "nlohmann-json" ;;
        "SQLite3") echo "sqlite3" ;;
        "yaml-cpp") echo "yaml-cpp" ;;
        "Qt5") echo "qt5" ;;
        "Qt6") echo "qtbase" ;;
        *) echo "$1" | tr '[:upper:]' '[:lower:]' ;;
    esac
}

is_installed_sys() {
    local PKG=$(echo "$1" | awk '{print $1}') 
    if [[ "$PKG_MGR" == "apt" ]]; then
        dpkg-query -W -f='${Status}' "$PKG" 2>/dev/null | grep -q "ok installed"
    elif [[ "$PKG_MGR" == "dnf" ]]; then
        rpm -q "$PKG" &>/dev/null
    elif [[ "$PKG_MGR" == "pacman" ]]; then
        pacman -Qq "$PKG" &>/dev/null
    fi
}

is_installed_vcpkg() {
    if [ -f "$HOME/vcpkg/vcpkg" ]; then
        "$HOME/vcpkg/vcpkg" list "$1" 2>/dev/null | grep -q "^$1"
    else
        return 1
    fi
}

ALL_APPS="GCC Clang CMake Ninja Make GDB LLDB Valgrind Cppcheck CCache Doxygen ClangFormat ClangTidy Boost fmt json spdlog Catch2 GTest cURL OpenSSL SQLite3 Poco Eigen yaml-cpp zlib Qt5 Qt6 SDL2 SFML OpenCV wxWidgets GTKmm GLEW GLFW"

echo "Scanning system for installed C++ components... Please wait."
MENU_OPTIONS=()

for app in $ALL_APPS; do
    SYS_NAME=$(get_system_pkg "$app")
    if is_installed_sys "$SYS_NAME"; then
        MENU_OPTIONS+=("SYS_${app}" "System: $app" OFF)
    fi
done

if [ -d "$HOME/vcpkg" ]; then
    MENU_OPTIONS+=("CORE_vcpkg" "Directory: ~/.vcpkg (Delete completely)" OFF)
    for app in $ALL_APPS; do
        VCPKG_NAME=$(get_vcpkg_pkg "$app")
        if is_installed_vcpkg "$VCPKG_NAME"; then
            MENU_OPTIONS+=("VCPKG_${app}" "vcpkg: $app" OFF)
        fi
    done
fi

if [ ${#MENU_OPTIONS[@]} -eq 0 ]; then
    whiptail --title "Uninstaller" --msgbox "No components managed by this script were found." 10 50
    exit 0
fi

TITLE="C++ Environment Uninstaller"
CHOICES=$(whiptail --title "$TITLE" --checklist \
"The following components were found.\nWhich ones do you want to UNINSTALL? (Space to select, Enter to confirm)" \
25 75 15 "${MENU_OPTIONS[@]}" 3>&1 1>&2 2>&3)

if [ -z "$CHOICES" ]; then
    echo "Nothing selected. Exiting."
    exit 0
fi

CHOICES=$(echo $CHOICES | tr -d '"')

clear
echo "========================================="
echo " Starting Uninstallation..."
echo "========================================="

contains() { [[ " $CHOICES " =~ " $1 " ]]; }

PKGS_TO_REMOVE=""
for app in $ALL_APPS; do
    if contains "SYS_${app}"; then
        PKGS_TO_REMOVE="$PKGS_TO_REMOVE $(get_system_pkg "$app")"
    fi
done

if [ -n "$PKGS_TO_REMOVE" ]; then
    echo "Removing system packages via $PKG_MGR..."
    eval "$PM_REMOVE $PKGS_TO_REMOVE" || echo "Warning: Some system packages could not be removed (possible dependencies)."
fi

for app in $ALL_APPS; do
    if contains "VCPKG_${app}"; then
        VCPKG_NAME=$(get_vcpkg_pkg "$app")
        if [ -f "$HOME/vcpkg/vcpkg" ]; then
            echo "Removing $app from vcpkg..."
            "$HOME/vcpkg/vcpkg" remove "$VCPKG_NAME"
        fi
    fi
done

if contains "CORE_vcpkg"; then
    echo "Deleting vcpkg directory (~/.vcpkg)..."
    rm -rf "$HOME/vcpkg"
    echo "vcpkg has been completely removed."
fi

echo "========================================="
echo " Uninstallation complete!"
echo "========================================="
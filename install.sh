#!/bin/bash
set -e

if command -v apt-get &> /dev/null; then
    PKG_MGR="apt"
    PM_INSTALL="sudo apt-get install -y"
    PM_UPDATE="sudo apt-get update -y"
    PKG_WHIPTAIL="whiptail"
elif command -v dnf &> /dev/null; then
    PKG_MGR="dnf"
    PM_INSTALL="sudo dnf install -y"
    PM_UPDATE="sudo dnf check-update || true"
    PKG_WHIPTAIL="newt"
elif command -v pacman &> /dev/null; then
    PKG_MGR="pacman"
    PM_INSTALL="sudo pacman -S --noconfirm"
    PM_UPDATE="sudo pacman -Sy --noconfirm"
    PKG_WHIPTAIL="libnewt"
else
    echo "Unsupported Package Manager. Supported: apt, dnf, pacman."
    exit 1
fi

MISSING_PKGS=""
for cmd in whiptail curl git; do
    if ! command -v $cmd &> /dev/null; then
        [ "$cmd" == "whiptail" ] && MISSING_PKGS="$MISSING_PKGS $PKG_WHIPTAIL" || MISSING_PKGS="$MISSING_PKGS $cmd"
    fi
done

if [ -n "$MISSING_PKGS" ]; then
    read -p "Missing tools ($MISSING_PKGS). Install now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        eval "$PM_UPDATE"
        eval "$PM_INSTALL $MISSING_PKGS"
    else
        exit 1
    fi
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

        "Qt5")          [[ "$PKG_MGR" == "apt" ]] && echo "qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools" || ([[ "$PKG_MGR" == "dnf" ]] && echo "qt5-qtbase-devel" || echo "qt5-base") ;;
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

TITLE="Ultimate C++ Setup Wizard"

INSTALL_MODE=$(whiptail --title "$TITLE" --menu "Installation Scope:" 15 70 2 \
"1_ROOT" "System-wide via $PKG_MGR (requires sudo)" \
"2_USER" "Local via vcpkg in ~/.vcpkg (sudo for base tools)" 3>&1 1>&2 2>&3)
[ -z "$INSTALL_MODE" ] && exit 0

CATEGORIES=$(whiptail --title "$TITLE" --checklist "Select Categories to Configure:" 15 65 3 \
"CORE" "Compilers, Build Tools, Debuggers, Linters" ON \
"LIBS" "Data, Math, Networking, Testing Libs" ON \
"FRAMEWORKS" "GUI, Media, Vision, Graphics" OFF 3>&1 1>&2 2>&3)
[ -z "$CATEGORIES" ] && exit 0

SELECTED_APPS=""

if [[ $CATEGORIES == *"CORE"* ]]; then
    CORE_CHOICES=$(whiptail --title "Core Tools" --checklist "Select Core Tools:" 22 75 15 \
    "GCC" "GNU Compiler Collection" ON \
    "Clang" "LLVM C++ Compiler" OFF \
    "CMake" "Cross-platform build system" ON \
    "Ninja" "Fast build system" OFF \
    "Make" "Standard build tool" ON \
    "GDB" "GNU Debugger" ON \
    "LLDB" "LLVM Debugger" OFF \
    "Valgrind" "Memory debugging" OFF \
    "Cppcheck" "Static analysis" OFF \
    "ClangFormat" "Code formatting" OFF \
    "ClangTidy" "Code linter" OFF \
    "CCache" "Compiler cache" OFF \
    "Doxygen" "Documentation generator" OFF \
    "vcpkg" "Microsoft Package Manager" ON 3>&1 1>&2 2>&3)
    SELECTED_APPS="$SELECTED_APPS $CORE_CHOICES"
fi

if [[ $CATEGORIES == *"LIBS"* ]]; then
    LIB_CHOICES=$(whiptail --title "Libraries" --checklist "Select Libraries:" 22 75 14 \
    "Boost" "Portable C++ libraries" OFF \
    "fmt" "Formatting library" OFF \
    "json" "nlohmann JSON" OFF \
    "spdlog" "Fast logging" OFF \
    "Catch2" "Testing framework" OFF \
    "GTest" "Google Test framework" OFF \
    "cURL" "Network requests" OFF \
    "OpenSSL" "Cryptography" OFF \
    "SQLite3" "Embedded database" OFF \
    "Poco" "Network/Internet libs" OFF \
    "Eigen" "Linear algebra math" OFF \
    "yaml-cpp" "YAML parser" OFF \
    "zlib" "Compression" OFF 3>&1 1>&2 2>&3)
    SELECTED_APPS="$SELECTED_APPS $LIB_CHOICES"
fi

if [[ $CATEGORIES == *"FRAMEWORKS"* ]]; then
    FW_CHOICES=$(whiptail --title "Frameworks" --checklist "Select Frameworks:" 20 75 10 \
    "Qt5" "Cross-platform GUI (Legacy)" OFF \
    "Qt6" "Cross-platform GUI (Modern)" OFF \
    "SDL2" "Media & Game library" OFF \
    "SFML" "Simple Fast Media Lib" OFF \
    "OpenCV" "Computer Vision" OFF \
    "wxWidgets" "Native GUI framework" OFF \
    "GTKmm" "C++ interface for GTK" OFF \
    "GLEW" "OpenGL Extension Wrangler" OFF \
    "GLFW" "OpenGL Window/Input" OFF 3>&1 1>&2 2>&3)
    SELECTED_APPS="$SELECTED_APPS $FW_CHOICES"
fi

SELECTED_APPS=$(echo $SELECTED_APPS | tr -d '"')
[ -z "$SELECTED_APPS" ] && { echo "Nothing selected. Exiting."; exit 0; }

clear
echo "Starting Installation via $PKG_MGR..."
eval "$PM_UPDATE"

contains() { [[ " $SELECTED_APPS " =~ " $1 " ]]; }

CORE_TOOLS="GCC Clang CMake Ninja Make GDB LLDB Valgrind Cppcheck CCache Doxygen ClangFormat ClangTidy"
SYS_PKGS=""
for tool in $CORE_TOOLS; do
    if contains "$tool"; then
        SYS_PKGS="$SYS_PKGS $(get_system_pkg $tool)"
    fi
done

if [ -n "$SYS_PKGS" ]; then
    echo "Installing core tools..."
    eval "$PM_INSTALL $SYS_PKGS"
fi

if contains "vcpkg"; then
    if [ ! -d "$HOME/vcpkg" ]; then
        eval "$PM_INSTALL zip unzip tar pkg-config"
        git clone https://github.com/Microsoft/vcpkg.git "$HOME/vcpkg"
        "$HOME/vcpkg/bootstrap-vcpkg.sh"
        "$HOME/vcpkg/vcpkg" integrate install
    else
        cd "$HOME/vcpkg" && git pull && ./bootstrap-vcpkg.sh
    fi
    VCPKG_CMD="$HOME/vcpkg/vcpkg"
fi

ALL_DEPS="Boost fmt json spdlog Catch2 GTest cURL OpenSSL SQLite3 Poco Eigen yaml-cpp zlib Qt5 Qt6 SDL2 SFML OpenCV wxWidgets GTKmm GLEW GLFW"

for dep in $ALL_DEPS; do
    if contains "$dep"; then
        SYS_NAME=$(get_system_pkg "$dep")
        VCPKG_NAME=$(get_vcpkg_pkg "$dep")

        if [ "$INSTALL_MODE" = "1_ROOT" ]; then
            echo "Installing $dep (apt/dnf/pacman)..."
            eval "$PM_INSTALL $SYS_NAME"
        elif [ "$INSTALL_MODE" = "2_USER" ]; then
            if contains "vcpkg"; then
                echo "Installing $dep (vcpkg)..."
                $VCPKG_CMD install "$VCPKG_NAME"
            else
                echo "Fallback to system manager for $dep..."
                eval "$PM_INSTALL $SYS_NAME"
            fi
        fi
    fi
done

echo "========================================="
echo " Setup Complete!"
echo "========================================="
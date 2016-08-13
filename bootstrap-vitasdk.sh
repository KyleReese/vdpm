#!/bin/sh

VITASDK_VER=a027b34a22e39939bd8ce98407289d8bded78e4b

case "$(uname -s)" in
   Darwin*)
    VITASDK_PLATFORM=mac
    UNIX=true
    mkdir -p /usr/local/vitasdk
   ;;

   Linux*)
    VITASDK_PLATFORM=linux
    UNIX=true
    if [ -n "${TRAVIS}" ]; then
        sudo apt-get install libc6-i386 lib32stdc++6 lib32gcc1 patch
    fi
    sudo mkdir -p /usr/local/vitasdk
    sudo chown $USER:$USER /usr/local/vitasdk
   ;;

   MSYS*)
    UNIX=false
    pacman -Syu --noconfirm make git wget p7zip tar cmake
    mkdir -p /usr/local/
   ;;

   CYGWIN*|MINGW32*)
    echo "Please use msys2. Exiting..."
    exit 1
   ;;

   *)
     echo "Unknown OS"
     exit 1
    ;;
esac

if [ "${UNIX}" = true ]; then
    wget -O "vitasdk-nightly.tar.bz2" "https://bintray.com/vitasdk/vitasdk/download_file?file_path=vitasdk-gcc-5.4-${VITASDK_PLATFORM}-nightly-${VITASDK_VER}.tar.bz2"
    tar xf "vitasdk-nightly.tar.bz2" -C /usr/local/vitasdk --strip-components=1
else
    wget -O "vitasdk-nightly.zip" "https://bintray.com/vitasdk/vitasdk/download_file?file_path=vitasdk-gcc-5.4-win32-nightly-${VITASDK_VER}.zip"
    7z x -o/usr/local/vitasdk vitasdk-nightly.zip
fi
echo "Please add the following to the bottom of your .bashrc:"
echo "export VITASDK=/usr/local/vitasdk"
echo "export PATH=$VITASDK/bin:$PATH"
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

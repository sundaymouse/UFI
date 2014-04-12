#!/bin/bash
# Version: 0.01
# Copyright sundaymouse 2014
# License: MIT License
# ffmpeg_ubuntu_install.sh: To efficiently produce production environment of ffmpeg encoding, written by sundaymouse (me@sundaymouse.com)
# Usage: chmod +x ffmpeg_ubuntu_install.sh && ./ffmpeg_ubuntu_install.sh ; And enjoy.

echo "This is sundaymouse's ffmpeg quick distribution script, quires: me@sundaymouse.com ."
echo "This script will install ffmpeg and its components (x264, libass, libvpx, yasm, libfdk-aac, etc.)."
echo "This script should work on ubuntu systems > 11.04, not tested with versions under that."
read -p "Press [Enter] key to start backup..."

echo "ffmpeg_ubuntu_install.sh: Installing dependencies..."
sudo apt-get update
sudo apt-get -y install autoconf automake build-essential libass-dev libgpac-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev \
  libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev fontconfig libmp3lame-dev unzip
fc-cache -fv
mkdir ~/ffmpeg_sources
echo "ffmpeg_ubuntu_install.sh: Installation of dependencies is complete."

echo "ffmpeg_ubuntu_install.sh: Installing yasm..."
cd ~/ffmpeg_sources
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar xzvf yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install
make distclean
export "PATH=$PATH:$HOME/bin"
echo "ffmpeg_ubuntu_install.sh: Installation of yasm is complete."

echo "ffmpeg_ubuntu_install.sh: Installing x264..."
cd ~/ffmpeg_sources
wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
tar xjvf last_x264.tar.bz2
cd x264-snapshot*
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install
make distclean
echo "ffmpeg_ubuntu_install.sh: Installation of x264 is complete."

echo "ffmpeg_ubuntu_install.sh: Installing libfdk-aac..."
cd ~/ffmpeg_sources
wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
unzip fdk-aac.zip
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
echo "ffmpeg_ubuntu_install.sh: Installation of libfdk-aac is complete."

echo "ffmpeg_ubuntu_install.sh: Installing libopus..."
cd ~/ffmpeg_sources
wget http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
tar xzvf opus-1.1.tar.gz
cd opus-1.1
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
echo "ffmpeg_ubuntu_install.sh: Installation of libopus is complete."

echo "ffmpeg_ubuntu_install.sh: Installing libvpx..."
cd ~/ffmpeg_sources
wget http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2
tar xjvf libvpx-v1.3.0.tar.bz2
cd libvpx-v1.3.0
./configure --prefix="$HOME/ffmpeg_build" --disable-examples
make
make install
make clean
echo "ffmpeg_ubuntu_install.sh: Installation of libvpx is complete."

echo "ffmpeg_ubuntu_install.sh: Installing ffmpeg..."
cd ~/ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
export PKG_CONFIG_PATH
./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" \
   --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin" --extra-libs="-ldl" --enable-gpl \
   --enable-libass --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libtheora \
   --enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree --enable-x11grab --enable-fontconfig
make
make install
make distclean
hash -r
echo "ffmpeg_ubuntu_install.sh: Installation of ffmpeg is complete."

echo "Creating environment variables..."
echo "MANPATH_MAP $HOME/bin $HOME/ffmpeg_build/share/man" >> ~/.manpath
. ~/.profile
echo "Environment variables complete."

echo "Your ffmpeg instance is installed at ~/bin"
echo "Automatic installation complete, should you have any quires, please contact me@sundaymouse.com / http://sundaymouse.com"
echo "Enjoy."

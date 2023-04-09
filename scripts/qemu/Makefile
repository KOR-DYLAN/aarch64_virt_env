mkfile_path	:= $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir	:= $(dir $(mkfile_path))
top_dir		:= $(abspath $(mkfile_dir)/../..)
binary_dir	:= $(top_dir)/bin/qemu
source_dir	:= $(top_dir)/qemu
nproc		:= $(shell nproc)

target		:=aarch64-softmmu,aarch64-linux-user
flags		:=--enable-modules 
flags		+=--enable-nettle 
flags		+=--enable-attr 
flags		+=--enable-cap-ng 
flags		+=--enable-libusb 
flags		+=--enable-libnfs 
flags		+=--enable-vhost-net 
flags		+=--enable-linux-aio 
flags		+=--enable-vnc 
flags		+=--enable-sdl 
flags		+=--enable-curses 
flags		+=--enable-virtfs 
flags		+=--enable-slirp 

packages	:=libslirp-dev 
packages	+=libglib2.0-dev 
packages	+=libfdt-dev 
packages	+=libpixman-1-dev 
packages	+=zlib1g-dev 
packages	+=ninja-build
packages	+=git-email 
packages	+=libaio-dev 
packages	+=libbluetooth-dev 
packages	+=libcapstone-dev 
packages	+=libbrlapi-dev 
packages	+=libbz2-dev
packages	+=libaio-dev 
packages	+=libbluetooth-dev 
packages	+=libcapstone-dev 
packages	+=libbrlapi-dev 
packages	+=libbz2-dev
packages	+=libcap-ng-dev 
packages	+=libcurl4-gnutls-dev 
packages	+=libgtk-3-dev
packages	+=libibverbs-dev 
packages	+=libjpeg8-dev 
packages	+=libncurses5-dev 
packages	+=libnuma-dev
packages	+=librbd-dev 
packages	+=librdmacm-dev
packages	+=libsasl2-dev 
packages	+=libsdl2-dev 
packages	+=libseccomp-dev 
packages	+=libsnappy-dev 
packages	+=libssh-dev
packages	+=libvde-dev 
packages	+=libvdeplug-dev 
packages	+=libvte-2.91-dev 
packages	+=libxen-dev 
packages	+=liblzo2-dev
packages	+=xfslibs-dev 
packages	+=valgrind 
packages	+=libnfs-dev 
packages	+=libiscsi-dev

all:

config:
	mkdir -p $(binary_dir)
	cd $(binary_dir) && $(source_dir)/configure --target-list=$(target) $(flags)

build:
	$(MAKE) -C $(binary_dir) -j $(nproc)

install-dependency:
	sudo apt build-dep qemu -y
	sudo apt install $(packages) -y

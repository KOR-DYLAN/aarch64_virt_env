MAKEFILE_PATH	:= $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR	:= $(dir $(MAKEFILE_PATH))
BINARY_DIR		:= $(MAKEFILE_DIR)/bin
BUILD_DIR		:= $(MAKEFILE_DIR)/build

KBUILD			:= $(BUILD_DIR)/linux
KSOURCE			:= $(MAKEFILE_DIR)/linux

BR_BUILD		:= $(BUILD_DIR)/buildroot
BR_SOURCE		:= $(MAKEFILE_DIR)/buildroot

QEMU			:= $(BINARY_DIR)/qemu/qemu-system-aarch64
QEMU_IMG		:= $(BINARY_DIR)/qemu/qemu-img
CROSS_COMPILE	:= $(BINARY_DIR)/aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-

NPROC			:= $(shell nproc)
ARCH			:= arm64
KDEF_CFG		:= qemu_defconfig
BR_DEF_CFG		:= custom_qemu_aarch64_virt_defconfig

MACHINE			:= virt
CPU				:= cortex-a53
SMP				:= 1
ROOTFS			:= $(BR_BUILD)/images/rootfs.ext4
IMAGE			:= $(KBUILD)/arch/arm64/boot/Image
VMLINUX			:= $(KBUILD)/vmlinux
BOOTARGS		:= "rw earlyprintk loglevel=8 rootwait root=/dev/vda console=ttyAMA0"
QFLAGS			:= -netdev user,id=eth0 -device virtio-net-device,netdev=eth0 
QFLAGS			+= -drive file=$(ROOTFS),if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0
QFLAGS			+= -nographic

V				?= 0

ifeq ($(V),0)
Q:=@
endif

phony+=defconfig
defconfig:
	$(Q)$(MAKE) -C $(KSOURCE) ARCH=$(ARCH) O=$(KBUILD) CROSS_COMPILE=$(CROSS_COMPILE) $(KDEF_CFG)

phony+=xconfig
xconfig:
	$(Q)$(MAKE) -C $(KSOURCE) ARCH=$(ARCH) O=$(KBUILD) CROSS_COMPILE=$(CROSS_COMPILE) xconfig

phony+=build
build:
	$(Q)$(MAKE) -C $(KSOURCE) ARCH=$(ARCH) O=$(KBUILD) CROSS_COMPILE=$(CROSS_COMPILE) Image modules dtbs -j $(NPROC)

phony+=clean
clean:
	$(Q)$(MAKE) -C $(KSOURCE) ARCH=$(ARCH) O=$(KBUILD) CROSS_COMPILE=$(CROSS_COMPILE) clean

phony+=br_defconfig
br_defconfig:
	$(Q)$(MAKE) -C $(BR_SOURCE) O=$(BR_BUILD) EXTERNAL_TOOLCHAIN_PATH=$(CROSS_COMPILE) $(BR_DEF_CFG)

phony+=br_xconfig
br_xconfig:
	$(Q)$(MAKE) -C $(BR_SOURCE) O=$(BR_BUILD) xconfig

phony+=br_build
br_build:
	$(Q)$(MAKE) -C $(BR_SOURCE) O=$(BR_BUILD) -j $(NPROC)

phony+=br_clean
br_clean:
	$(Q)$(MAKE) -C $(BR_SOURCE) O=$(BR_BUILD) clean

phony+=run
run:
	$(Q)$(QEMU) \
        -machine $(MACHINE) \
		-cpu $(CPU) \
		-smp $(SMP) \
        -kernel $(IMAGE) \
        -append $(BOOTARGS) \
        $(QFLAGS)

phony+=debug
debug:
	$(Q)$(QEMU) \
        -machine $(MACHINE) \
		-cpu $(CPU) \
		-smp $(SMP) \
        -kernel $(VMLINUX) \
        -append $(BOOTARGS) \
        $(QFLAGS) \
		-s -S

phony+=get_dts
get_dts:
	$(Q)$(QEMU) \
        -machine $(MACHINE) \
		-cpu $(CPU) \
		-smp $(SMP) \
		-machine dumpdtb=qemu.dtb \
        $(QFLAGS)
	dtc -I dtb qemu.dtb -O dts -o qemu.dts

.PHONY: $(phony)

CC=buildroot/output/host/usr/bin/i686-buildroot-linux-uclibc-gcc
MAKE=make
CFLAGS=-static -O0
MEM=128
KERNEL=buildroot/output/images/bzImage 
ROOTFS=buildroot/output/images/rootfs.ext2
JOB=20

.PHONY: run qemu copy build linux clean init

run: qemu

qemu: $(KERNEL) $(ROOTFS)
	@echo "Booting Linux with qemu...($(MEM)MB)"
	@qemu-system-x86_64 --kernel $(KERNEL) --drive format=raw,file=$(ROOTFS) --nographic --append "console=tty1 root=/dev/sda" -m $(MEM)
	
copy:
	mkdir -p mnt
	sudo mount buildroot/output/images/rootfs.ext2 mnt
	sudo rm -rf mnt/root/test
	sudo cp -r test mnt/root/
	sudo chown -R root:root mnt/root/test
	sudo umount mnt
	rmdir mnt

build: test/test_without_io test/test_with_io test/test_with_heavy_io test/nothing

test/test_with_io: test/test_with_io.c
	$(CC) $(CFLAGS) $< -o $@

test/test_without_io: test/test_without_io.c
	$(CC) $(CFLAGS) $< -o $@

test/test_with_heavy_io: test/test_with_heavy_io.c
	$(CC) $(CFLAGS) $< -o $@

test/nothing: test/nothing.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -rf test/test_with_io test/test_without_io test/nothing mnt 

.ONESHELL:
init: 
	#git clone git://git.buildroot.net/buildroot
	mkdir -p buildroot/proj2_patch
	cp proj2.patch buildroot/proj2_patch/
	cp -r files buildroot/
	mv buildroot/files buildroot/proj2_files
	@cd buildroot
	$(MAKE) qemu_x86_defconfig
	sed -i -e 's/BR2_TARGET_GENERIC_GETTY_PORT="tty1"/BR2_TARGET_GENERIC_GETTY_PORT="ttyS0"/g' .config
	sed -i -e 's/BR2_LINUX_KERNEL_PATCH=""/BR2_LINUX_KERNEL_PATCH="proj2_patch"/g' .config
	sed -i -e 's/BR2_ROOTFS_OVERLAY=""/BR2_ROOTFS_OVERLAY="proj2_files"/g' .config
	make -j$(JOB)

linux:
	@cd buildroot
	make -j$(JOB) linux-rebuild


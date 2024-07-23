# Make file for the potatOs
# for now only bootloader

AS=yasm 
bootloader=bootloader.asm
load_kernel=kernel_load.asm
kernel=kernel.c
includes=
VM=qemu-system-i386
BUILD_DIR=./build
FINAL=./os

.phony: all bootloader clean kernel

all:bootloader  kernel
	dd if=/dev/zero of=$(FINAL)/potatOs.img bs=512 count=10
	cat $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/kernel.bin > $(BUILD_DIR)/bootloader_and_kernel.img
	dd if=$(BUILD_DIR)/bootloader_and_kernel.img  of=$(FINAL)/potatOs.img conv=notrunc bs=512

bootloader: $(bootloader)
	mkdir -p $(BUILD_DIR) $(FINAL)
	$(AS) $(bootloader) $(includes) -f bin -o $(BUILD_DIR)/bootloader.bin 
	
kernel:
	i386-elf-gcc -ffreestanding -m32 -g -c $(kernel) -o $(BUILD_DIR)/kernel.o
	i386-elf-ld -o $(BUILD_DIR)/kernel.bin -Tlinker.ld $(BUILD_DIR)/kernel.o --oformat binary 
	
run:all
	$(VM) $(FINAL)/potatOs.img -monitor stdio

clean: 
	@touch a.img 
	@echo "Cleaning..."
	@rm -rf build *.o os *.img

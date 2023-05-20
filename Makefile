# Make file for the potatOs
# for now only bootloader

AS=yasm 
bootloader=bootloader.asm
kernel=kernel.asm 
VM=qemu-system-x86_64
BUILD_DIR=./build/

.phony: all bootloader clean kernel

all:bootloader kernel 
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/os.img
	dd seek=1 conv=sync if=$(BUILD_DIR)/kernel.bin of=$(BUILD_DIR)/os.img bs=512

bootloader: make_dir $(bootloader)
	$(AS) $(bootloader) -f bin -o $(BUILD_DIR)/bootloader.bin 
	
kernel:
	$(AS) $(kernel) -f bin -o $(BUILD_DIR)/kernel.bin

run_boot: all
	$(VM) $(BUILD_DIR)/bootloader.bin

run:all
	$(VM) $(BUILD_DIR)/os.img
	
make_dir: clean
	@mkdir $(BUILD_DIR)

clean: 
	@echo "Cleaning..."
	@rm -rf build

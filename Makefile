# Make file for the potatOs
# for now only bootloader

AS=yasm 
bootloader=bootloader.asm
load_kernel=kernel_load.asm
kernel=kernel.cpp 
includes=
VM=qemu-system-x86_64
BUILD_DIR=./build

.phony: all bootloader clean kernel

all:bootloader  kernel
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/potatOs.img
	dd seek=1 conv=sync if=$(BUILD_DIR)/Kernel.bin of=$(BUILD_DIR)/os.img bs=512

bootloader: make_dir $(bootloader)
	$(AS) $(bootloader) $(includes) -f bin -o $(BUILD_DIR)/bootloader.bin 
	
kernel:
	i386-elf-gcc -ffreestanding -m32 -g -c $(kernel) -o $(BUILD_DIR)/kernel.o
	$(AS) $(load_kernel) -f elf -o $(BUILD_DIR)/kernel_load.o
	i386-elf-ld -o $(BUILD_DIR)/Kernel.bin -Ttext 0x1000 $(BUILD_DIR)/kernel_load.o $(BUILD_DIR)/kernel.o --oformat binary 
	
run:all
	$(VM) $(BUILD_DIR)/potatOs.img
	
make_dir: clean
	@mkdir $(BUILD_DIR)

clean: 
	@echo "Cleaning..."
	@rm -rf build *.o

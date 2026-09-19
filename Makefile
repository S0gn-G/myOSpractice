CC   = riscv64-unknown-elf-gcc
LD   = riscv64-unknown-elf-ld
CFLAGS = -Wall -Werror -O -std=gnu99 -mcmodel=medany -ffreestanding \
         -nostdlib -fno-common -ggdb -march=rv64gc -fno-stack-protector -fno-pie
QEMU = qemu-system-riscv64

K=kernel

OBJS = \
	$K/entry.o \
	$K/start.o \
	$K/console.o \
	$K/printk.o \
	$K/uart.o \
	$K/main.o \
	$K/proc.o

$K/kernel: $(OBJS) $K/kernel.ld
	$(LD) -T $K/kernel.ld -o $@ $(OBJS)

%.o: %.c kernel/riscv.h
	$(CC) $(CFLAGS) -Ikernel -c -o $@ $<

%.o: %.S
	$(CC) $(CFLAGS) -Ikernel -c -o $@ $<

# 验收环境固定(排雷环节禁止改动本行以下内容)
qemu: $K/kernel
	$(QEMU) -machine virt -bios none -kernel $K/kernel -nographic

clean:
	rm -f */*.o $K/kernel

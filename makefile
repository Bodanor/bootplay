AS = as

main.img: main.o
	ld --oformat binary -o main.img -Ttext 0x7C00 main.o

main.o:
	as -o main.o boot.s

run : main.img
	qemu-system-i386 -hda main.img

debug: main.img
	qemu-system-i386 -s -S -hda main.img

clean:
	rm -rf *.o
	rm -rf *.img
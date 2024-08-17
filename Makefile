SOURCES=pakboy.zig
EXE=pakboy.elf
NAME=pakboy
DATA_FILES=tiles.png sprites.png info.json cover.png
RIVEMU_EXEC=rivemu -quiet -no-window -sdk -workspace -exec
ZIG_FLAGS= -fsingle-threaded -fstrip -target riscv64-linux-musl -O ReleaseSmall -I. libriv.so -lc -dynamic

build: $(NAME).sqfs

clean:
	rm -f *.sqfs *.elf *.o libriv.so riv.h

$(NAME).sqfs: $(EXE) $(DATA_FILES)
	$(RIVEMU_EXEC) riv-mksqfs $^ $@

$(EXE): $(SOURCES)
	$(RIVEMU_EXEC) cp /usr/include/riv.h /usr/lib/libriv.so .
	zig build-exe $^ -femit-bin=$@ $(ZIG_FLAGS)
	$(RIVEMU_EXEC) riv-strip $@
	rm -f libriv.so riv.h

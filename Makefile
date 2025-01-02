AS = nasm
LD = ld
ASFLAGS = -f elf64 -g -F dwarf
LDFLAGS = -dynamic-linker /lib64/ld-linux-x86-64.so.2

SRC_DIR = src
BUILD_DIR = build
TEST_DIR = tests

SOURCES = $(wildcard $(SRC_DIR)/**/*.asm)
OBJECTS = $(SOURCES:%.asm=$(BUILD_DIR)/%.o)

.PHONY: all clean test

all: dirs securenetmon

dirs:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/core
	mkdir -p $(BUILD_DIR)/analysis
	mkdir -p $(BUILD_DIR)/crypto
	mkdir -p $(BUILD_DIR)/network

securenetmon: $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $^ -lc -lpcap -lcrypto

$(BUILD_DIR)/%.o: %.asm
	mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<

test:
	$(AS) $(ASFLAGS) -o $(BUILD_DIR)/test.o $(TEST_DIR)/test.asm
	$(LD) $(LDFLAGS) -o test $(BUILD_DIR)/test.o

clean:
	rm -rf $(BUILD_DIR)
	rm -f securenetmon test
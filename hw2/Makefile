# Compiler and flags
CC = /opt/riscv/bin/riscv64-unknown-elf-gcc
CFLAGS = -march=rv32i -mabi=ilp32 -Wall -Ofast

# Directories
SRC_DIR = src
BUILD_DIR = build
INCLUDE_DIR = include

# Source files and object files
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))

# Target executable
TARGET = $(BUILD_DIR)/hw2_executable

# Default rule to compile the program
all: $(TARGET)

# Link the object files to create the final executable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Compile C files to object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Create the build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Clean rule to remove build artifacts
clean:
	rm -rf $(BUILD_DIR)

# Run the program using rv32emu (ensure rv32emu is installed)
run: $(TARGET)
	rv32emu $<

# Disassemble the ELF file
disassemble: $(TARGET)
	riscv64-unknown-elf-objdump -d $(TARGET)

# Measure program's execution using QEMU (as an alternative if rv32emu is incompatible)
run_qemu: $(TARGET)
	qemu-riscv32 $(TARGET)

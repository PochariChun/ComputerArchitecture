.data
msg_fp32:    .string "FP32 Value: "    # FP32 訊息
newline:     .string "\n"              # 換行符號
colon:       .string ": "               # 分隔符號
verticalbar:  .string "| "               # 分隔符號
msg_fp16:     .string "FP16 Value: "    # Output message for absolute value

test_values: 
    .word 0x3F800000   # 1.0 in IEEE-754
    # .word 0x40490FDB   # 3.141 in IEEE-754
    # .word 0xC0490FDB   # -3.141 in IEEE-754
    # .word 0x7F7FFFFF   # 1.0e+38 in IEEE-754
    # .word 0x00000001   # Smallest positive value (denormal)
    # .word 0x7F800000   # Infinity in IEEE-754
    # .word 0x2E800000   # Very small number

# num_tests: .word 7      # Number of tests
num_tests: .word 1      # Number of tests

.text
main:
    lw a1, num_tests                   # 載入 num_tests 的值
    la a2, test_values                 # 載入 test_values 的位址
    li a3, 0                           # 初始化迴圈計數器 i = 0

    jal ra, start_tests
    li a7, 10                  # 系統呼叫：結束程式
    ecall                      # 呼叫系統


start_tests:

    addi a3, a3, 1                     # Increment the loop counter
    mv a0, a3
    li a7, 1                           # System call: print string
    ecall                              # Invoke system call
    ret                                # Return to the caller             #

    la a0, colon                       # 
    jal ra, print_string               #

    la a0, msg_fp32                    # Load the address of the FP32 message
    jal ra, print_string               # Print the FP32 message

    lw a4, 0(a2)                       # Load the current FP32 value from memory into a4
    jal ra, print_fp32_components      # Print the FP32 components

    # Convert FP32 to FP16 and print the result
    jal ra, fp32_to_fp16

    # Print newline character
    la a0, newline                     # Load the newline character address
    jal ra, print_string               # Print the newline

    addi a2, a2, 4                     # Move to the next word (next test value)
    blt a3, a1, start_tests            # If i < num_tests, continue the loop

    jr ra                              # Return to the caller

# Function: Print a string (string address in a1)
print_string:
    li a7, 4                           # System call: print string
    ecall                              # Invoke system call
    ret                                # Return to the caller

# Function: Print the components of an FP32 number (stored in a0)
print_fp32_components:
    mv t0, a4                  # Save original input value (X) in temporary register t0

    # Extract the sign bit (bit 31)
    srl t1, t0, 31                     # Shift right by 31 to get the sign bit
    mv a0, t1                          # Move the sign bit to a0 for printing
    li a7, 1                           # System call: print integer
    ecall                              # Print the sign bit

    # Print vertical bar separator
    la a0, verticalbar                 # Load the vertical bar string
    jal ra, print_string               # Print the vertical bar

    # Extract the exponent (bits 30-23)
    srl t1, t0, 23                     # Shift right by 23 to align the exponent
    andi t1, t1, 0xFF                  # Mask to get the lower 8 bits (exponent)
    mv a0, t1                          # Move the exponent to a0 for printing
    li a7, 1                           # System call: print integer
    ecall                              # Print the exponent

    # Print vertical bar separator
    la a0, verticalbar                 # Load the vertical bar string
    jal ra, print_string               # Print the vertical bar

    # Extract the mantissa (bits 22-0)
    andi t2, t0, 0x7FFFFF              # Mask to get the lowest 23 bits (mantissa)
    mv a0, t2                          # Move the mantissa to a0 for printing
    li a7, 1                           # System call: print integer
    ecall                              # Print the mantissa

    ret                                # Return to the caller

# Function: Convert FP32 to FP16 (Placeholder)
fp32_to_fp16:
    # In this placeholder, you can implement FP32-to-FP16 conversion logic.
    # Currently, we just print the FP16 message.
    mv t0, a4                  # Save original input value (X) in temporary register t0

    la a0, msg_fp16                    # Load the FP16 message address
    jal ra, print_string               # Print the FP16 message
    
    addi a0, t0, 0                      # Load the FP16 message address
    li a7, 1                           # System call: print integer
    ecall                              # Print the sign bit
    ret                                # Return to the caller
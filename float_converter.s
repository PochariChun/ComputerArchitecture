    .section .data
test_values: 
    .float 1.0                 # 0x1.0p-0f
    .float 3.141               # Pi approximation
    .float -3.141              # Negative Pi
    .float 1.0e+38             # Large positive value
    .float 1.0e-45             # Small positive value (denormal)
    .float INF                 # Infinity
    .float 0x1.0p-40f          # Very small number

num_tests: 
    .word 7                    # Number of tests

    .section .text
    .globl main

main:
    la t0, test_values          # Load address of test_values into t0
    li t1, 0                    # i = 0
    lw t2, num_tests            # Load num_tests into t2

loop:
    beq t1, t2, end             # If i == num_tests, exit loop

    # Load a test float value
    flw f0, 0(t0)               # Load the float from memory into f0

    # Print the original float
    mv a0, t1                   # Test number as argument
    jal ra, print_test_number   # Call print_test_number
    jal ra, print_float         # Call print_float to print f0

    # Compute abs(f)
    fabs.s f1, f0               # f1 = fabs(f0)

    # Print fabs(f)
    jal ra, print_fabs          # Call print_fabs to print f1

    # f1 * scale_to_inf
    li a1, 0x4b000000           # Load 0x1.0p+112f into a1 (as float bits)
    fmv.w.x f2, a1              # Convert integer a1 to float f2
    fmul.s f1, f1, f2           # f1 = f1 * scale_to_inf

    # f1 * scale_to_zero
    li a1, 0x2e800000           # Load 0x1.0p-110f into a1 (as float bits)
    fmv.w.x f2, a1              # Convert integer a1 to float f2
    fmul.s f1, f1, f2           # f1 = f1 * scale_to_zero

    # Print result float (scaled value)
    jal ra, print_scaled_result

    # Increment loop counter and pointer
    addi t1, t1, 1              # i++
    addi t0, t0, 4              # Move to the next float value
    j loop                      # Repeat loop

end:
    ret                         # Return from main

# Print a float (in f0 register)
print_float:
    # Assume syscall-based printing (platform-specific)
    fmv.x.w a1, f0              # Move float bits to a1
    li a0, 1                    # Print syscall code (assume print_float)
    ecall                       # Make the syscall
    ret

# Print fabs(f) result
print_fabs:
    li a0, 2                    # Print syscall code (assume print_fabs)
    fmv.x.w a1, f1              # Move fabs(f) bits to a1
    ecall                       # Make the syscall
    ret

# Print scaled result
print_scaled_result:
    li a0, 3                    # Print syscall code (assume print_scaled_result)
    fmv.x.w a1, f1              # Move scaled result bits to a1
    ecall                       # Make the syscall
    ret

# Print test number
print_test_number:
    li a0, 4                    # Print syscall code (assume print_test_number)
    ecall                       # Make the syscall
    ret

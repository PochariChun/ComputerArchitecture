#include "float_converter.h"
#include <stdio.h>
#include <math.h>

int main() {
    // Array of test float values
    float test_values[] = {
        0x1.0p-0f,   // 1.0
        3.141,       // Pi approximation
        -3.141,      // Negative Pi
        1.0e+38f,    // Large positive value
        1.0e-45f,    // Small positive value (denormal)
        INFINITY,    // Infinity
        0x1.0p-40f   // Very small number
    };
    int num_tests = sizeof(test_values) / sizeof(test_values[0]);

    // Loop through each test value
    for (int i = 0; i < num_tests; ++i) {
        float value = test_values[i];

        // Print the original float and its binary representation
        printf("Test #%d: Original float: %f\n", i + 1, value);
        print_binary32("Original float binary", fp32_to_bits(value));

        // Convert to fp16 and print the binary representation
        fp16_t fp16_value = fp32_to_fp16(value);
        printf("Converted to fp16: ");
        print_binary16(fp16_value);

        // Convert back to float and print
        float restored_value = fp16_to_fp32(fp16_value);
        printf("Restored float: %f\n", restored_value);
        print_binary32("Restored float binary", fp32_to_bits(restored_value));

        printf("\n");  // Add a blank line between tests for readability
    }

    return 0;
}

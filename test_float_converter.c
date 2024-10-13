#include "float_converter.h"
#include <stdio.h>
#include <math.h>

int main() {
    float test_values[] = {1.0e+38f, 1.0e-45f, INFINITY, 1.0e-40f};
    int num_tests = sizeof(test_values) / sizeof(test_values[0]);

    for (int i = 0; i < num_tests; ++i) {
        float value = test_values[i];
        printf("Test #%d: Original float: %f\n", i + 1, value);
        print_binary32(fp32_to_bits(value));

        // Convert to fp16 and print the binary representation
        fp16_t fp16_value = fp32_to_fp16(value);
        printf("Converted to fp16: ");
        print_binary16(fp16_value);

        // Convert back to float and print
        float restored_value = fp16_to_fp32(fp16_value);
        printf("Restored float: %f\n", restored_value);
        print_binary32(fp32_to_bits(restored_value));
        printf("\n");
    }

    return 0;
}

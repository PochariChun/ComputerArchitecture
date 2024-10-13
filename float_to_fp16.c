#include "float_converter.h"
#include <stdio.h>
#include <math.h>

// Convert a float to its bit representation as a uint32_t
uint32_t fp32_to_bits(float f) {
    union {
        float as_value;
        uint32_t as_bits;
    } fp32 = {.as_value = f};
    return fp32.as_bits;
}

// Convert a uint32_t bit pattern to a float
float bits_to_fp32(uint32_t bits) {
    union {
        uint32_t as_bits;
        float as_value;
    } fp32 = {.as_bits = bits};
    return fp32.as_value;
}

// Convert a float (32-bit) to fp16 (16-bit)
fp16_t fp32_to_fp16(float f) {
    const float scale_to_inf = 0x1.0p+112f;
    const float scale_to_zero = 0x1.0p-110f;
    float base = (fabsf(f) * scale_to_inf) * scale_to_zero;
    const uint32_t w = fp32_to_bits(f);
    const uint32_t shl1_w = w + w;
    const uint32_t sign = w & UINT32_C(0x80000000);
    uint32_t bias = shl1_w & UINT32_C(0xFF000000);

    if (bias < UINT32_C(0x71000000))
        bias = UINT32_C(0x71000000);

    uint32_t biased_value = (bias >> 1) + UINT32_C(0x07800000); // 142
    base = bits_to_fp32(biased_value) + base;

    const uint32_t bits = fp32_to_bits(base);
    const uint32_t exp_bits = (bits >> 13) & UINT32_C(0x00007C00);
    const uint32_t mantissa_bits = bits & UINT32_C(0x00000FFF);
    const uint32_t nonsign = exp_bits + mantissa_bits;

    return (sign >> 16) |
           (shl1_w > UINT32_C(0xFF000000) ? UINT16_C(0x7E00) : nonsign);
}

// Convert a 16-bit fp16 to 32-bit float
float fp16_to_fp32(fp16_t h) {
    const uint32_t w = (uint32_t)h << 16;
    const uint32_t sign = w & UINT32_C(0x80000000);
    const uint32_t two_w = w + w;

    const uint32_t exp_offset = UINT32_C(0xE0) << 23;
    const float exp_scale = 0x1.0p-112f;
    const float normalized_value =
        bits_to_fp32((two_w >> 4) + exp_offset) * exp_scale;

    const uint32_t mask = UINT32_C(126) << 23;
    const float magic_bias = 0.5f;
    const float denormalized_value =
        bits_to_fp32((two_w >> 17) | mask) - magic_bias;

    const uint32_t denormalized_cutoff = UINT32_C(1) << 27;
    const uint32_t result =
        sign | (two_w < denormalized_cutoff ? fp32_to_bits(denormalized_value)
                                            : fp32_to_bits(normalized_value));
    return bits_to_fp32(result);
}

// Print binary representation of a 32-bit value
void print_binary32(uint32_t n) {
    printf("%d | ", (n >> 31) & 1);
    for (int i = 30; i >= 23; i--) printf("%d", (n >> i) & 1);
    printf(" | ");
    for (int i = 22; i >= 0; i--) {
        printf("%d", (n >> i) & 1);
        if (i % 4 == 0 && i != 0) printf(" ");
    }
    printf("\n");
}

// Print binary representation of a 16-bit value
void print_binary16(uint16_t n) {
    printf("%d | ", (n >> 15) & 1);
    for (int i = 14; i >= 10; i--) printf("%d", (n >> i) & 1);
    printf(" | ");
    for (int i = 9; i >= 0; i--) {
        printf("%d", (n >> i) & 1);
        if (i % 5 == 0 && i != 0) printf(" ");
    }
    printf("\n");
}

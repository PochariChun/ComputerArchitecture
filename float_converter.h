#ifndef FLOAT_CONVERTER_H
#define FLOAT_CONVERTER_H

#include <stdint.h>

// Define fp16_t as a 16-bit unsigned integer
typedef uint16_t fp16_t;

// Function declarations
uint32_t fp32_to_bits(float f);
float bits_to_fp32(uint32_t bits);
fp16_t fp32_to_fp16(float f);
float fp16_to_fp32(fp16_t h);
void print_binary32(uint32_t n);
void print_binary16(uint16_t n);

#endif  // FLOAT_CONVERTER_H

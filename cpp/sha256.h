#ifndef __SHA256_H__
#define __SHA256_H__

#include <cstdint>
#include <string>
#include <fstream>

#define WORD_SIZE 32
#define N_ROUNDS 64
#define BLOCK_SIZE 64
/*512 bit = 64 bytes*/

typedef uint8_t byte_t;
typedef uint8_t* buffer_t;
typedef uint32_t word_t;
typedef struct sha256_t {
    uint8_t byte_at[32];
} sha256_t;
typedef struct block_t {
    uint8_t byte_at[BLOCK_SIZE];
} block_t;



sha256_t sha256(buffer_t data_in, uint64_t buffer_byte_size);

sha256_t sha256_string(std::string input_string);

sha256_t sha256_file(std::string file_path);

#endif //__SHA256_H__

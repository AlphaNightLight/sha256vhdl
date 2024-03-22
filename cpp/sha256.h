#ifndef __SHA256_H__
#define __SHA256_H__

#include <cstdint>

typedef uint8_t byte_t;
typedef uint8_t* buffer_t;
typedef uint32_t word_t;
typedef struct sha256_t {
    int8_t byte_at[32];
} sha256_t;



sha256_t sha256(buffer_t data_in, int64_t byte_size);

#endif //__SHA256_H__

/*
* The Implementation of SHA-256 hash function
*/

/// NOTE: registers are int32_t, so all additions must be considered modulo 2^32

#include <iostream>
#include "sha256.h"

using namespace std;

#define WORD_SIZE 32
#define BLOCK_SIZE 512
#define N_ROUNDS 64



// It's important to apply ShR to uintxx_t instaed of intxx_t, otherwise the shift will be aritmethic.
#define ShR(A, n) ( A >> n )
#define RotR(A, n) ( (A >> n)|(A << (WORD_SIZE-n)) )

#define CH(X,Y,Z) ( (X & Y)^((~X) & Z) )
#define MAJ(X,Y,Z) ( (X & Y)^(X & Z)^(Y & Z) )

#define SIG_0(X) ( RotR(X, 2)^RotR(X, 13)^RotR(X, 22) )
#define SIG_1(X) ( RotR(X, 6)^RotR(X, 11)^RotR(X, 25) )
#define sig_0(X) ( RotR(X, 7)^RotR(X, 18)^ShR(X, 3) )
#define sig_1(X) ( RotR(X, 17)^RotR(X, 19)^ShR(X, 10) )

const word_t K[64] = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
};

const word_t H_0[8] = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
};



sha256_t sha256(buffer_t data_in, int64_t byte_size)
{
    word_t H[8];
    for (int i=0; i<8; ++i) H[i] = H_0[i];
    word_t a, b, c, d, e, f, g, h;
    sha256_t data_out;

    word_t x = 0xf00fffaa;
    word_t y = 12;
    word_t z = K[63];
    printf("x: %08zx, y: %08zx, z: %08zx\n", x, y, z);

    return data_out;
}

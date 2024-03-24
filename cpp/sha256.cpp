/*
* The Implementation of SHA-256 hash function
*/

/// NOTE: registers are int32_t, so all additions must be considered modulo 2^32


#include "sha256.h"
//#define DEBUG

using namespace std;

#ifdef DEBUG
    #include <iostream>
#endif

void elaborate_block(block_t block, word_t H[8]);



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



void elaborate_block(block_t block, word_t H[8])
{
    word_t W[N_ROUNDS];
    word_t a, b, c, d, e, f, g, h, T1, T2;

    for (size_t i=0; i<16*4; ++i) {
        W[i/4] <<= 8;
        W[i/4] |= block.byte_at[i];
    }
    for (size_t i=16; i<N_ROUNDS; ++i) {
        W[i] = sig_1(W[i-2]) + W[i-7] + sig_0(W[i-15]) + W[i-16];
    }

    #ifdef DEBUG
        printf("Block info:\n");

        printf("Words W[i]:\n");
        for (size_t i=0; i<N_ROUNDS; ++i) {
            printf("%08zx ", W[i]);
        } printf("\n");

        printf("Initial registers H[i-1]:\n");
        for (size_t i=0; i<8; ++i) {
            printf("%08zx ", H[i]);
        } printf("\n");
    #endif

    a = H[0];
    b = H[1];
    c = H[2];
    d = H[3];
    e = H[4];
    f = H[5];
    g = H[6];
    h = H[7];

    for (size_t i=0; i<N_ROUNDS; ++i) {
        T1 = h + SIG_1(e) + CH(e,f,g) + K[i] + W[i];
        T2 = SIG_0(a) + MAJ(a,b,c);
        h = g;
        g = f;
        f = e;
        e = d + T1;
        d = c;
        c = b;
        b = a;
        a = T1 + T2;
    }

    H[0] += a;
    H[1] += b;
    H[2] += c;
    H[3] += d;
    H[4] += e;
    H[5] += f;
    H[6] += g;
    H[7] += h;

    #ifdef DEBUG
        printf("Final registers H[i]:\n");
        for (size_t i=0; i<8; ++i) {
            printf("%08zx ", H[i]);
        } printf("\n");
    #endif

    return;
}

sha256_t sha256(buffer_t data_in, uint64_t buffer_byte_size)
{
    word_t H[8];
    for (size_t i=0; i<8; ++i) H[i] = H_0[i];
    block_t block;

    uint64_t n_full_blocks = buffer_byte_size/BLOCK_SIZE;
    uint64_t residual_bytes = buffer_byte_size-(n_full_blocks*BLOCK_SIZE);

    #ifdef DEBUG
        cout << "n_full_blocks: " << n_full_blocks << ", residual_bytes: " << residual_bytes << endl;
    #endif

    for (size_t block_index=0; block_index<n_full_blocks; ++block_index) {
        for (size_t i=0; i<BLOCK_SIZE; ++i) {
            block.byte_at[i] = data_in[block_index*BLOCK_SIZE + i];
        }
        elaborate_block(block, H);
    }

    /* Prepare last block with 8 zero bytes (that will be replaced by lenght)
    and process eventual semi-last block */
    for (size_t i=0; i<residual_bytes; ++i) {
        block.byte_at[i] = data_in[n_full_blocks*BLOCK_SIZE + i];
    }

    if (residual_bytes == 0) {
        #ifdef DEBUG
            /* the message has lenght multiple of 512 bits,
            both 0x80 and length are in the extra block. */
            cout << "Full extra block" << endl;
        #endif
        block.byte_at[0] = 0x80;
        for (size_t i=1; i<BLOCK_SIZE; ++i) { block.byte_at[i] = 0; }
    } else if (residual_bytes == BLOCK_SIZE-1) {
        #ifdef DEBUG
            /* the last block has only one byte left, so 0x80 can go there
            but the length requires extra block. */
            cout << "Space for only 0x80" << endl;
        #endif
        block.byte_at[BLOCK_SIZE-1] = 0x80;
        /* This will be the semi-last block*/
        elaborate_block(block, H);
        /* as THIS will be thelast*/
        for (size_t i=0; i<BLOCK_SIZE; ++i) { block.byte_at[i] = 0; }
    } else if (residual_bytes > BLOCK_SIZE-9) {
        #ifdef DEBUG
            /* the last block has some bytes left, so 0x80 can go there,
            but not enough for the length. Wa need extra block, and to pad the semi last with zeroes. */
            cout << "Space for 0x80 and zeroes" << endl;
        #endif
        block.byte_at[residual_bytes] = 0x80;
        for (size_t i=residual_bytes+1; i<BLOCK_SIZE; ++i) { block.byte_at[i] = 0; }
        /* This will be the semi-last block*/
        elaborate_block(block, H);
        /* as THIS will be the last*/
        for (size_t i=0; i<BLOCK_SIZE; ++i) { block.byte_at[i] = 0; }
    } else {
        #ifdef DEBUG
            /* the last block has enough bytes left to hold 0x80 as well as
            the length of the message. No extra block required. */
            cout << "No extra block" << endl;
        #endif
        block.byte_at[residual_bytes] = 0x80;
        for (size_t i=residual_bytes+1; i<BLOCK_SIZE; ++i) { block.byte_at[i] = 0; }
    }

    for (size_t i=0; i<8; ++i) {
        block.byte_at[BLOCK_SIZE-1-i] = ((buffer_byte_size * 8) & (0x00000000000000ff << i*8)) >> i*8;
    }

    /* Elaborate last block, the one containing the message length */
    elaborate_block(block, H);

    /* Convert to output format */
    sha256_t data_out;
    for (size_t i=0; i<8; ++i) {
        data_out.byte_at[i*4] = ( H[i] & 0xff000000 ) >> 24;
        data_out.byte_at[i*4+1] = ( H[i] & 0x00ff0000 ) >> 16;
        data_out.byte_at[i*4+2] = ( H[i] & 0x0000ff00 ) >> 8;
        data_out.byte_at[i*4+3] = H[i] & 0x000000ff;
    }

    return data_out;
}

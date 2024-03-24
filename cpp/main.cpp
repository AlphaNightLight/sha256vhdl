/*
* A main program to test the sha256 library.
*/

#include <iostream>
#include "sha256.h"

using namespace std;

int main()
{
    uint64_t buffer_byte_size = 3;
    buffer_t data_in = new uint8_t[buffer_byte_size];
    data_in[0] = 0x61;
    data_in[1] = 0x62;
    data_in[2] = 0x63;
    //for (size_t i=0; i<buffer_byte_size; ++i) {data_in[i] = 0x61;}

    printf("data_in:\n");
    for (size_t i=0; i<buffer_byte_size; ++i) {
        printf("%02zx ", data_in[i]);
    } printf("\n");

    sha256_t data_out = sha256(data_in, buffer_byte_size);

    printf("data_out:\n");
    for (size_t i=0; i<32; ++i) {
        printf("%02zx", data_out.byte_at[i]);
        if (i%4 == 3) printf(" ");
    } printf("\n");

    delete[] data_in;
    return 0;
}

/*
* A main program to test the sha256 library.
*/

#include <iostream>
#include "sha256.h"

using namespace std;

int main()
{
    buffer_t data_in = new uint8_t[3];
    data_in[0] = 0x61;
    data_in[1] = 0x62;
    data_in[2] = 0x63;

    sha256_t data_out = sha256(data_in, 3);

    for (int i=0; i<32; ++i) {
        printf("%02hhx", (int)data_out.byte_at[i]);
        if (i%4 == 3) printf(" ");
    }
    cout << endl;

    delete[] data_in;
    return 0;
}

/*
* A main program to test the sha256 library.
*/

#include <iostream>
#include <string>
#include "sha256.h"

using namespace std;

void test_bytes();
void test_one_milion_61();
void test_strings();
void test_files();
void test_interactive();

int main()
{
    //test_bytes();
    //test_one_milion_61();
    //test_strings();
    //test_files();
    test_interactive();
    return 0;
}

void test_bytes()
{
    uint64_t buffer_byte_size = 3;
    buffer_t data_in = new uint8_t[buffer_byte_size];
    data_in[0] = 0x61;
    data_in[1] = 0x62;
    data_in[2] = 0x63;

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
    return;
}

void test_one_milion_61()
{
    uint64_t buffer_byte_size = 1000000;
    buffer_t data_in = new uint8_t[buffer_byte_size];
    for (size_t i=0; i<buffer_byte_size; ++i) {data_in[i] = 0x61;}

    printf("data_in:\nOne milion of 61\n");

    sha256_t data_out = sha256(data_in, buffer_byte_size);

    printf("data_out:\n");
    for (size_t i=0; i<32; ++i) {
        printf("%02zx", data_out.byte_at[i]);
        if (i%4 == 3) printf(" ");
    } printf("\n");

    delete[] data_in;
    return;
}

void test_strings()
{
    string input_string = "Hello World!";

    cout << "data_in:" << endl << input_string << endl;

    sha256_t data_out = sha256_string(input_string);

    printf("data_out:\n");
    for (size_t i=0; i<32; ++i) {
        printf("%02zx", data_out.byte_at[i]);
        if (i%4 == 3) printf(" ");
    } printf("\n");

    return;
}

void test_files()
{
    string file_path = "main.exe";

    cout << "data_in:" << endl << "file \"" << file_path << "\"" << endl;

    sha256_t data_out = sha256_file(file_path);

    printf("data_out:\n");
    for (size_t i=0; i<32; ++i) {
        printf("%02zx", data_out.byte_at[i]);
        if (i%4 == 3) printf(" ");
    } printf("\n");

    return;
}

void test_interactive()
{
    uint64_t n_lines;
    string intermediate_string;
    string input_string;

    cout << "How many lines has your string?" << endl;
    cin >> n_lines;
    cout << "Enter ypur string (very last newline skipped):" << endl;

    input_string = "";
    cin.ignore();
    for (size_t i=0; i<n_lines; ++i) {
        getline(cin, intermediate_string);
        input_string += intermediate_string;
        if (i != n_lines-1) {
            input_string += "\n";
        }
    }

    cout << "Detected Input:" << endl << input_string << endl;

    sha256_t data_out = sha256_string(input_string);

    printf("SHA-256:\n");
    for (size_t i=0; i<32; ++i) {
        printf("%02zx", data_out.byte_at[i]);
        if (i%4 == 3) printf(" ");
    } printf("\n");

    return;
}

#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include <math.h>
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/wavelet.h"

int
main(int argc, char **argv)
{
    stupidedi_packed_t a;

    uint16_t size = 14;
    uint8_t width = ceil(log2(size * 2));

    /*
    stupidedi_bitstring_alloc_record(size, width, &seq);
    for (int k = 0; k < size; ++k)
        stupidedi_bitstring_write_record(&seq, k, k*2);
        */

    stupidedi_packed_init(&a, 10, 3);
    stupidedi_packed_write(&a, 0, 1);
    stupidedi_packed_write(&a, 1, 0);
    stupidedi_packed_write(&a, 2, 3);
    stupidedi_packed_write(&a, 3, 2);
    stupidedi_packed_write(&a, 4, 5);
    stupidedi_packed_write(&a, 5, 3);
    stupidedi_packed_write(&a, 6, 4);
    stupidedi_packed_write(&a, 7, 0);
    stupidedi_packed_write(&a, 8, 3);
    stupidedi_packed_write(&a, 9, 1);

    stupidedi_wavelet_t w;
    stupidedi_wavelet_init(&w, &a, width);
    printf("OK\n");

    for (size_t k = 0; k < stupidedi_packed_length(&a); ++k)
    {
        uint64_t ab, aw;
        ab = stupidedi_packed_read(&a, k);
        aw = stupidedi_wavelet_access(&w, k);

        //assert(r == b);
        (aw == ab) ? printf("%llu,\n", aw) : printf("b:%llu w:%llu,\n", ab, aw);
    }

    printf("\n");

    stupidedi_packed_deinit(&a);
    stupidedi_wavelet_deinit(&w);
}
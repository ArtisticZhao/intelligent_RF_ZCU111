#ifndef __KISS_H_
#define __KISS_H_
#include <stdio.h>
#include <stdint.h>
// this file to build a KISS frame encode function
#define FEND  0xc0
#define FESC  0xdb
#define TFEND 0xdc
#define TFESC 0xdd
/* Name: get_kiss_frame
 * Func: get kiss frame from file, return 0 if end of file
 * input:
 *      fp: FILE pointer
 *      size: size of buf
 * output:
 *      buf: kiss frame buf
 * return: 0 last frame of this file
 */
char get_kiss_frame(FILE* fp, uint8_t* buf, int size);
#endif

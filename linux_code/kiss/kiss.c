#include "kiss.h"

/* Name: get_kiss_frame
 * Func: get kiss frame from file, return 0 if end of file
 * input:
 *      fp: FILE pointer
 *      size: size of buf
 * output:
 *      buf: kiss frame buf
 * return: 0 last frame of this file
 */
char get_kiss_frame(FILE* fp, uint8_t* buf, int size){
    int frame_size_count = 0;
    size_t rc;
    uint8_t data;
    // write frame start symbol
    *buf=FEND;
    buf++;
    frame_size_count++;
    while(rc = fread((void *)&data, sizeof(uint8_t), 1, fp) != 0){
        if(data==FEND){
            if(frame_size_count==size-2){
                //buf free 1 buf need 2
                fseek(fp,-sizeof(uint8_t),SEEK_CUR);
                *buf=FEND;
                buf++;
                *buf=FEND;
		buf++;
                return 1;
            }else{
                *buf=FESC;
                buf++;
                *buf=TFEND;
		buf++;
                frame_size_count+=2;
            }
        }else if(data == FESC){
            if(frame_size_count==size-2){
                //buf free 1 buf need 2
                fseek(fp,-sizeof(uint8_t),SEEK_CUR);
                *buf=FEND;
                buf++;
                *buf=FEND;
		buf++;
                return 1;
            }else{
                *buf=FESC;
                buf++;
                *buf=TFESC;
		buf++;
                frame_size_count+=2;
            }
        }else{
            *buf=data;
            buf++;
            frame_size_count++;
        }
        if(frame_size_count==size-1){
            // break before -2
            break;
        }
    }
    if(frame_size_count==size-1){
        *buf=FEND;
        return 1;
    }else{
        // read file end buf frame not full
        while(frame_size_count<size){
            frame_size_count++;
            *buf=FEND;
            buf++;
        }
        return 0;
    }
}


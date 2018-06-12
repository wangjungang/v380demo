//
//  StringToSound.h
//  iCamSee
//
//  Created by macrovideo on 15/3/25.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#ifndef __iCamSee__StringToSound__
#define __iCamSee__StringToSound__

#include <stdio.h>
#define FINISH 100
#define WORKING 101

#define DIM(arr) (sizeof(arr)/sizeof(arr[0]))
#define min(_a, _b)     (((_a) < (_b)) ? (_a) : (_b))
#define max(_a, _b)     (((_a) > (_b)) ? (_a) : (_b))

#define TONE_SR 48000
#define TONE_BASE 5000

typedef struct _T_TONE_GROUP
{
    long tone[3]; // each period has at most 3 tones
}T_TONE_GROUP;


typedef enum _T_WINDOW_ID
{
    WIN_NONE = 0,
    WIN_FULL_COS,
    WIN_TRIANLE,
    WIN_HALF_SIN
}T_WINDOW_ID;



typedef signed short            T_S16;      /* signed 16 bit integer */
typedef signed long             T_S32;      /* signed 32 bit integer */
typedef struct _T_PCM_BUF
{
    T_S16 *buf;
    long n_point;
}T_PCM_BUF;

void init_window(T_WINDOW_ID win);
T_PCM_BUF *gen_tone_wave(long freq, double amplitude, long duration, long pre_gap, long post_gap);

T_PCM_BUF *mix_tones(T_TONE_GROUP *tone_group);
#endif  


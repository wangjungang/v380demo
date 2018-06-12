//
//  StringToSound.c
//  iCamSee
//
//  Created by macrovideo on 15/3/25.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#include "StringToSound.h"

// tone.cpp : Defines the entry point for the console application.
//
#include <stdlib.h>
#include <math.h>
#include <string.h>

const long window_cycle = 20; // ms
const double pi = 3.141592654;



/********* static variables **********/
static double *window;
static long window_half_size;

/********* start of func **********/

// generate window
//   Window is a symmetric envelope.
//   apply first half of window to start of the sine waves.
//   apply reverse order of half window to ending of the sine waves.
void init_window(T_WINDOW_ID win)
{
    double t;
    
    window_half_size = window_cycle*TONE_SR / 1000 / 2; // exclude 0 and 1
    window = (double *)malloc(window_half_size * sizeof(window[0]));
    
    switch (win)
    {
        case WIN_FULL_COS:
            t = 2*pi*1000/window_cycle/TONE_SR;
            for (int i=0; i<window_half_size; i++)
            {
                window[i] = (1 - cos(t*i)) / 2;
            }
            break;
            
        case WIN_TRIANLE:
            for (int i=0; i<window_half_size; i++)
            {
                window[i] = (double)i/window_half_size;
            }
            break;
            
        case WIN_HALF_SIN:
            t = pi*1000/window_cycle/TONE_SR;
            for (int i=0; i<window_half_size; i++)
            {
                window[i] = sin(t*i);
            }
            break;
            
        default:
            for (int i=0; i<window_half_size; i++)
            {
                window[i] = 1;
            }
            break;
    }
}

//gen_tone_wave Generate a tone wave vector
//   the output is a buffer that consist of pre-silence, sine waves and post-silence.
//       freq:       frequency of the tone (Hz)
//       amplitude:  amplitude of the wave, (-1, 1)
//       duration:   duration of the wave in ms, not including pre- and post- silence
//       pre_gap:    silence in ms that lead the wave
//       post_gap:   silence in ms that follow the wave
T_PCM_BUF *gen_tone_wave(long freq, double amplitude, long duration, long pre_gap, long post_gap)
{
    static T_S16 period_pcm16[TONE_SR/10]; // temp buf to store generated PCM, 100ms max
    static T_PCM_BUF tone_pcm;
    
    double t = 2*pi*freq/TONE_SR;
    long period_len = (duration+pre_gap+post_gap)*TONE_SR/1000;
    long tone_len = duration*TONE_SR/1000;
    T_S16 *tone_pcm16 = &period_pcm16[pre_gap*TONE_SR/1000]; // tone is after pre-gap
    int i;
    
    memset(period_pcm16, 0, period_len * sizeof(period_pcm16[0]));
    tone_pcm.buf = period_pcm16;
    tone_pcm.n_point = period_len;
    
    // fill tone (sin waves)
    for (i=0; i<tone_len; i++)
    {
        double sample_f = sin(t * i) * amplitude;
        tone_pcm16[i] = (T_S16)(sample_f * 32767);
    }
    
    // apply window
    for (i=0; i<window_half_size; i++)
    {
        // entry
        tone_pcm16[i] = (T_S16)(window[i] * tone_pcm16[i]);
        // leave
        tone_pcm16[tone_len-window_half_size+i] = (T_S16)(window[window_half_size-1-i] * tone_pcm16[tone_len-window_half_size+i]);
    }
    
    return &tone_pcm;
}


T_PCM_BUF *mix_tones(T_TONE_GROUP *tone_group)
{
    static T_S32 period_pcm32[TONE_SR/10]; // temp buf to store generated PCM, 100ms max
    static T_PCM_BUF period_pcm;
    
    long n_tone = 0;
    
    period_pcm.n_point = 0;
    memset(period_pcm32, 0, sizeof(period_pcm32));
    
    //mix tones
    for (int i=0; i<DIM(tone_group->tone); i++)
    {
        if (tone_group->tone[i] != 0)
        {
            T_PCM_BUF *tone_pcm;
            
            tone_pcm = gen_tone_wave(tone_group->tone[i], 0.95, 50, 0, 0);
            
            for (int j= 0; j<tone_pcm->n_point; j++)
            {
                period_pcm32[j] += tone_pcm->buf[j];
            }
            
            period_pcm.n_point = tone_pcm->n_point;
            n_tone++;
        }
    }
    
    // average, and convert to 16bit format
    T_S16 *period16 = (T_S16 *)period_pcm32;
    for (int i=0; i<period_pcm.n_point; i++)
    {
        period16[i] = (T_S16)(period_pcm32[i]/n_tone);
    }
    period_pcm.buf = period16;
    
    return &period_pcm;
}


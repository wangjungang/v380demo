//
//  StringToSoundMaker.m
//  iCamSee
//
//  Created by macrovideo on 15/3/25.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import "StringToSoundMaker.h"
#include "StringToSound.h"

#import "AppDelegate.h"


const long TONE_CODE_HIGH_CANDIDATE[] = {
    6500+TONE_BASE,
    6000+TONE_BASE,
    5500+TONE_BASE,
    5000+TONE_BASE,
};
const long TONE_CODE_LOW_CANDIDATE[] = {
    4000+TONE_BASE,
    3500+TONE_BASE,
    3000+TONE_BASE,
    2500+TONE_BASE,
};

const long TONE_SYNC_CANDIDATE[] = {
    1500+TONE_BASE,
    1000+TONE_BASE
};

// start section is formed by 2 groups
const T_TONE_GROUP START_GROUPS[] = {
    {8500+TONE_BASE},
    {7500+TONE_BASE}
};
// end section is form by 1 group
const T_TONE_GROUP END_GROUPS[] = {
    {0+TONE_BASE}
};


const T_WINDOW_ID tone_window = WIN_FULL_COS;

@interface StringToSoundMaker(){

  
}

-(void)generateTone:(char *) str size:(long) str_size;
@end

@implementation StringToSoundMaker
@synthesize soundPlayer;

-(instancetype)init{

    self=[super init];
    if (self) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate retain];
        if (delegate) {
//            [self setSoundPlayer:delegate._soundPlayer];
        }
        [delegate release];
    }
    return self;
}

-(void)dealloc{

//    [soundPlayer stopSound];
//    [soundPlayer cleanUpOpenAL];
//    [soundPlayer release];
    
    soundPlayer=nil;
    
    [super dealloc];
}

-(BOOL)PlayStringAsSound:(NSString *)strContent{
  
    NSLog(@"PlayStringAsSound: ");//add for test
    
    char *pContent = (char *)[strContent UTF8String];
 
    [soundPlayer stopSound];
    
    [soundPlayer playSound];
    for (int i=0; i<2; i++) {
        [self generateTone:pContent size:strlen(pContent)];
    }
    
     NSLog(@"PlayStringAsSound: end");//add for test
    return YES;
}

-(BOOL)StopPlayStringAsSound{
    [soundPlayer stopSound];
    return YES;
}

-(BOOL)PutData:(char *)pData size:(int) nSize{
    if (pData && nSize>0) {
        [soundPlayer putStrAudioDataToQueue:pData Size:nSize];
    }
    
    return YES;
}

-(BOOL)Finish{
    [NSThread sleepForTimeInterval:0.2];
    
     return YES;
}



-(void)generateTone:(char *) str size:(long) str_size
{
    int i;
    
    
    // copy input string to internal buffer, crc is the last byte
    char *text_sequence = (char *)malloc(str_size + 1);
    memcpy(text_sequence, str, str_size);
    char crc = 0;
    for (i=0; i<str_size; i++)
    {
        crc ^= text_sequence[i];
    }
    text_sequence[i] = crc;
    str_size++;
    
    
    // transform text to code
    long code_size = str_size * 2;
    char *code = (char *)malloc(code_size); // code is a vector, each code number is represented by a single period
    for (i=0; i<str_size; i++)
    {
        code[2*i] = (text_sequence[i]>>4) & 0xf;
        code[2*i+1] = text_sequence[i] & 0xf;
    }
    
    
    // tone_group_sequence is a matric to store tone frequencies of the whole text sequence, including start + code + crc + stop
    long n_group = DIM(START_GROUPS) + code_size + DIM(END_GROUPS);
    T_TONE_GROUP *tone_group_sequence = (T_TONE_GROUP *)malloc(n_group * sizeof(T_TONE_GROUP));
    memset(tone_group_sequence, 0, n_group * sizeof(T_TONE_GROUP));
    
    
    // START section
    long tone_group_index = 0;
    memcpy(&tone_group_sequence[tone_group_index], START_GROUPS, sizeof(START_GROUPS));
    tone_group_index = DIM(START_GROUPS); // data starts from 3rd group
    
    // code & crc section
    for (i=0; i<code_size; i++)
    {
        T_TONE_GROUP * group = &tone_group_sequence[tone_group_index];
        int tone_high = code[i] & 0x3;
        int tone_low  = (code[i]>>2) & 0x3;
        group->tone[0] = TONE_CODE_HIGH_CANDIDATE[tone_high];
        group->tone[1] = TONE_CODE_LOW_CANDIDATE[tone_low];
        group->tone[2] = TONE_SYNC_CANDIDATE[i%2]; // add a sync tone
        tone_group_index++;
    }
    
    // STOP section
    memcpy(&tone_group_sequence[tone_group_index], END_GROUPS, sizeof(END_GROUPS));
    
    // convert to wave
    long len = 0;
    init_window(tone_window);
    for (i=0;i<n_group; i++)
    {
        T_PCM_BUF *period_pcm;
        period_pcm = mix_tones(&tone_group_sequence[i]);
        
        // output
        [self PutData:(char *)period_pcm->buf size:period_pcm->n_point * 2];
      
        len += period_pcm->n_point * 2;
    }
  
}


@end

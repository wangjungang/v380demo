//
//  NVAudioRecoder.h
//  macroSEE
//
//  Created by macrovideo on 14-7-23.
//  Copyright (c) 2014年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioQueue.h>
#import <AVFoundation/AVFoundation.h>

#define AUDIO_BUFFERS 3

typedef struct tagAQCallbackStruct{
    AudioStreamBasicDescription mDataFormat;
    AudioQueueRef queue;
    AudioQueueBufferRef mBuffer[AUDIO_BUFFERS];
    AudioFileID outputFile;
    unsigned long frameSize;
    long long recPtr;
    int run;
}AQCallbackStruct, *PAQCallbackStruct;

@interface NVAudioRecoder : NSObject

@end

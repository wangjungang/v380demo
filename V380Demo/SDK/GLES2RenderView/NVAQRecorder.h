//
//  NVAQRecorder.h
//
//  Created by macrovideo on 14-7-24.
//
//

#include <AudioToolbox/AudioToolbox.h>
#include <Foundation/Foundation.h>



#define kNumberRecordBuffers	3

#define kBufferDurationSeconds  0.063125   //(这个很重要，官方是0.5，就永远是8000，只有设置了0.02就是你想要的320长度了。同理640就是0.04, 0.32->512）

#define SAMPLES_PER_SECOND     8000.0F
#define BITS_PER_CHANEL   16

@interface NVAQRecorder : NSObject{

    BOOL isRunning;
    AudioQueueRef				mQueue;
    AudioStreamBasicDescription mRecordFormat;
    AudioQueueBufferRef			mBuffers[kNumberRecordBuffers];
    
}

@property (assign) id user;
@property (assign) int nID;
@property (assign) int mRecordPacket;
@property (assign) AudioQueueRef mQueue;
-(void)StartRecord;
-(void)StopRecord;
-(BOOL)IsRunning;
 

-(int)ComputeRecordBufferSize:(AudioStreamBasicDescription *) format time:(float) seconds;
@end
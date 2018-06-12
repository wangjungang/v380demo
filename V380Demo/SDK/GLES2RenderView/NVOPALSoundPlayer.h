#import <UIKit/UIKit.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
 

@interface NVOPALSoundPlayer : NSObject{
    ALCcontext *mContext;
    ALCdevice *mDevice;
    ALuint outSourceID;
    
    NSMutableDictionary* soundDictionary;
    NSMutableArray* bufferStorageArray;
    
    ALuint buff;
    NSTimer* updataBufferTimer;
    BOOL isPlaying;
    
    NSCondition* ticketCondition;
    char *pAudioData;
    int nDataSize;
    BOOL isInit;
}

@property (nonatomic) ALCcontext *mContext;
@property (nonatomic) ALCdevice *mDevice;

@property (nonatomic,retain)NSMutableDictionary* soundDictionary;
@property (nonatomic,retain)NSMutableArray* bufferStorageArray;

-(void)initOpenAL;
- (void)openAudioFromQueue:(unsigned char*)data dataSize:(UInt32)dataSize;
- (void)putAudioDataToQueue:(NSData *)data;
- (void)putAudioDataToQueue:(char *)pData Size:(int)nSize;
- (void)putStrAudioDataToQueue:(char *)pData Size:(int)nSize;//add by luo 20150331
-(void)playSound;
- (void)playSound:(NSString*)soundKey;

//如果声音不循环，那么它将会自然停止。如果是循环的，你需要停止
-(void)stopSound;
- (void)stopSound:(NSString*)soundKey;

-(void)cleanUpOpenAL;
-(void)cleanUpOpenAL:(id)sender;
@end
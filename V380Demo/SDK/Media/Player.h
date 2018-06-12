//
//  Player.h
//  iOSEchoCancellation
//
//  Created by 雷博文 on 16/11/19.
//  Copyright © 2016年 lixing123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Player : NSObject{
    BOOL isRunning;
    
}
@property(nonatomic,assign) NSMutableData *audioBuffer;
@property(nonatomic,assign) int recIndex;
@property(nonatomic,assign) int bufferSize;


@property (assign) id user;
-(void)StartRecord;
-(void)StopRecord;
-(BOOL)IsRunning;
-(void)SetAudioUnit;
-(void)UninitializeAudioUnit;
@end

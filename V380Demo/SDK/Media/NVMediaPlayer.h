//
//  NVMediaPlayer.h
//  OpenGLES2ShaderRanderDemo
//
//  Created by cyh on 12. 11. 26..
//  Copyright (c) 2012년 cyh3813. All rights reserved.
//
/*
 20161122
 处理摄像头端 handle值改变需接收通知 CAM_HANDLE_CHANGE
 */
#import "Player.h"
#import <UIKit/UIKit.h>
//player

#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioQueue.h>

#import "LoginHandle.h"

#import "RecFileInfo.h"
#import "Player.h"

#import "NVMediaPlayer.h"

#import "PlaybackDelegate.h"

@interface NVMediaPlayer : UIView
@property (nonatomic,strong) Player *aqRecorder;
@property (assign) id<PlaybackDelegate> playbackDelegate;



-(BOOL)scale:(CGFloat)scale;

-(void)clearView;

-(BOOL)StartPlay:(int)nChn streamType:(int) nStreamType  audio:(BOOL)bEnable loginHandel:(LoginHandle *)deviceParam;

-(BOOL)StopPlay;

-(BOOL) isShotcutEnable;

-(void)SetAudioParam:(BOOL)bEnable;

-(void)SetLightControl:(int)lightparam;

///
-(void) SetImageOrientation:(int)nOrentation;//add by luo 20150106

-(void)SetPTZActionLeft:(BOOL)left Right:(BOOL)right Up:(BOOL)up Down:(BOOL)down step:(int)nStep;


//回放云端文件
-(BOOL)StartCloudPlayBack:(int)nAccountID devID:(int)nDeviceID pToken:(NSString *)strPToken sToken:(NSString *)strSToken ecsip:(NSString *)strIP ecsport:(int)nPort file:(RecFileInfo *)recFile;

-(BOOL)StopCloudPlayBack;

-(int)SetCloudPlayIndex:(int)nTimeIndex;

- (void)timeIndexWhenPause: (int)pauseTimeIndex; //  20170719

- (void)resetPause; //  20170719

//回放文件

-(BOOL)StartPlayBack:(LoginHandle *)deviceParam file:(RecFileInfo *)recFile;
-(BOOL)StopPlayBack;
-(int)SetPlayIndex:(int)nTimeIndex;
-(void)ReSetPlaybackHandle:(LoginHandle*)newhandle;

//实时录像
-(BOOL)StartRecord:(NSString *)strSavePath;
-(BOOL)IsRecording;
-(BOOL)StopRecord;

-(void)showAcitvityView;
-(void)hideAcitvityView;



-(void)startSpeak;
-(void)stopSpeak;
-(BOOL)isSpeaking;
-(void)onHide;
-(void)onShow;

-(void)callPTZXLocationID:(int)nPTZXID handle:(LoginHandle *)lLoginHandle;

-(int)setPTZXLocationID:(int)nPTZXID handle:(LoginHandle *)lLoginHandle;

-(UIImage *)screenShot;//add by luo 20141120

-(void)onApplicationDidBecomeActive;
-(void)onApplicationWillResignActive;

//to hide
-(void) SetPriValueCTRL:(BOOL)bCTRL_PRI Playback:(BOOL)bPLAYBACK_PRI Receive:(BOOL)bRECEIVE_PRI Speak:(BOOL)bSpeak_PRI Audio:(BOOL)bAudio_PRI PTZ:(BOOL)bPTZ_PRI;
-(void)putAudioDataToQueue:(char *)pData Size:(int)nSize Id:(int)nID type:(int) nType;

-(void)resetRenderData;
-(void)updateRender;
-(void)EnableRender:(BOOL)IsEnable;
-(void)freshRender;
//end to hide

- (BOOL)clear;//add  by luo 20160930

-(BOOL)focusIn:(int) nStep;
-(BOOL)focusOut:(int) nStep;
@end

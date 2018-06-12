//
//  NVMediaPlayer.h
//  OpenGLES2ShaderRanderDemo
//
//  Created by cyh on 12. 11. 26..
//  Copyright (c) 2012년 cyh3813. All rights reserved.
//

#import <UIKit/UIKit.h>
//player
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioQueue.h>

#import "LoginHandle.h"

#import "RecFileInfo.h"
#import "HYFisheyePanoView.h"
#import "Player.h"
#import "NVPanoPlayer.h"

#import "PlaybackDelegate.h"

#define FISHEYECAMTYPEWALL 1
#define FISHEYECAMTYPETOP 2
//
@interface NVPanoPlayer : HYFisheyePanoView



@property (nonatomic, retain) UILabel *lblTimeOSD;
@property (nonatomic,strong) Player *aqRecorder;
-(BOOL)scale:(CGFloat)scale;
-(void)clearView;

//player
@property (assign) id<PlaybackDelegate> playbackDelegate;


-(BOOL)StartPlay:(int)nChn streamType:(int) nStreamType  audio:(BOOL)bEnable loginHandel:(LoginHandle *)deviceParam;

-(BOOL)StopPlay;


-(BOOL) isShotcutEnable;
//
-(void)SetAudioParam:(BOOL)bEnable;

///
-(void) SetImageOrientation:(int)nOrentation;//add by luo 20150106

-(void)SetLightControl:(int)lightparam;

-(void)SetPTZActionLeft:(BOOL)left Right:(BOOL)right Up:(BOOL)up Down:(BOOL)down step:(int)nStep;

//回放文件
-(BOOL)StartPlayBack:(LoginHandle *)deviceParam file:(RecFileInfo *)recFile;
-(BOOL)StopPlayBack;
-(int)SetPlayIndex:(int)nTimeIndex;

//download文件
-(BOOL)StartDownloadFile:(LoginHandle *)deviceParam file:(RecFileInfo *)recFile;
-(BOOL)StopDownloadFile;

-(BOOL)StartRecord;
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

- (void)SetPanoMode:(int) iMode;//add by luo 20160914

//回放云端文件
-(BOOL)StartCloudPlayBack:(int)nAccountID devID:(int)nDeviceID pToken:(NSString *)strPToken sToken:(NSString *)strSToken ecsip:(NSString *)strIP ecsport:(int)nPort file:(RecFileInfo *)recFile loginhandle:(LoginHandle*)loginhandle;

- (void)timeIndexWhenPause: (int)pauseTimeIndex; //  20170719
- (void)resetPause; //  20170719

-(BOOL)StopCloudPlayBack;
-(int)SetCloudPlayIndex:(int)nTimeIndex;
//add by lusongbin 20161104
-(void)setCamType:(int)CamType;

@end

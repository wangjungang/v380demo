//
//  PanoPlaybackController.h
//  iCamSee
//
//  Created by 视宏 on 16/9/12.
//  Copyright © 2016年 macrovideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioQueue.h>
#import "NVPanoPlayer.h"
#import "NVMediaPlayer.h"
#import "PlaybackDelegate.h"
#import "DefineVars.h"
#import "LoginHandle.h"
#import "TLTiltSlider.h"
@class CLDUser;
@class NVDevice;
@interface PanoPlaybackController : UIViewController<PlaybackDelegate>
@property (assign) BOOL m_isFullScreen;

@property (assign) BOOL m_bSoundEnable;
@property (assign) int nZoomIndex;
@property (assign) CGRect customSize;


@property (assign) int rowHeight;//



@property (nonatomic, retain) IBOutlet UIView *vPlayBackAlertView, *vDialogView;
@property (nonatomic, retain) IBOutlet UIButton *btnAlertOK, *btnAlertCancel;
@property (nonatomic, retain) IBOutlet UILabel *lnlAlertNotice;


@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UIButton *btnBackToList;
@property (nonatomic, retain) IBOutlet UILabel *headerNote;

@property (nonatomic, retain) IBOutlet UIView *imagePlayView;//the

@property (nonatomic, retain) IBOutlet UIView *bottomView;
@property (nonatomic, retain) IBOutlet UIView *vButtonsContainer;
@property (nonatomic, retain) IBOutlet UIButton *btnStopAndPlay, *btnSoundEnable, *btnPlayPrev, *btnPlayNext, *btnScreenShot;

@property (nonatomic, retain) IBOutlet UIView *vSliderContainer;
@property (nonatomic, retain) IBOutlet TLTiltSlider *playSlider;





@property (assign) BOOL isPlaying;

-(IBAction) onAlertButtonClick:(id)sender;
-(IBAction) onPlayAndStopClick:(id)sender;
-(IBAction) onSoundEnableClick:(id)sender;
-(IBAction) onBackAnStopClick:(id)sender;
-(IBAction) onPlayNextClick:(id)sender;
-(IBAction) onPlayPrevClick:(id)sender;
-(IBAction) onScreenShotClick:(id)sender;

-(IBAction) onSliderTouchDown:(id)sender;
-(IBAction) TouchUpInside:(id)sender;
-(IBAction) TouchUpOutside:(id)sender;
-(IBAction) TouchCancel:(id)sender;
-(void)screenShot;//add by luo 20141120
-(void)saveImageResult:(UIImage *)image hasBeenSavedInPhotoAlbumWithEro:(NSError *)error usingContextInfo:(void *)ctxInfo;

-(void) addGestureRecognizer;
-(void) doLocalizable;
-(void) animationDidStop;

-(void)showAlertTitel:(NSString *)titel withMessage: (NSString *)message;

-(void) SetPlayList:(NSArray *)recList handle:(LoginHandle *)lHandle playIndex:(int)nPlayIndex;

-(void) StartPlayInArea:(int) nPlayArea;
-(void) StopPlay;
-(void) StopNotice;

-(void)initInferface;
-(void)SaveSettings;//保存设置
-(void)GetSettings;//获取设置

-(void)onFinish;
-(void)onPlayAreaClick;

-(void)onApplicationDidBecomeActiveHandle:(NSNotification *)notification;
-(void)onApplicationWillResignActiveHandle:(NSNotification *)notification;

#pragma mark - 云服务录像文件回放

/** 销毁相关属性 */
- (void)tearDown;


@end

//
//  IMobilePlayerPlayController.h
//  IMobilePlayer
//
//  Created by luo king on 11-12-12.
//  Copyright 2011 cctv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioQueue.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "NVPanoPlayer.h"
//#import "PlayDelegate.h"
//#import "Defines.h"
#import "UINVMicPhoneView.h"
#import "UINVMiniImageButton.h"
#import "NVDevice.h"


//
//
//#import "UIPTZLocationNote.h"

#import "MBProgressHUD.h"



typedef enum :NSInteger {
    
    pkCameraMoveDirectionNone,
    
    pkCameraMoveDirectionUp,
    
    pkCameraMoveDirectionDown,
    
    pkCameraMoveDirectionRight,
    
    pkCameraMoveDirectionLeft,
    
    pkCameraMoveDirectionLeftUp,
    
    pkCameraMoveDirectionLeftDown,
    
    pkCameraMoveDirectionRightUp,
    
    pkCameraMoveDirectionRightDown,
    
} pCameraMoveDirection;



@interface PanoPlayViewController : UIViewController{
    BOOL isRecording;
 	BOOL isPlaying;
    uint nChannels;
	NSString *chnFlag;
	int rowHeight;//
	NSString *noteSelectAChnToPlay, *notePlayingChn;
    int nPort;
    int nChnBase;
    NSOperationQueue *operationQueue;
    CGRect customSize;
    NVPanoPlayer *nvMediaPlayer;
    int nZoomIndex;
    int nSelectedChn;
    int nSelectPlayer;
    BOOL m_bSoundEnable;
    CGRect m_rectNormal;
    CGRect m_rectFull;
    int nStep;
    int nStreamType;
    NSTimer *toolViewShowTickCountTimmer;
    int nToolViewShowTickCount;
    BOOL isBackAlertShow;
    CGFloat lastScale;
    pCameraMoveDirection direction;
    BOOL isAudioRecording;
    BOOL isReverse;
    
    UINVMicPhoneView *btnMicView;
    BOOL _zoom;
    BOOL _dim;
    BOOL _shadow;
    ///
    MBProgressHUD *HUD;
}

@property (assign) CGFloat fStepDistance;
@property (assign) CGFloat fScreenWith;
@property (assign) CGFloat fScreenHeight;
@property (assign) BOOL m_bSoundEnable;
@property (assign) int nZoomIndex;
 
@property (assign) CGRect customSize;
@property (assign) int nChnBase;
@property (nonatomic, copy) NSString *chnFlag;
@property (assign) int rowHeight;//
@property (assign) uint nChannels;
@property (nonatomic, retain) LoginHandle *_loginParam;
@property (nonatomic, retain) IBOutlet UIView *vScreenShotView;
@property (nonatomic, retain) IBOutlet UIView *topView, *bottomView;
@property (nonatomic, retain) IBOutlet UIImageView *ivTopViewBg;
@property (nonatomic, retain) IBOutlet UIButton *btnBackToList;
//
@property (nonatomic, retain) IBOutlet UIImageView *ivImagePlayViewBg;
@property (nonatomic, retain) IBOutlet UIView *imagePlayView;//the
//
@property (nonatomic, retain) IBOutlet UIView *vQLPanel;
@property (nonatomic, retain) IBOutlet UIImageView *ivQLPanelBg, *ivQLPanelSpiter;
@property (nonatomic, retain) IBOutlet UIButton *btnQualityHD, *btnQualitySmooth;

@property (nonatomic, retain) IBOutlet UIImageView *ivBottomViewBg;
@property (nonatomic, retain) IBOutlet UINVMiniImageButton *btnSoundEnable,  *btnImgQL, *btnReverseImage, *btnScreenShot, *btnBack;

@property (nonatomic, retain) IBOutlet UILabel *headerNote;
@property (retain, nonatomic) IBOutlet UIButton *btnScreenShot2;
@property (nonatomic, retain) IBOutlet UIImageView *ivTZXLanBtnBG;
//speak view
@property (nonatomic, retain) IBOutlet UILabel *lblCanSpeakNotice;
@property (nonatomic, retain) IBOutlet UIButton *btnRecord;
@property (assign) BOOL isPlaying;
-(IBAction) SoundEnableClick:(id)sender;
-(IBAction) onBackAnStopClick:(id)sender;
-(IBAction) onMicShowClick:(id)sender;
-(IBAction) onImageQLClick:(id)sender;

-(IBAction) onScreenShotClick:(id)sender;
-(IBAction) onReverseImageClick:(id)sender;

-(IBAction) onImageQLSelectClick:(id)sender;

-(IBAction) onRecordingClick:(id)sender;

- (void)onMenuItemSelect:(id)sender;

-(void)screenShot;//add by luo 20141120

-(void)micStatChange:(BOOL)isHide;
-(void)qlStatChange:(BOOL)isHide;//add by luo 20141104
-(void)topMoreStatChange:(BOOL)isHide;//add by luo 20141104

-(void) onTickCountTimer:(id)param;

-(void) addGestureRecognizer;

-(void) doLocalizable;
-(void) animationDidStop;

-(void)showAlertTitel:(NSString *)titel withMessage: (NSString *)message;
//
-(void) SetLoginParam:(id)param;
-(void) StartPlay:(int) nChn area:(int) nPlayArea;
-(void) StopPlay:(BOOL)isShotCut;
-(void) StopNotice;

-(void) initInferface;
-(void)SaveSettings;//保存设置
-(void)GetSettings;//获取设置

-(void) doZoom;
-(void) onPlayAreaClick;

-(void)SavePlayScreenShot;

-(void)handelTap:(UITapGestureRecognizer *)recognizer;
-(void)handelPinch:(UIPinchGestureRecognizer *)recognizer;
-(void)handelSwipe:(UISwipeGestureRecognizer *)recognizer;
-(void)handelPan:(UIPanGestureRecognizer *)recognizer;

-(int)getStep:(CGPoint)translation;
-(pCameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation;

-(void)setPlayViewOrentation;

-(void)saveImageResult:(UIImage *)image hasBeenSavedInPhotoAlbumWithEro:(NSError *)error usingContextInfo:(void *)ctxInfo;

- (BOOL)canRecord;

-(void)onApplicationDidBecomeActiveHandle:(NSNotification *)notification;
-(void)onApplicationWillResignActiveHandle:(NSNotification *)notification;
@end

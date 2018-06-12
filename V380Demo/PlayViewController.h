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
#import "NVMediaPlayer.h"
#import "UINVMicPhoneView.h"
#import "UINVMiniImageButton.h"
#import "NVDevice.h"
//
#import "MBProgressHUD.h"
#import "UIPTZLocationNote.h"


#define STREAM_TYPE_SMOOTH 0
#define STREAM_TYPE_HD 1

#define RESULT_CODE_SUCCESS  0x100 //成功
typedef enum :NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft,
    
    kCameraMoveDirectionLeftUp,
    
    kCameraMoveDirectionLeftDown,
    
    kCameraMoveDirectionRightUp,
    
    kCameraMoveDirectionRightDown,
    
} CameraMoveDirection;



@interface PlayViewController : UIViewController{
 	BOOL isPlaying;
    uint nChannels;
 	
	NSString *chnFlag;
	int rowHeight;//
	NSString *noteSelectAChnToPlay, *notePlayingChn;
    int nPort;
    NSOperationQueue *operationQueue;
    CGRect customSize;
    NVMediaPlayer *nvMediaPlayer;
    int nZoomIndex;
    int nSelectedChn;
    int nSelectPlayer;
    BOOL m_bSoundEnable;
    CGRect m_rectNormal;
    CGRect m_rectFull;
    BOOL isPTZVerticalAutoOn, isPTZhorizontalAutoOn;
    BOOL isPTZLeft, isPTZRight, isPTZUP, isPTZDown;
    BOOL isPTZLeftPressed, isPTZRightPressed, isPTZUPPressed, isPTZDownPressed;
    int nPTZCtrlThreadID;
    int nStep;
    int nStreamType;
    NSTimer *toolViewShowTickCountTimmer;
    int nToolViewShowTickCount;
    BOOL isBackAlertShow;
    CGFloat lastScale;
    CameraMoveDirection direction;
    BOOL isAudioRecording;
    BOOL isReverse;
    UINVMicPhoneView *btnMicView;
    BOOL _zoom;
    BOOL _dim;
    BOOL _shadow;
    MBProgressHUD *HUD;
    
     UIPTZLocationNote *location1,*location2,*location3,*location4,*location5,*location6,*location7,*location8,*location9;
    NSMutableArray *ptzxPicList;
}

@property (assign) CGFloat fStepDistance;
@property (assign) CGFloat fScreenWith;
@property (assign) CGFloat fScreenHeight;

@property (assign) BOOL m_bSoundEnable;
@property (assign) int nZoomIndex;
 
@property (assign) CGRect customSize;
@property (assign) int nPTZXCount;
@property (nonatomic, copy) NSString *chnFlag;
@property (assign) int rowHeight;//

@property (assign) uint nChannels;

//play bottom view add by lusongbin 20160614
@property (retain, nonatomic) IBOutlet UIButton *btnPreviousCam;
@property (retain, nonatomic) IBOutlet UIButton *btnNextCam;
@property (retain, nonatomic) IBOutlet UINVMiniImageButton *btnStartRecord;
@property (retain, nonatomic) IBOutlet UIButton *btnClosePtzPanel;

//end add by lusongbin 20160614

//
@property (nonatomic, retain) LoginHandle *_loginParam;
@property (nonatomic, retain) IBOutlet UIView *vScreenShotView;
@property (nonatomic, retain) IBOutlet UIView *topView, *bottomView;
@property (nonatomic, retain) IBOutlet UIImageView *ivTopViewBg;
@property (nonatomic, retain) IBOutlet UIButton *btnBackToList;

//
@property (nonatomic, retain) IBOutlet UIImageView *ivImagePlayViewBg;
@property (nonatomic, retain) IBOutlet UIView *imagePlayView;//the
@property (nonatomic, retain) IBOutlet UILabel *lblPTZNotice;
//
@property (nonatomic, retain) IBOutlet UIView *vQLPanel;
@property (nonatomic, retain) IBOutlet UIImageView *ivQLPanelBg, *ivQLPanelSpiter;
@property (nonatomic, retain) IBOutlet UIButton *btnQualityHD, *btnQualitySmooth;

@property (nonatomic, retain) IBOutlet UIButton *btnSoundEnable;
@property (nonatomic, retain) IBOutlet UIButton *btnImgQL;// modify by lusongbin 20160614

//
@property (nonatomic, retain) IBOutlet UIImageView *ivBottomViewBg;
@property (nonatomic, retain) IBOutlet UINVMiniImageButton  *btnReverseImage, *btnScreenShot, *btnBack;
@property (nonatomic, retain) IBOutlet UINVMiniImageButton *btnShowMore;
@property (retain, nonatomic) IBOutlet UINVMiniImageButton *btnShowPTZ;

@property (nonatomic, retain) IBOutlet UILabel *headerNote;

//
@property (nonatomic, retain) IBOutlet UIView *vPTZPanel;
@property (nonatomic, retain) IBOutlet UIImageView *ivPTZLeft, *ivPTZRight, *ivPTZUp, *ivPTZDown;

@property (nonatomic, retain) IBOutlet UIView *vPTZXPanel;

@property (nonatomic, retain) IBOutlet UIView *vPTZXContainView;
@property (nonatomic, retain) IBOutlet UIImageView *ivPTZXContainViewBG;
@property (nonatomic, retain) IBOutlet UILabel *lblPTZXTitle;
@property (nonatomic, retain) IBOutlet UIView *vPTZXContainViewTop;
@property (nonatomic, retain) IBOutlet UIImageView *ivPTZXContainViewTopBG;
@property (nonatomic, retain) IBOutlet UIButton *btnPTZXPanelClose;
@property (nonatomic, retain) IBOutlet UIScrollView *scvPTZXPointList;


@property (nonatomic, retain) IBOutlet UIImageView *ivPTZXBG;

@property (nonatomic, retain) IBOutlet UIView *vPTZXLanBtnContanner;
@property (nonatomic, retain) IBOutlet UIImageView *ivTZXLanBtnBG;
@property (nonatomic, retain) IBOutlet UIButton *btnPTZXLan;

//speak view
@property (nonatomic, retain) IBOutlet UILabel *lblCanSpeakNotice;

 

@property (assign) BOOL isPlaying;


-(IBAction) SoundEnableClick:(id)sender;
-(IBAction) onBackAnStopClick:(id)sender;
-(IBAction) onMicShowClick:(id)sender;
-(IBAction) onImageQLClick:(id)sender;

-(IBAction) onShowPTZLocationSettingView:(id)sender;
-(void) onHidePTZLocationSettingView:(id)sender;

-(IBAction) onScreenShotClick:(id)sender;
-(IBAction) onReverseImageClick:(id)sender;

-(IBAction) onImageQLSelectClick:(id)sender;


-(void) onPTZXSettingClick:(id)sender;
-(void) onPTZXLocatingClick:(id)sender;

- (void)onMenuItemSelect:(id)sender;

-(void)screenShot;//add by luo 20141120

-(void)micStatChange:(BOOL)isHide;
-(void)qlStatChange:(BOOL)isHide;//add by luo 20141104
-(void)topMoreStatChange:(BOOL)isHide;//add by luo 20141104

-(void) onTickCountTimer:(id)param;

-(void) addGestureRecognizer;

-(void) addPTZGestureRecognizer;

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
-(CameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation;
-(void)setPlayViewOrentation;
-(void)saveImageResult:(UIImage *)image hasBeenSavedInPhotoAlbumWithEro:(NSError *)error usingContextInfo:(void *)ctxInfo;
- (BOOL)canRecord;

-(void)initPTZXUI;
-(void)startPtzCtrlThread;
-(void) ptzCtrlThreadFucn:(int)nThreadID;

-(void)showLanPTZXButton:(BOOL)isShow;

-(BOOL)updatePTZXPic:(int) nPTZXID image:(UIImage *)image;
-(void)ptzcxLocat:(int)nPTZXID action:(int)nAction;
-(void)ptzcxSet:(int)nPTZXID action:(int)nAction;


-(BOOL)ptzxSetDirectID:(int)nPTZXID action:(int)nAction;
-(BOOL)ptzxSetFromMRID:(int)nPTZXID action:(int)nAction;
 
-(void)onApplicationDidBecomeActiveHandle:(NSNotification *)notification;
-(void)onApplicationWillResignActiveHandle:(NSNotification *)notification;
@end

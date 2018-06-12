//
//  PanoPlaybackController.m
//  iCamSee
//
//  Created by 视宏 on 16/9/12.
//  Copyright © 2016年 macrovideo. All rights reserved.
//

#import "PanoPlaybackController.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"
#import "RecFileInfo.h"
#import "iToast.h"
#import "DXAlertView.h"
#import "DebugFlag.h"
#import "LibContext.h"
#import "ViewFactory.h"

#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "MBProgressHUD.h"
#import "PanoModeView.h"
#import "PanoPlaybackPopView.h"
//#import "PlayBackPanoModeView.h"
#import "CamTypePopView.h" //add by zhantian 20170801
//
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <netdb.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
@interface PanoPlaybackController (){

MBProgressHUD *HUD;
UIView *imagePlayView;

UILabel *headerNote;

NVPanoPlayer *nvMediaPlayer;//
    DXAlertView *alert;
BOOL isPlaying;

int rowHeight;//
//
CGRect customSize;

int nZoomIndex;
int nSelectedChn;
int nSelectPlayer;

BOOL m_bSoundEnable;
BOOL m_isFullScreen;

CGRect m_rectNormal;
CGRect m_rectFull;

BOOL isEditingSlider;

NSTimer *toolViewShowTickCountTimmer;
int nToolViewShowTickCount;
BOOL isBackAlertShow;
int nPlayIndexId;

NSMutableArray *recFileList;
int nFileSelectedIndex;

UITapGestureRecognizer *gesture;
    

    
    BOOL isfilePlaybackEnd; // 录像回放到末尾自然结束 add by qiumuze 20170719
    
    int pauseProgressValue; // 录像回放到末尾自然结束 add by qiumuze 20170719
    
    BOOL isInProgress; // 录像回放到末尾自然结束 add by qiumuze 20170719

}
@property(nonatomic,assign) int currentMode;

@property  (retain) LoginHandle *lLoginHandel;
//add by lusongbin20160615
@property (retain, nonatomic) IBOutlet UIView *vRecFileNameView;
@property (retain, nonatomic) IBOutlet UIImageView *imgRecFileIconView;
@property (retain, nonatomic) IBOutlet UILabel *lblRceFileName;
//end add by lusongbin 20160615
@property (retain, nonatomic) IBOutlet UIButton *btnSetMode;
@property (nonatomic, retain) PanoPlaybackPopView *panoModeView;
//@property (nonatomic,retain) PanoModeView *panoModeView;
@property (retain, nonatomic) IBOutlet UILabel *PanoTimeLabel;

//add by zhantian 20170801
@property (nonatomic, retain) CamTypePopView *camtypePopView;
@property (nonatomic,retain) UIButton *btnCamtype;

@property(nonatomic,assign) int currentCamType;

//end

// 用户信息
@property (nonatomic, retain) CLDUser *user;

// 设备信息
@property (nonatomic, retain) NVDevice *device;
@end

@implementation PanoPlaybackController
@synthesize imagePlayView;//the

@synthesize lLoginHandel;
@synthesize isPlaying;

@synthesize rowHeight;

@synthesize m_isFullScreen;

@synthesize customSize;

@synthesize nZoomIndex;
@synthesize m_bSoundEnable;
@synthesize vPlayBackAlertView, btnAlertOK, btnAlertCancel,lnlAlertNotice,vDialogView;
@synthesize topView, headerNote, btnBackToList;
@synthesize bottomView, vButtonsContainer, btnStopAndPlay, btnSoundEnable, vSliderContainer,playSlider, btnPlayPrev, btnPlayNext, btnScreenShot;

// 全景模式控件 getter
- (PanoPlaybackPopView *)panoModeView {
     //modify by zhantian 20170801
    if (_panoModeView == nil) {
       
        _panoModeView = [[PanoPlaybackPopView panoModeViewWithType:_currentCamType] retain];
        
        [_panoModeView addTarget:self action:@selector(panoModeButtonPressed:)];
        CGFloat width;
        if (_currentCamType == FISHEYECAMTYPEWALL) {
            
            width = 100.0;
        }else if (_currentCamType == FISHEYECAMTYPETOP){
            width = 250.0;
        }
        CGFloat height = 50.0;
        CGFloat x = CGRectGetMaxX(imagePlayView.frame) - width;
        CGFloat y = CGRectGetMaxY(imagePlayView.frame) - height - 10;
        _panoModeView.frame = CGRectMake(x, y, width, height);
        
    }else{
        CGFloat width;
        if (_currentCamType == FISHEYECAMTYPEWALL) {
            
            width = 100.0;
        }else if (_currentCamType == FISHEYECAMTYPETOP){
            width = 250.0;
        }
        CGFloat height = 50.0;
        CGFloat x = CGRectGetMaxX(imagePlayView.frame) - width;
        CGFloat y = CGRectGetMaxY(imagePlayView.frame) - height - 10;
        _panoModeView.frame = CGRectMake(x, y, width, height);
        [_panoModeView setFixType:_currentCamType];

    }
    
    //add by zhantian 20170801 --增加横屏Frame
     if (CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds) && _currentCamType == FISHEYECAMTYPEWALL) {//横屏
         
         CGFloat width = 50.0;
         CGFloat height = 100.0;
         CGFloat x = nvMediaPlayer.frame.size.width - width - 10;
         CGFloat y = (nvMediaPlayer.frame.size.height - height) * 0.5;
         _panoModeView.frame = CGRectMake(x, y, width, height);
          [_panoModeView setFixType:_currentCamType];

     
     }
    
    //end by zhantian
    
    
    return _panoModeView;
    
    


}

// 全景模式点击事件, 切换模式
- (void)panoModeButtonPressed:(UIButton *)sender {
   
        _currentMode =(int)sender.tag;
        [nvMediaPlayer SetMode:_currentMode];
        [self.panoModeView selecteItemAtIndex:_currentMode];
        [_btnSetMode setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fisheye_%d_logo", _currentMode]] forState:UIControlStateNormal];
        //modify by zhantian 20170802
            //横屏模式下不要去除
        if(CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds)){
        
        
        }else{
        
            [self.panoModeView removeFromSuperview];
        }
        
        //end by zhantian

}


//add by zhantian 20170801
#pragma mark - camtype
-(CamTypePopView *)camtypePopView{
    
    if (_camtypePopView == nil) {
        //创建选择界面
        _camtypePopView = [[CamTypePopView camtypePopview] retain];
        //设置切换方法
        [_camtypePopView addTarget:self action:@selector(panoCamtypeModeButtonPressed:)];
    }
    
    //设置弹出框的frame
    CGFloat width;
    
    width = 100.0;
    
    CGFloat height = 50.0;
    CGFloat x = CGRectGetMaxX(_btnCamtype.frame) - width;
    CGFloat y = CGRectGetMinY(_btnCamtype.frame) - height - 10;
    _camtypePopView.frame = CGRectMake(x, y, width, height);
    
    [_camtypePopView selecteItemAtIndex:_currentCamType];
    
    return _camtypePopView;
    
  
}



//点击镜头类型选择
-(void)panoCamtypeModeButtonPressed:(UIButton *)sender{
    //
    _currentCamType = sender.tag;
    NSLog(@"---current--%d",-_currentCamType);
    CGFloat width;
    if (_currentCamType == FISHEYECAMTYPEWALL) {
        
        width = 100.0;
    }else if (_currentCamType == FISHEYECAMTYPETOP){
        
        width = 250.0;
    }
    CGFloat height = 50.0;
    CGFloat x = CGRectGetMaxX(_btnCamtype.frame) - width;
    CGFloat y = CGRectGetMinY(bottomView.frame) - height - 10;
    _panoModeView.frame = CGRectMake(x, y, width, height);
    [_panoModeView setFixType:_currentCamType];
    
    [self.camtypePopView selecteItemAtIndex:_currentCamType];
    //
    //转换camtype 设置模式选择和播放器选项
    [nvMediaPlayer setCamType:_currentCamType];
    [nvMediaPlayer SetMode:0];
    _currentMode =0;
    [self.panoModeView selecteItemAtIndex:0];
    
    //设置图片
   [_btnSetMode setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fisheye_%d_logo", _currentMode]] forState:UIControlStateNormal];
    [_btnCamtype setImage:[UIImage imageNamed:[NSString stringWithFormat:@"camtype_%d_logo", _currentCamType]] forState:UIControlStateNormal];
    
    [self.camtypePopView removeFromSuperview];//消失
    
}

//显示镜头类型
- (void) ShowCamtypeSettingView{
    if ([self.view.subviews containsObject:self.panoModeView]) {
        
        [self.panoModeView removeFromSuperview];
        
    }
    
    if ([self.view.subviews containsObject:self.camtypePopView]) {
        
        [self.camtypePopView removeFromSuperview];
        
    } else {
        
        [self.view addSubview:self.camtypePopView];
    }
    
}

//edd by zhantian 20170801




-(void)onBtnSetmodeClick{
    
    //add by zhantian 20170801
    if([self.view.subviews containsObject:self.camtypePopView]){
        [self.camtypePopView removeFromSuperview];
    }
    //end by zhantian
    if ([self.view.subviews containsObject:self.panoModeView]) {
        
        [self.panoModeView removeFromSuperview];
        
    } else {
        
        [self.view addSubview:self.panoModeView];
    }
}
- (IBAction)onScreenShotClick:(id)sender {
    DLog(@"onScreenShotClick");//add for test
    [self screenShot];
}

- (IBAction)onPlayNextClick:(id)sender {
    
    [nvMediaPlayer resetPause]; // add by qiumuze 20170719
    
    if (nFileSelectedIndex >= (recFileList.count - 1)) {
        
        iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeTheLastOne", @"Was the last one")];
        [toast setToastPosition:kToastPositionCenter];
        [toast setToastDuration:kToastDurationShort];
        [toast show];
        
        return;
    }
    
    nFileSelectedIndex++;
    
    if (nFileSelectedIndex >= 0 && nFileSelectedIndex < recFileList.count) {
        
        RecFileInfo *recFile = [recFileList[nFileSelectedIndex] retain];
        
        if (recFile) {
            
            //            [headerNote setText:[NSString stringWithFormat:@"%@", [recFile strFileName]]];
            
            [_lblRceFileName setText:[NSString stringWithFormat:@"%@", [recFile strFileName]]];//add by lusongbin 20160615
        }
        
        [recFile release];
    }
    //add by lusongbin 20161101 判断云服务
 
        
        [self StartPlayInArea:0];
    
    
}

- (IBAction)onPlayPrevClick:(id)sender {
    
    [nvMediaPlayer resetPause]; // add by qiumuze 20170719
    
    if (nFileSelectedIndex <= 0) {
        
        iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeTheFirstOne", @"Is the first")];
        [toast setToastPosition:kToastPositionCenter];
        [toast setToastDuration:kToastDurationShort];
        [toast show];
        
        return;
    }
    
    nFileSelectedIndex--;
    
    if (nFileSelectedIndex >= 0 && nFileSelectedIndex < recFileList.count) {
        
        RecFileInfo *recFile = [recFileList[nFileSelectedIndex] retain];
        
        if (recFile) {
            
            [_lblRceFileName setText:[NSString stringWithFormat:@"%@", [recFile strFileName]]];//add by lusongbin 20160615
        }
        
        [recFile release];
    }
    
    //add by lusongbin 20161101 判断云服务
 
        
        [self StartPlayInArea:0];
    
}

- (IBAction)onBackAnStopClick:(id)sender {
    
    [nvMediaPlayer resetPause]; // add by qiumuze 20170719
    btnScreenShot.enabled = YES;
    btnPlayPrev.enabled = YES;
    btnPlayNext.enabled = YES;
    btnSoundEnable.enabled = YES;
    playSlider.enabled = YES;
    // end add by qiumuze 20170719
    //    // 弹出框
    //    vPlayBackAlertView.frame = self.view.bounds;
    //    frame.size.width = 300;
    //    frame.size.height = 180;
    //    frame.origin.x = (CGRectGetWidth(vPlayBackAlertView.frame) - CGRectGetWidth(frame)) * 0.5;
    //    frame.origin.y = (CGRectGetHeight(vPlayBackAlertView.frame) - CGRectGetHeight(frame)) * 0.5;
    //    vDialogView.frame = frame;
    
    
    if (isPlaying) {
        
        isBackAlertShow = YES;
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"noticeMsgStopAndback", @"Whether to stop and return to the list of devices?") leftButtonTitle:NSLocalizedString(@"btnYES", @"YES") rightButtonTitle:NSLocalizedString(@"btnNO", @"NO")];
        
        [alert show];
        
        alert.leftBlock = ^() {
            [self StopPlay];
            AppDelegate *deleget = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [deleget retain];
            if (deleget) {
                [deleget set_isPlaying:NO];
            }
            [deleget release];
            
            [self dismissViewControllerAnimated:NO completion:nil];
            
            isBackAlertShow = NO;
            if ([self.view.subviews containsObject:self.panoModeView]) {
                
                [self.panoModeView removeFromSuperview];
                
            }
            //add by zhantian 20170802
            if([self.view.subviews containsObject:self.camtypePopView]){
                [self.camtypePopView removeFromSuperview];
            }
            if([nvMediaPlayer.subviews containsObject:self.panoModeView]){
            
                [self.panoModeView removeFromSuperview];
            }
            //end by zhantian
            
        };
        
        alert.rightBlock = ^() {
            isBackAlertShow = NO;
        };
        
        
    } else {
        [self StopPlay];
        AppDelegate *deleget = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [deleget retain];
        if (deleget) {
            [deleget set_isPlaying:NO];
        }
        [deleget release];
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

- (IBAction)onSoundEnableClick:(id)sender {
    
    DLog(@"onSoundEnableClick");
    m_bSoundEnable = !m_bSoundEnable;
    
    //设置横屏竖屏button图片
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        //横屏
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_cs_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_csnormal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_pressed.png"] forState:UIControlStateHighlighted];
        }
        
    }else{
        
        //竖屏
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_normal"] forState:UIControlStateNormal];//
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_pressed"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_pressed"] forState:UIControlStateHighlighted];
        }
    }
    
    [nvMediaPlayer SetAudioParam:m_bSoundEnable];
    
    [self SaveSettings];
}

- (void)screenShot {
    
    [btnScreenShot setEnabled:NO];
    
    
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [self.view addSubview:HUD];
    
    HUD.delegate = nil;
    HUD.labelText =  NSLocalizedString(@"noticeScreenShot", @"Save picture...");
    [HUD showWhileExecuting:nil onTarget:self withObject:nil animated:YES];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image =[nvMediaPlayer screenShot];
        [image retain];
        dispatch_after(0.1f, dispatch_get_main_queue(), ^{
            
            if (image) {
                //                UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveImageResult:hasBeenSavedInPhotoAlbumWithEro:usingContextInfo:), nil);
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                NSString *albumName = NSLocalizedString(@"appName", @"app's name");
                [library saveImage:image toAlbum:albumName completion:^(NSURL *assetURL, NSError *error) {
                    
                    if (error == nil) {
                        
                        DLog(@"screenshot ok");
                        if (HUD) {
                            [HUD hide:YES];
                        }
                        
                        dispatch_after(1.f, dispatch_get_main_queue(), ^{
                            iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeFileSaveToAlbums", @"Picture has been save to album")];
                            [toast setToastPosition:kToastPositionCenter];
                            [toast setToastDuration:kToastDurationShort];
                            [toast show];
                            [btnScreenShot setEnabled:YES];
                        });
                        
                    } else {
                        [btnScreenShot setEnabled:YES];
                        
                        DLog(@"err = %@", error);
                    }
                    
                } failure:^(NSError *error) {
                    
                    if (error) {
                        DLog(@"screenshot failed");
                        
                        if (image && [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
                            
                            if (HUD) {
                                [HUD hide:YES];
                            }
                            
                            dispatch_after(1.f, dispatch_get_main_queue(), ^{
                                NSLog(@"err = %@", error);
                                
                                //                            iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeSCNOAlbumsPri", @"Screenshot fail, check if the app has the permission to access album")];
                                iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeScreenshotFail", @"Screenshot fail")];
                                [toast setToastPosition:kToastPositionCenter];
                                [toast setToastDuration:kToastDurationShort];
                                [toast show];
                            });
                            
                        } else {
                            
                            if (HUD) {
                                [HUD hide:YES];
                            }
                            
                            dispatch_after(1.f, dispatch_get_main_queue(), ^{
                                iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeScreenshotFail", @"Screenshot fail")];
                                [toast setToastPosition:kToastPositionCenter];
                                [toast setToastDuration:kToastDurationShort];
                                [toast show];
                            });
                        }
                        
                        DLog(@"err = %@", error);
                    }
                    [btnScreenShot setEnabled:YES];
                    
                }];
                
            }else{
                if (HUD) {
                    [HUD hide:YES];
                }
                
                dispatch_after(1.f, dispatch_get_main_queue(), ^{
                    
                    iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeScreenshotFail", @"Screenshot fail")];
                    [toast setToastPosition:kToastPositionCenter];
                    [toast setToastDuration:kToastDurationShort];
                    [toast show];
                    [btnScreenShot setEnabled:YES];
                    
                });
                
            }
            
        });
        
        [image release];
    });
}

- (void)saveImageResult:(UIImage *)image hasBeenSavedInPhotoAlbumWithEro:(NSError *)error usingContextInfo:(void *)ctxInfo {
    [btnScreenShot setEnabled:YES];
    DLog(@"screenshot result");
    if (error) {
        DLog(@"screenshot failed");
        
        if (image && [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
            
            iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeSCNOAlbumsPri", @"Screenshot fail, check if the app has the permission to access album")];
            [toast setToastPosition:kToastPositionCenter];
            [toast setToastDuration:kToastDurationShort];
            [toast show];
            
            
        }else{
            iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeScreenshotFail", @"Screenshot fail")];
            [toast setToastPosition:kToastPositionCenter];
            [toast setToastDuration:kToastDurationShort];
            [toast show];
            
        }
        
    }else{
        
        
        iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeFileSaveToAlbums", @"Picture has been save to album")];
        [toast setToastPosition:kToastPositionCenter];
        [toast setToastDuration:kToastDurationShort];
        [toast show];
        
        
    }
    
}

//设置录像文件列表和回放句柄等信息
- (void)SetPlayList:(NSArray *)recList handle:(LoginHandle *)lHandle playIndex:(int)nPlayIndex {
    
    [recList retain];
    if (recList) {
        [self setLLoginHandel:lHandle];
        
        if (recFileList==nil) {
            recFileList = [[NSMutableArray alloc] init];
            
        }
        
        [recFileList removeAllObjects];
        
        [recFileList setArray:recList];
        nFileSelectedIndex = nPlayIndex;
        
        if ([recFileList count]>0 && nFileSelectedIndex>=0 && nFileSelectedIndex<[recFileList count]) {
            RecFileInfo *recFile = [recFileList objectAtIndex:nFileSelectedIndex];
            [recFile retain];
            //             [headerNote setText:[NSString stringWithFormat:@"%@", [recFile strFileName]]];
            
            [_lblRceFileName setText:[NSString stringWithFormat:@"%@", [recFile strFileName]]];//add by lusongbin 20160615
            
            [recFile release];
            
        }
        nZoomIndex=0;
    }
    
    [recList release];
}

- (void)SaveSettings {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault retain];
    
    if (userDefault) {
        
        [userDefault setValue:[NSNumber numberWithBool:m_bSoundEnable] forKey:@"sound_enable"];
        [userDefault synchronize];
    }
    [userDefault release];
}

- (void)GetSettings {
    DLog(@"GetSettings");//add for test
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault retain];
    m_bSoundEnable=YES;
    if (userDefault) {
        
        NSNumber *value=[userDefault valueForKey:@"sound_enable"];
        
        if (value) {
            m_bSoundEnable=[value boolValue];
        }
        
    }
    [userDefault release];
    //设置横屏竖屏button图片
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        //横屏
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_cs_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_csnormal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_pressed.png"] forState:UIControlStateHighlighted];
        }
    }else{
        
        //竖屏
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_normal"] forState:UIControlStateNormal];//
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_pressed"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_pressed"] forState:UIControlStateHighlighted];
        }
    }
    
    
    
    
    
}

//iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation == self.preferredInterfaceOrientationForPresentation);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    //add by zhantian 20170801
    if([self.view.subviews containsObject:self.panoModeView] ){
        //
           [self.panoModeView removeFromSuperview];
           
           
    }
    if([self.view.subviews containsObject:self.camtypePopView]){
    
           [self.camtypePopView removeFromSuperview];
    }
    if([nvMediaPlayer.subviews containsObject:self.panoModeView]){
    
        [self.panoModeView removeFromSuperview];
    }
    //end by zhantian
    
    
    
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeRight || toInterfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        
        [UIView animateWithDuration:duration animations:^{
            
            topView.backgroundColor = [DEFAULT_COLOR colorWithAlphaComponent:0.5];
            bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            
            vSliderContainer.hidden = NO;
        }];

        
        
        
    } else {
        [alert removeFromSuperview];
        [UIView animateWithDuration:duration animations:^{
            
            topView.backgroundColor = DEFAULT_COLOR;
            bottomView.backgroundColor = BACKGROUND_COLOR;
        }];
    }
    
    if (isBackAlertShow) {
        if (!alert) {
            alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"noticeMsgStopAndback", @"Whether to stop and return to the list of devices?") leftButtonTitle:NSLocalizedString(@"btnYES", @"YES") rightButtonTitle:NSLocalizedString(@"btnNO", @"NO")];
            [alert show];
        }
        
        alert.leftBlock = ^() {
            [self StopPlay];
            [self dismissViewControllerAnimated:NO completion:nil];
            
            isBackAlertShow = NO;
        };
        alert.rightBlock = ^() {
            isBackAlertShow = NO;
        };
    }
}

//iOS 6
- (BOOL)shouldAutorotate {
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

- (void)viewWillLayoutSubviews {
    
    CGRect bounds = self.view.bounds;
    CGRect frame;
    // 标题栏
    frame.size.width = CGRectGetWidth(bounds);
    frame.size.height = 44;
    frame.origin.x = 0;
    frame.origin.y = (CGRectGetWidth(bounds) > CGRectGetHeight(bounds)) ? ((CGRectGetMinY(topView.frame) == 0) ? -CGRectGetHeight(topView.frame) : 0) : 0;
    topView.frame = frame;
    
    frame.size.width = CGRectGetHeight(topView.frame);
    frame.size.height = CGRectGetHeight(topView.frame);
    frame.origin.x = 0;
    frame.origin.y = 0;
    btnBackToList.frame = frame;
    
    frame.size.width = CGRectGetWidth(topView.frame) - CGRectGetWidth(btnBackToList.frame) * 2;
    frame.size.height = CGRectGetHeight(topView.frame);
    frame.origin.x = CGRectGetMaxX(btnBackToList.frame);
    frame.origin.y  = 0;
    headerNote.frame = frame;
    
    if (CGRectGetWidth(bounds) > CGRectGetHeight(bounds)) {
        //横屏
        
        imagePlayView.frame = bounds;
        nvMediaPlayer.frame = imagePlayView.bounds;
        
        //播放器横屏改变为固定模式
        //播放器横屏改变为固定模式
        if(lLoginHandel.nCamType == FISHEYECAMTYPETOP){
            [nvMediaPlayer SetMode:12];// 12 为模式
        }
        
        if ([self.view.subviews containsObject:self.panoModeView]) {
            
            [self.panoModeView removeFromSuperview];
            
        }
        // 设置Label的字体 HelveticaNeue  Courier
        UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
        self.PanoTimeLabel.font = fnt;
        // 根据字体得到NSString的尺寸
        CGSize size = [self.PanoTimeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        // label的H
        CGFloat textH = size.height;
        // label的W
        CGFloat textW = size.width;
        
        [nvMediaPlayer addSubview:_PanoTimeLabel];
        CGRect frame = _PanoTimeLabel.frame;
        frame.size.width = textW;
        frame.size.height = textH;
        frame.origin.x = nvMediaPlayer.frame.size.width - frame.size.width - 5;
        frame.origin.y = 5;
        _PanoTimeLabel.frame = frame;
    } else {
        
        //播放器竖屏恢复之前的模式
        //modify by zhantian 20170801
        if(_currentCamType == FISHEYECAMTYPETOP){
        [nvMediaPlayer SetMode:_currentMode];
        }else{
        if(_currentCamType == FISHEYECAMTYPEWALL)
            [nvMediaPlayer SetMode:_currentMode];
        }
       //end by zhantian 
        m_rectNormal.size.width = [UIScreen mainScreen].bounds.size.width;
         if ([UIScreen mainScreen].bounds.size.height > 736) {
             
             m_rectNormal.size.height = [UIScreen mainScreen].bounds.size.width;

         }else{
             m_rectNormal.size.height = [UIScreen mainScreen].bounds.size.width *1.1;
         }
        m_rectNormal.origin.x = 0;
        m_rectNormal.origin.y = CGRectGetMaxY(topView.frame);
        imagePlayView.frame = m_rectNormal;
        nvMediaPlayer.frame = imagePlayView.bounds;
        //panoTimeLabel
        // 设置Label的字体 HelveticaNeue  Courier
        UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
        self.PanoTimeLabel.font = fnt;
        // 根据字体得到NSString的尺寸
        CGSize size = [self.PanoTimeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        // label的H
        CGFloat textH = size.height;
        // label的W
        CGFloat textW = size.width;
        
        [nvMediaPlayer addSubview:_PanoTimeLabel];
        CGRect frame = _PanoTimeLabel.frame;
        frame.size.width = textW;
        frame.size.height = textH;
        frame.origin.x = nvMediaPlayer.frame.size.width - frame.size.width - 5;
        frame.origin.y = 5;
        _PanoTimeLabel.frame = frame;
    }
    // slider
    frame.size.width = CGRectGetWidth(imagePlayView.frame);
    frame.size.height = 31;
    frame.origin.x = 0;
    //
    if ( CGRectGetWidth(bounds) > CGRectGetHeight(bounds)  ) {
        //横屏
        if (  CGRectGetMinY(vSliderContainer.frame) == CGRectGetHeight(bounds)  ) {
            //
          frame.origin.y = CGRectGetHeight(imagePlayView.frame) - CGRectGetHeight(bottomView.frame) - CGRectGetHeight(vSliderContainer.frame);
        }else{
        
            frame.origin.y =CGRectGetHeight(bounds);
        }
    }else{
        //竖屏
        if ([UIScreen mainScreen].bounds.size.height < 568) {
          frame.origin.y = CGRectGetMaxY(imagePlayView.frame)- frame.size.height;// lblRceFileName 高 40;
        }else{
        
            frame.origin.y = (CGRectGetMaxY(imagePlayView.frame)+ 45);// lblRceFileName 高 40;
        }
    }
    
    /*
    frame.origin.y = (CGRectGetWidth(bounds) > CGRectGetHeight(bounds)) ? ((CGRectGetMinY(vSliderContainer.frame) == CGRectGetHeight(bounds)) ? (CGRectGetHeight(imagePlayView.frame) - CGRectGetHeight(bottomView.frame) - CGRectGetHeight(vSliderContainer.frame)) : (CGRectGetHeight(bounds))) : (CGRectGetMaxY(imagePlayView.frame)+ 45);// lblRceFileName 高 40;
     */
    
    vSliderContainer.frame = frame;
    playSlider.frame = vSliderContainer.bounds;
    
    
    //RecFileView
    //add by lusongbin 20160615
    frame = _vRecFileNameView.frame;
    frame.origin.y = CGRectGetMaxY(imagePlayView.frame);
    frame.origin.x = 0;
    frame.size.width = bounds.size.width;
    frame.size.height = 30;
    _vRecFileNameView.frame = frame;
    
    frame = _imgRecFileIconView.frame ;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = _vRecFileNameView.frame.size.height;
    frame.size.height = frame.size.width;
    _imgRecFileIconView.frame = frame;
    
    frame = _lblRceFileName.frame;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(imagePlayView.frame);
    frame.size.width = bounds.size.width;
    frame.size.height = 40;
    _lblRceFileName.frame = frame;
    //镜头效果模式选择
    frame = _btnSetMode.frame;
    frame.size.width = 30;
    frame.size.height = 30;
    frame.origin.x = bounds.size.width - frame.size.width - 5;
    frame.origin.y = CGRectGetMaxY(imagePlayView.frame) + 5;
    _btnSetMode.frame = frame;
    
    
    
    //add by zhantian 20170801
    
    frame = _btnCamtype.frame;
    frame.size.width = 30;
    frame.size.height = 30;
    frame.origin.x = _btnSetMode.frame.origin.x - 5 -frame.size.width;
    frame.origin.y = CGRectGetMaxY(imagePlayView.frame) + 5;
    _btnCamtype.frame = frame;
    
    //end by zhantian 20170801
    
    //end add by lusongbin 20160615
    
    
    
    // 底部按钮 bottomview 和 vButtonsContainer
    frame.size.width = CGRectGetWidth(bounds);
    //适配小屏幕
    if (  ([UIScreen mainScreen].bounds.size.height < 568) && (CGRectGetWidth(bounds) < CGRectGetHeight(bounds))  ) {//小屏幕竖屏 ip5尺寸高度568 比ip5小的屏幕如下设置
        frame.size.height = bounds.size.height - CGRectGetMaxY(_lblRceFileName.frame);
    }else{
        
        frame.size.height = 100;
    }
    //
    frame.origin.x = (CGRectGetWidth(bounds) - CGRectGetWidth(frame)) * 0.5;
    
    //设置Y
    if (CGRectGetWidth(bounds) > CGRectGetHeight(bounds)) {//横屏的适应性布局 bottoView Y
        
        if (CGRectGetMinY(bottomView.frame) == (CGRectGetHeight(bounds) + CGRectGetHeight(vSliderContainer.frame))) {
        
            frame.origin.y =CGRectGetHeight(bounds) - CGRectGetHeight(frame);
        
        }else{
            
            frame.origin.y = CGRectGetHeight(bounds) + CGRectGetHeight(vSliderContainer.frame);
        }
        
    }else{//竖屏bottoView Y
        
        if ([UIScreen mainScreen].bounds.size.height < 568) {
            frame.origin.y = CGRectGetMaxY(_lblRceFileName.frame);
        }else{

            frame.origin.y = CGRectGetMaxY(imagePlayView.frame) + CGRectGetHeight(bounds) - CGRectGetMaxY(imagePlayView.frame) - CGRectGetHeight(frame);
        }
    };
    /*
    frame.origin.y = (CGRectGetWidth(bounds) > CGRectGetHeight(bounds)) ? ((CGRectGetMinY(bottomView.frame) == (CGRectGetHeight(bounds) + CGRectGetHeight(vSliderContainer.frame))) ? (CGRectGetHeight(bounds) - CGRectGetHeight(frame)) : (CGRectGetHeight(bounds) + CGRectGetHeight(vSliderContainer.frame))) : (CGRectGetMaxY(imagePlayView.frame) + ((CGRectGetHeight(bounds) - CGRectGetMaxY(imagePlayView.frame) - CGRectGetHeight(frame))));
    */
    
    bottomView.frame = frame;
    vButtonsContainer.frame = bottomView.bounds;
    
    
    if (  ([UIScreen mainScreen].bounds.size.height < 568) && (CGRectGetWidth(bounds) < CGRectGetHeight(bounds))  ) {//小屏幕竖屏
       
        CGFloat buttonWH = vButtonsContainer.frame.size.height;
        CGFloat margin = (bounds.size.width - buttonWH * 5 - 10) / 6 ;

        // 播放/暂停按钮
        frame.size.width = buttonWH;
        frame.size.height = buttonWH;
        frame.origin.x = vButtonsContainer.frame.size.width / 2 - frame.size.width / 2;
        frame.origin.y = (CGRectGetHeight(vButtonsContainer.frame) - CGRectGetHeight(frame)) * 0.5;
        btnStopAndPlay.frame = frame;
        // 截屏按钮
        frame.size.width = buttonWH;
        frame.size.height = buttonWH;
        frame.origin.x = CGRectGetMinX(btnStopAndPlay.frame) - margin * 2 - frame.size.width * 2;
        frame.origin.y = (CGRectGetHeight(vButtonsContainer.frame) - CGRectGetHeight(frame)) * 0.5;
        btnScreenShot.frame = frame;
        
        // 上一个文件按钮
        frame = btnScreenShot.frame;
        frame.origin.x = CGRectGetMinX(btnStopAndPlay.frame) - margin - frame.size.width;
        btnPlayPrev.frame = frame;
        
        // 下一个文件按钮
        frame = btnScreenShot.frame;
        frame.origin.x = CGRectGetMaxX(btnStopAndPlay.frame) + margin;
        btnPlayNext.frame = frame;
        
        // 开启/关闭声音按钮
        frame = btnScreenShot.frame;
        frame.origin.x = CGRectGetMaxX(btnPlayNext.frame) + margin;;
        btnSoundEnable.frame = frame;

        
    }else{//ip5 以上屏幕横竖屏的设置
        
        //确定margin 再确认button 大小
        CGFloat margin = 10;
        CGFloat buttonWH = (MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) - margin * 6) / 5;
        
        // 播放/暂停按钮
        frame.size.width = buttonWH * 1.3;
        frame.size.height = buttonWH * 1.3;
        frame.origin.x = vButtonsContainer.frame.size.width / 2 - frame.size.width / 2;
        frame.origin.y = (CGRectGetHeight(vButtonsContainer.frame) - CGRectGetHeight(frame)) * 0.5;
        btnStopAndPlay.frame = frame;
        // 截屏按钮
        frame.size.width = buttonWH * 0.9;
        frame.size.height = buttonWH * 0.9;
        frame.origin.x = CGRectGetMinX(btnStopAndPlay.frame) - margin * 2 - frame.size.width * 2;
        frame.origin.y = (CGRectGetHeight(vButtonsContainer.frame) - CGRectGetHeight(frame)) * 0.5;
        btnScreenShot.frame = frame;
        
        // 上一个文件按钮
        frame = btnScreenShot.frame;
        frame.origin.x = CGRectGetMinX(btnStopAndPlay.frame) - margin - frame.size.width;
        btnPlayPrev.frame = frame;
        
        // 下一个文件按钮
        frame = btnScreenShot.frame;
        frame.origin.x = CGRectGetMaxX(btnStopAndPlay.frame) + margin;
        btnPlayNext.frame = frame;
        
        // 开启/关闭声音按钮
        frame = btnScreenShot.frame;
        frame.origin.x = CGRectGetMaxX(btnPlayNext.frame) + margin;;
        btnSoundEnable.frame = frame;
    
    }
    
    
    nToolViewShowTickCount = 10;
    
    bottomView.hidden = NO;
    topView.hidden = NO;
    
    //设置横屏竖屏button图片
    //if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
    if (CGRectGetWidth(bounds) > CGRectGetHeight(bounds)){
     
        //add by zhantian 20170802 //一开始隐藏
        
        if(topView.frame.origin.y == 0){
        frame = topView.frame;
        frame.origin.y -= CGRectGetHeight(topView.frame);
        topView.frame = frame;
        }
        
        //end by zhantian
        //add by zhantian 20170802
        
        if(vSliderContainer.frame.origin.y < CGRectGetHeight(bounds)){
            frame = vSliderContainer.frame;
            frame.origin.y += (CGRectGetHeight(vSliderContainer.frame) + CGRectGetHeight(bottomView.frame));
    
            vSliderContainer.frame = frame;
        }
        if(bottomView.frame.origin.y < CGRectGetHeight(bounds)){
            frame = bottomView.frame;
            frame.origin.y += (CGRectGetHeight(vSliderContainer.frame) + CGRectGetHeight(bottomView.frame));
            bottomView.frame = frame;
        }
      //end by zhantian
        
        if ([self.view.subviews containsObject:self.panoModeView]) {
            
            [self.panoModeView removeFromSuperview];
            
        }
        
        //横屏
        [btnPlayPrev setImage:[UIImage imageNamed:@"btn_playback_last"] forState:UIControlStateNormal];
        [btnPlayPrev setImage:[UIImage imageNamed:@"btn_playback_last_click"] forState:UIControlStateHighlighted];
        [btnPlayNext setImage:[UIImage imageNamed:@"btn_playback_next"] forState:UIControlStateNormal];
        [btnPlayNext setImage:[UIImage imageNamed:@"btn_playback_next_click"] forState:UIControlStateHighlighted];
        
        
        //播放
        if (!isPlaying) {
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_cs_normal.png"] forState:UIControlStateNormal];
        }else{
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_cs_normal.png"] forState:UIControlStateNormal];
        }
        
        //截图
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_screenshot_cs_normal"] forState:UIControlStateNormal];
        
     
        
        //声音
        //横屏
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_cs_normal.png"] forState:UIControlStateNormal];
            
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_csnormal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_pressed.png"] forState:UIControlStateHighlighted];
        }
        
    }else{
        //竖屏
        
        
        [btnPlayPrev setImage:[UIImage imageNamed:@"btn_play_prev_normal"] forState:UIControlStateNormal];
        [btnPlayPrev setImage:[UIImage imageNamed:@"btn_play_prev_pressed"] forState:UIControlStateHighlighted];
        [btnPlayNext setImage:[UIImage imageNamed:@"btn_play_next_normal"] forState:UIControlStateNormal];
        [btnPlayNext setImage:[UIImage imageNamed:@"btn_play_next_pressed"] forState:UIControlStateHighlighted];
        
        //播放
        if (!isPlaying) {
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_normal.png"] forState:UIControlStateNormal];
        }else{
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_normal.png"] forState:UIControlStateNormal];
        }
        
        //安装模式 add by zhantian 20170801
        if(_currentCamType ==0){
            _currentCamType = FISHEYECAMTYPETOP;
        }
        if (_currentCamType == FISHEYECAMTYPEWALL) {
            [_btnCamtype setImage:[UIImage imageNamed:@"camtype_1_logo"] forState:UIControlStateNormal];
        }else if (_currentCamType == FISHEYECAMTYPETOP){
            [_btnCamtype setImage:[UIImage imageNamed:@"camtype_2_logo"] forState:UIControlStateNormal];
        }
        //end by zhantian 20170801
        //截图
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_playback_screenshot_normal"] forState:UIControlStateNormal];
        
        
        //声音
        //竖屏
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_normal"] forState:UIControlStateNormal];//
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_pressed"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_pressed"] forState:UIControlStateHighlighted];
        }
    }
    [self panoModeView];
}

- (void)animationDidStop {
    //    [nvMediaPlayer setM_isPauseRender:NO];//add by luo 201410419
}

- (void)StopPlay {
    
    //设置横屏竖屏button图片
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_cs_normal.png"] forState:UIControlStateNormal];
        
    }else{
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_normal.png"] forState:UIControlStateNormal];
        
    }
    
    [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_pressed.png"] forState:UIControlStateHighlighted];
    
    [nvMediaPlayer setPlaybackDelegate:nil];
    [nvMediaPlayer StopPlayBack];
    isPlaying = NO;
    nPlayIndexId = 0;
    // [playSlider setValue:0]; modify by qiumuze 20170719
    [playSlider setUserInteractionEnabled:NO];
}

- (void)StopNotice {
    isPlaying=NO;
    
    
    //设置横屏竖屏button图片
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_cs_normal.png"] forState:UIControlStateNormal];
        
    }else{
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_normal.png"] forState:UIControlStateNormal];
        
    }
    [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_pressed.png"] forState:UIControlStateHighlighted];
}

- (void)StartPlayInArea:(int)nPlayArea {
    
  
    
    AppDelegate *deleget = [(AppDelegate *)[[UIApplication sharedApplication] delegate] retain];
    
    if (deleget) {
        
        [deleget set_isPlaying:YES];
    }
    
    [deleget release];
    
    [nvMediaPlayer StopPlayBack];
    [nvMediaPlayer setPlaybackDelegate:self];
    [nvMediaPlayer setBackgroundColor:nil];
    
    [nvMediaPlayer SetAudioParam:[self m_bSoundEnable]];
    
    nPlayIndexId = 0;
    [playSlider setValue:0];
    [playSlider setUserInteractionEnabled:YES];
    isPlaying = YES;
    
    if (lLoginHandel && recFileList.count > 0 && nFileSelectedIndex >= 0 && nFileSelectedIndex < recFileList.count) {
        
        RecFileInfo *recFile = [[recFileList objectAtIndex:nFileSelectedIndex] retain];
        
        if (recFile) {
            
            //            [headerNote setText:[NSString stringWithFormat:@"%@", [recFile strFileName]]];
            [_lblRceFileName setText:[NSString stringWithFormat:@"%@", [recFile strFileName]]];//add by lusongbin 20160615
            [nvMediaPlayer StartPlayBack:lLoginHandel file:recFile];
            [nvMediaPlayer setLblTimeOSD:_PanoTimeLabel];
        }
        
        [recFile release];
    }
    //设置横屏竖屏button图片
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_cs_normal.png"] forState:UIControlStateNormal];
        
    }else{
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_normal.png"] forState:UIControlStateNormal];
        
    }
    [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_pressed.png"] forState:UIControlStateHighlighted];
}

- (void)onFinish {
    //设置横屏竖屏button图片
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_cs_normal.png"] forState:UIControlStateNormal];
        
    }else{
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_normal.png"] forState:UIControlStateNormal];
        
    }
    [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_pressed.png"] forState:UIControlStateHighlighted];
    
    [nvMediaPlayer setPlaybackDelegate:nil];
    [nvMediaPlayer StopPlayBack];
    isPlaying=NO;
    [playSlider setValue:0];
    [playSlider setUserInteractionEnabled:NO];
    
    
    //    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
    //        CGRect frame =m_rectFull;
    //        frame.size.width = frame.size.width;
    //        frame.origin.x = frame.origin.x;
    //        [nvMediaPlayer setFrame:frame];
    //
    //        [nvMediaPlayer setFrame:frame];
    //    }else{
    //        CGRect frame =m_rectNormal;
    //        frame.size.width = frame.size.width;
    //        frame.origin.x = frame.origin.x;
    //        [nvMediaPlayer setFrame:frame];
    //
    //        [nvMediaPlayer setFrame:frame];
    //    }
    
}

- (IBAction)onPlayAndStopClick:(id)sender {
    
    /*
    if (isPlaying) {
        
        [self StopPlay];
        
    } else {
        if (isPlayingClouldFile) {
            [self startPlayCloudFileInArea:0];
        }else{
            [self StartPlayInArea:0];
        }
    }
     */
    // add by qiumuze 20170719
    btnScreenShot.enabled = !btnScreenShot.enabled;
    btnPlayPrev.enabled = !btnPlayPrev.enabled;
    btnPlayNext.enabled = !btnPlayNext.enabled;
    btnSoundEnable.enabled = !btnSoundEnable.enabled;
    playSlider.enabled = !playSlider.enabled;
    pauseProgressValue = (int)playSlider.value;
    [nvMediaPlayer timeIndexWhenPause:(int)playSlider.value];
    if (isPlaying) {
        if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_cs_normal.png"] forState:UIControlStateNormal];
        } else {
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_normal.png"] forState:UIControlStateNormal];
        }
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_pressed.png"] forState:UIControlStateHighlighted];
        isPlaying = NO;
        [playSlider setUserInteractionEnabled:YES];
    } else {
   
            if (isfilePlaybackEnd) {
                isfilePlaybackEnd = NO;
                btnScreenShot.enabled = YES;
                btnPlayPrev.enabled = YES;
                btnPlayNext.enabled = YES;
                btnSoundEnable.enabled = YES;
                playSlider.enabled = YES;
                [self StartPlayInArea:0];
                return;
            }
        
            AppDelegate *deleget = [(AppDelegate *)[[UIApplication sharedApplication] delegate] retain];
            if (deleget) {
                [deleget set_isPlaying:YES];
            }
            [deleget release];
            [playSlider setUserInteractionEnabled:YES];
            isPlaying = YES;
            if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
                [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_cs_normal.png"] forState:UIControlStateNormal];
            } else {
                [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_normal.png"] forState:UIControlStateNormal];
            }
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_pressed.png"] forState:UIControlStateHighlighted];
        
    }
    // end add by qiumuze 20170719
}

- (IBAction)onAlertButtonClick:(id)sender {
    [vPlayBackAlertView removeFromSuperview];
    isBackAlertShow = NO;
    if (sender==btnAlertOK) {
        
        [self StopPlay];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)onPlayAreaClick {
    
    if (CGRectGetWidth(self.view.bounds) > CGRectGetHeight(self.view.bounds)) {
        //横屏
        nToolViewShowTickCount = 10;
        
      //add by zhantian 20170801
            nToolViewShowTickCount = 5;
            
            if ([self.view.subviews containsObject:self.camtypePopView]) {
                
                [self.camtypePopView removeFromSuperview];
                
            }
            
            
            if ([nvMediaPlayer.subviews containsObject:self.panoModeView]) {
                
                [self.panoModeView removeFromSuperview];
                
                
            } else if (_currentCamType ==  FISHEYECAMTYPEWALL){
                
                [nvMediaPlayer addSubview:self.panoModeView];
            }
            
      //end by zhantian 20170801

        
        if (CGRectGetMinY(topView.frame) == 0) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame;
                
                frame = topView.frame;
                frame.origin.y -= CGRectGetHeight(topView.frame);
                topView.frame = frame;
                
                frame = vSliderContainer.frame;
                frame.origin.y += (CGRectGetHeight(vSliderContainer.frame) + CGRectGetHeight(bottomView.frame));
                vSliderContainer.frame = frame;
                
                frame = bottomView.frame;
                frame.origin.y += (CGRectGetHeight(vSliderContainer.frame) + CGRectGetHeight(bottomView.frame));
                bottomView.frame = frame;
            }];
            
        } else {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame;
                
                frame = topView.frame;
                frame.origin.y = 0;
                topView.frame = frame;
                
                frame = vSliderContainer.frame;
                frame.origin.y -= (CGRectGetHeight(vSliderContainer.frame) + CGRectGetHeight(bottomView.frame));
                vSliderContainer.frame = frame;
                
                frame = bottomView.frame;
                frame.origin.y -= (CGRectGetHeight(vSliderContainer.frame) + CGRectGetHeight(bottomView.frame));
                bottomView.frame = frame;
            }];
        }
    }
}

- (IBAction)onSliderTouchDown:(id)sender {
    DLog(@"onSliderTouchDown: %f, %i" ,playSlider.value, isEditingSlider);
    isEditingSlider=YES;
}

- (IBAction)TouchUpInside:(id)sender {
    DLog(@"TouchUpInside: %f, %i" ,playSlider.value, isEditingSlider);
    if (isEditingSlider) {
        
        DLog(@"TouchUpInside:SetPlayIndex :%f" ,playSlider.value);
        if (playSlider.value>99) {
            isfilePlaybackEnd = YES;
            [nvMediaPlayer timeIndexWhenPause:0];
            [self onFinish];
        }
        if (playSlider.value == 0) {
            [self StartPlayInArea:0];
        }
        nPlayIndexId = [nvMediaPlayer SetPlayIndex:playSlider.value];
    }
    
    isEditingSlider=NO;
}

- (IBAction)TouchUpOutside:(id)sender {
    DLog(@"TouchUpOutside: %f, %i" ,playSlider.value, isEditingSlider);
    isEditingSlider=NO;
}

- (IBAction)TouchCancel:(id)sender {
    DLog(@"TouchCancel: %f, %i" ,playSlider.value, isEditingSlider);
    isEditingSlider=NO;
}

//手势判断
- (void)addGestureRecognizer {
    
    [nvMediaPlayer setUserInteractionEnabled:YES];
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlayAreaClick)];
    [nvMediaPlayer addGestureRecognizer:gesture];
}

/*
- (void)onProgressChange:(int) nProgress timeIndexID:(int)nTimeIndexID {
    
    //    DLog(@"nPlayIndexId = %i, nTimeIndexID= %i", nPlayIndexId, nTimeIndexID);//
    
    if (playSlider && !isEditingSlider && nPlayIndexId==nTimeIndexID) {
        
        [playSlider setValue:nProgress];
        if (nProgress>=100) {
            NSLog(@"回放结束2！！");
            [self onFinish];
        }
    }
}
*/
- (void)onProgressChange:(int) nProgress timeIndexID:(int)nTimeIndexID {
    
    NSLog(@"nPlayIndexId = %i, nTimeIndexID= %i", nPlayIndexId, nTimeIndexID);
    
    if (playSlider && !isEditingSlider /*&& nPlayIndexId==nTimeIndexID*/) {
        if (isInProgress) {
            [playSlider setValue:pauseProgressValue];
        }
        else {
            [playSlider setValue:nProgress];
        }
        
        if (nProgress>=99) { // modify by qiumuze 20172019
            NSLog(@"回放结束！！");
            // add by qiumuze 20170719
            isfilePlaybackEnd = YES;
            [nvMediaPlayer timeIndexWhenPause:0];
            // end add by qiumuze 20170719
            [self onFinish];
        }
    }
}



//show alert function
- (void)showAlertTitel:(NSString *)titel withMessage: (NSString *)message {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle: titel message:message delegate: nil cancelButtonTitle: NSLocalizedString(@"btnOK", @"OK") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)doLocalizable {
    
    return;
}

- (void)onApplicationDidBecomeActiveHandle:(NSNotification *)notification {
    NSLog(@"onApplicationDidBecomeActiveHandle");
    [nvMediaPlayer onApplicationDidBecomeActive];
    
}

- (void)onApplicationWillResignActiveHandle:(NSNotification *)notification {
    NSLog(@"onApplicationWillResignActiveHandle");
    [nvMediaPlayer onApplicationWillResignActive];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;//隐藏为YES，显示为NO
}

- (void)onTickCountTimer:(id)param {
    
    nToolViewShowTickCount--;
    
    if (nToolViewShowTickCount <= 0) {
        
        if (CGRectGetWidth(self.view.bounds) > CGRectGetHeight(self.view.bounds)) {
            
            if (CGRectGetMinY(topView.frame) == 0) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    CGRect frame;
                    
                    frame = topView.frame;
                    frame.origin.y -= CGRectGetHeight(topView.frame);
                    topView.frame = frame;
                    
                    frame = vSliderContainer.frame;
                    frame.origin.y += (CGRectGetHeight(vSliderContainer.frame) + CGRectGetHeight(bottomView.frame));
                    vSliderContainer.frame = frame;
                    
                    frame = bottomView.frame;
                    frame.origin.y += (CGRectGetHeight(vSliderContainer.frame) + CGRectGetHeight(bottomView.frame));
                    bottomView.frame = frame;
                    //add by zhantian 20170802
                    if([nvMediaPlayer.subviews containsObject:self.panoModeView]){
                    
                        [self.panoModeView removeFromSuperview];
                    }
                    //end by zhantian 
                }];
            }
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@",NSStringFromCGRect(imagePlayView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    @try {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            // iOS 7
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    topView.backgroundColor = DEFAULT_COLOR;
//    vSliderContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    if (recFileList == nil) {
        recFileList = [[NSMutableArray alloc] init];
    }
    _currentMode = 0;

    headerNote.adjustsFontSizeToFitWidth = YES;
    _lblRceFileName.adjustsFontSizeToFitWidth = YES;//add by lusongbin20160615
    [lnlAlertNotice setText:NSLocalizedString(@"noticeMsgStopAndback", @"Whether to stop and return to the list of devices?")];
    [btnAlertOK setTitle:NSLocalizedString(@"btnYES", @"YES") forState:UIControlStateNormal];
    [btnAlertCancel setTitle:NSLocalizedString(@"btnNO", @"NO") forState:UIControlStateNormal];
    
    toolViewShowTickCountTimmer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onTickCountTimer:)userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:toolViewShowTickCountTimmer forMode:NSDefaultRunLoopMode];
    nToolViewShowTickCount = 8;
    
    isEditingSlider = NO;
    isBackAlertShow = NO;
    
    nvMediaPlayer = [[NVPanoPlayer alloc] initWithFrame:imagePlayView.bounds];
    [_btnSetMode addTarget:self action:@selector(onBtnSetmodeClick) forControlEvents:UIControlEventTouchUpInside];
    nvMediaPlayer.contentMode = UIViewContentModeScaleAspectFit;
    [imagePlayView insertSubview:nvMediaPlayer belowSubview:vSliderContainer];
    [nvMediaPlayer SetAudioParam:YES];
    
    [self addGestureRecognizer];
    [self doLocalizable];
    
    m_bSoundEnable = YES;
    
    [self GetSettings];
    
    m_rectNormal = CGRectMake(0, 0, 320, 240);
    m_rectFull = self.view.bounds;
    
    [playSlider setValue:0];
    [playSlider setUserInteractionEnabled:NO];
    
    [LibContext InitResuorce];
    
    headerNote.text = NSLocalizedString(@"tabPlayback", @"Playback");
    
    //添加 消息observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActiveHandle:) name:@"ON_BECOME_ACTIVE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActiveHandle:) name:@"ON_RESIGN_ACTIVE" object:nil];
//    [self initInferface];
    
    // add by qiumuze 20170719
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(repeatForFilePlayBack:) name:@"FilePlayBackRepeat" object:nil];
    
    
    //add by zhantian 20170801
    _btnCamtype = [[UIButton alloc] init];
    [_btnCamtype addTarget:self action:@selector(ShowCamtypeSettingView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCamtype];
//    
//    frame = btnSoundEnable.frame;
//    frame.origin.x = containerWidth*3+btnScreenShot.frame.origin.x;
//    [btnReverseImage setFrame:frame];
//    
//    [btnReverseImage setTitle:NSLocalizedString(@"btnCamType", @"镜头") forState:UIControlStateNormal];
//    [btnReverseImage setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
//    
    //end by zhantian

}



// add by qiumuze 20170719
- (void)repeatForFilePlayBack: (NSNotification*)notiObj {

        dispatch_async(dispatch_get_main_queue(), ^{
            playSlider.enabled = NO;
            isInProgress = YES;
    
            AppDelegate *deleget = [(AppDelegate *)[[UIApplication sharedApplication] delegate] retain];
            if (deleget) {
                [deleget set_isPlaying:YES];
            }
            [deleget release];
            [nvMediaPlayer StopPlayBack];
            [nvMediaPlayer setPlaybackDelegate:self];
            [nvMediaPlayer setBackgroundColor:nil];
            [nvMediaPlayer SetAudioParam:[self m_bSoundEnable]];
            nPlayIndexId = 0;
            isPlaying = YES;
            if (lLoginHandel && recFileList.count > 0 && nFileSelectedIndex >= 0 && nFileSelectedIndex < recFileList.count) {
                RecFileInfo *recFile = [[recFileList objectAtIndex:nFileSelectedIndex] retain];
                if (recFile) {
                    [_lblRceFileName setText:[NSString stringWithFormat:@"%@", [recFile strFileName]]];
                    [nvMediaPlayer StartPlayBack:lLoginHandel file:recFile];
                }
                [recFile release];
            }
            if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
                [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_cs_normal.png"] forState:UIControlStateNormal];
            } else {
                [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_normal.png"] forState:UIControlStateNormal];
            }
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_pressed.png"] forState:UIControlStateHighlighted];
            [self updateButtonPhoto];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nvMediaPlayer SetPlayIndex:pauseProgressValue];
                    playSlider.enabled = YES;
                    isInProgress = NO;
                });
            });
        });
    
}
// end add by qiumuze 20170719


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _PanoTimeLabel.hidden = YES;

    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        topView.backgroundColor = [DEFAULT_COLOR colorWithAlphaComponent:0.5];
        bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }else{
        topView.backgroundColor = DEFAULT_COLOR;
        bottomView.backgroundColor = BACKGROUND_COLOR;
    }
    
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        _btnCamtype.hidden = YES; //add by zhantian 20170801
        
        //横屏
        
        [btnPlayPrev setImage:[UIImage imageNamed:@"btn_playback_last"] forState:UIControlStateNormal];
        [btnPlayPrev setImage:[UIImage imageNamed:@"btn_playback_last_click"] forState:UIControlStateHighlighted];
        [btnPlayNext setImage:[UIImage imageNamed:@"btn_playback_next"] forState:UIControlStateNormal];
        [btnPlayNext setImage:[UIImage imageNamed:@"btn_playback_next_click"] forState:UIControlStateHighlighted];
        
        //播放
        if (!isPlaying) {
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_cs_normal.png"] forState:UIControlStateNormal];
        }else{
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_cs_normal.png"] forState:UIControlStateNormal];
        }
        
        //截图
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_screenshot_cs_normal"] forState:UIControlStateNormal];
        
        //声音
        //横屏
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_cs_normal.png"] forState:UIControlStateNormal];
            
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_csnormal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_pressed.png"] forState:UIControlStateHighlighted];
        }
        
    }else{
        //竖屏
        _btnCamtype.hidden = NO; //add by zhantian 20170801
        
        [btnPlayPrev setImage:[UIImage imageNamed:@"btn_play_prev_normal"] forState:UIControlStateNormal];
        [btnPlayPrev setImage:[UIImage imageNamed:@"btn_play_prev_pressed"] forState:UIControlStateHighlighted];
        [btnPlayNext setImage:[UIImage imageNamed:@"btn_play_next_normal"] forState:UIControlStateNormal];
        [btnPlayNext setImage:[UIImage imageNamed:@"btn_play_next_pressed"] forState:UIControlStateHighlighted];
        
        //播放
        if (!isPlaying) {
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_play_normal.png"] forState:UIControlStateNormal];
        }else{
            [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_normal.png"] forState:UIControlStateNormal];
        }
        
        //截图
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_playback_screenshot_normal"] forState:UIControlStateNormal];
        
        //声音
        //竖屏
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_normal"] forState:UIControlStateNormal];//
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_pressed"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_pressed"] forState:UIControlStateHighlighted];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [self setVRecFileNameView:nil];
    [self setImgIconView:nil];
    [self setLblRceFileName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FilePlayBackRepeat" object:nil];// add by qiumuze 20170719
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ON_BECOME_ACTIVE" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ON_RESIGN_ACTIVE" object:nil];
    
    [_user release];
    [_device release];
    
    [gesture release];
    
    [lLoginHandel release];
    [recFileList release];
    
    [btnPlayPrev release];
    [btnPlayNext release];
    [btnScreenShot release];
    [vSliderContainer release];
    [vButtonsContainer release];
    [bottomView release];
    [playSlider release];
    
    [nvMediaPlayer release];//
    
    [topView release];
    
    [imagePlayView release];
    
    [btnBackToList release];
    [btnStopAndPlay release];
    
    [headerNote release];
    [btnSoundEnable release];
    
    [vPlayBackAlertView release];
    [vDialogView release];
    
    [btnAlertOK release];
    [btnAlertCancel release];
    [lnlAlertNotice release];
    
    [_vRecFileNameView release];
    [_imgRecFileIconView release];
    [_lblRceFileName release];
    [_btnSetMode release];
    [_PanoTimeLabel release];
    [_btnCamtype release]; //add by zhantian 20170801
    [super dealloc];
}

#pragma mark - 云服务录像文件回放

// 销毁相关属性
- (void)tearDown {
    
    [toolViewShowTickCountTimmer invalidate];
    toolViewShowTickCountTimmer = nil;
    [nvMediaPlayer removeGestureRecognizer:gesture];
}




// 设置横屏竖屏 button 图片
- (void)updateButtonPhoto {
    
    if (self.interfaceOrientation == UIDeviceOrientationLandscapeRight || self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_cs_normal.png"] forState:UIControlStateNormal];
        
    } else {
        
        [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_normal.png"] forState:UIControlStateNormal];
    }
    
    [btnStopAndPlay setImage:[UIImage imageNamed:@"btn_pause_pressed.png"] forState:UIControlStateHighlighted];
}

//add by zhantian 20170801
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if([self.view.subviews containsObject:self.camtypePopView]){
        
        [self.camtypePopView removeFromSuperview];
    
    }
    if([self.view.subviews containsObject:self.panoModeView]){
    
        [self.panoModeView removeFromSuperview];
    }


}

//end by zhantian



@end

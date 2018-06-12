//
//  IMobilePlayerPlayController.m
//  IMobilePlayer
//
//  Created by luo king on 11-12-12.
//  Copyright 2011 cctv. All rights reserved.
//


#import "FilePlaybackViewController.h"
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

#define widthDelta 1.0

@interface FilePlaybackViewController (){
 
    MBProgressHUD *HUD;
    UIView *imagePlayView;
    
    UILabel *headerNote;
    
    NVMediaPlayer *nvMediaPlayer;//
    
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
    
    BOOL isPlayingClouldFile;
    
}

@property  (retain) LoginHandle *lLoginHandel;
//add by lusongbin20160615
@property (retain, nonatomic) IBOutlet UIView *vRecFileNameView;
@property (retain, nonatomic) IBOutlet UIImageView *imgRecFileIconView;
@property (retain, nonatomic) IBOutlet UILabel *lblRceFileName;
//end add by lusongbin 20160615

// 用户信息
@property (nonatomic, retain) CLDUser *user;

// 设备信息
@property (nonatomic, retain) NVDevice *device;

@end

@implementation FilePlaybackViewController

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

- (IBAction)onScreenShotClick:(id)sender {
    [self screenShot];
}

- (IBAction)onPlayNextClick:(id)sender {
  
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

    if (isPlayingClouldFile) {
        [self startPlayCloudFileInArea:0];
        
    }else{
    
        [self StartPlayInArea:0];
    }
    
    CGRect frame = nvMediaPlayer.frame;
    frame.size.width = imagePlayView.frame.size.width;
    frame.size.height = imagePlayView.frame.size.height;
    nvMediaPlayer.frame = frame;
}

- (IBAction)onPlayPrevClick:(id)sender {
    
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
            
//            [headerNote setText:[NSString stringWithFormat:@"%@", [recFile strFileName]]];
            
            
            [_lblRceFileName setText:[NSString stringWithFormat:@"%@", [recFile strFileName]]];//add by lusongbin 20160615
        }
        
        [recFile release];
    }
    //add by lusongbin 20161101 判断云服务
    if (isPlayingClouldFile) {
        [self startPlayCloudFileInArea:0];
    }else{
        
        [self StartPlayInArea:0];
    }
    
    CGRect frame = nvMediaPlayer.frame;
    frame.size.width = imagePlayView.frame.size.width;
    frame.size.height = imagePlayView.frame.size.height;
    nvMediaPlayer.frame = frame;
}

- (IBAction)onBackAnStopClick:(id)sender {
    
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
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_normal"] forState:UIControlStateNormal];//
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_pressed.png"] forState:UIControlStateHighlighted];
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
    
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
//    [dateFormatter release];
//    
//    NSString *strFilename=[NSString stringWithFormat:@"%@.jpg",currentDateStr];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",strFilename]];   // 保存文件的名称
//    DLog(@"screenShot :%@", filePath);//add for test
    
//    if (image) {
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveImageResult:hasBeenSavedInPhotoAlbumWithEro:usingContextInfo:), nil);
//    }else{
//      
//        iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeScreenshotFail", @"Screenshot fail")];
//        [toast setToastPosition:kToastPositionCenter];
//        [toast setToastDuration:kToastDurationShort];
//        [toast show];
//        
//        [btnScreenShot setEnabled:YES];
    //    }
    
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
//add by lusongbin 20161122
-(void)ReSetHandle:(LoginHandle*)newHandle{
    [newHandle retain];
    if (newHandle) {
        [self setLLoginHandel:newHandle];
        [nvMediaPlayer ReSetPlaybackHandle:newHandle];
    }
    [newHandle release];
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
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_normal"] forState:UIControlStateNormal];//
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_pressed.png"] forState:UIControlStateHighlighted];
        }
    }
    
    
    
    
    
}

//iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation == self.preferredInterfaceOrientationForPresentation);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeRight || toInterfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        
        [UIView animateWithDuration:duration animations:^{
            
            topView.backgroundColor = [DEFAULT_COLOR colorWithAlphaComponent:0.5];
            bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

            vSliderContainer.hidden = NO;
        }];
        
    } else {
        
        [UIView animateWithDuration:duration animations:^{
            
            topView.backgroundColor = DEFAULT_COLOR;
            bottomView.backgroundColor = BACKGROUND_COLOR;
        }];
    }
    
    if (isBackAlertShow) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"noticeMsgStopAndback", @"Whether to stop and return to the list of devices?") leftButtonTitle:NSLocalizedString(@"btnYES", @"YES") rightButtonTitle:NSLocalizedString(@"btnNO", @"NO")];
        [alert show];
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
        
        imagePlayView.frame = bounds;
        nvMediaPlayer.frame = imagePlayView.bounds;
        
    } else {
        
        m_rectNormal.size.width = CGRectGetWidth(bounds);
        m_rectNormal.size.height = CGRectGetWidth(bounds) * 0.82;
        m_rectNormal.origin.x = 0;
        m_rectNormal.origin.y = CGRectGetMaxY(topView.frame);
        
        imagePlayView.frame = m_rectNormal;
        nvMediaPlayer.frame = imagePlayView.bounds;
    }
    
    // slider
    frame.size.width = CGRectGetWidth(imagePlayView.frame);
    frame.size.height = 31;
    frame.origin.x = 0;
    frame.origin.y = (CGRectGetWidth(bounds) > CGRectGetHeight(bounds)) ? ((CGRectGetMinY(vSliderContainer.frame) == CGRectGetHeight(bounds)) ? (CGRectGetHeight(imagePlayView.frame) - CGRectGetHeight(bottomView.frame) - CGRectGetHeight(vSliderContainer.frame)) : (CGRectGetHeight(bounds))) : (CGRectGetMaxY(imagePlayView.frame)+ 40);//40是文件名label的高
    vSliderContainer.frame = frame;
    playSlider.frame = vSliderContainer.bounds;
    
    // 底部按钮
    frame.size.width = CGRectGetWidth(bounds);
    frame.size.height = 100;
    frame.origin.x = (CGRectGetWidth(bounds) - CGRectGetWidth(frame)) * 0.5;
    frame.origin.y = (CGRectGetWidth(bounds) > CGRectGetHeight(bounds)) ? ((CGRectGetMinY(bottomView.frame) == (CGRectGetHeight(bounds) + CGRectGetHeight(vSliderContainer.frame))) ? (CGRectGetHeight(bounds) - CGRectGetHeight(frame)) : (CGRectGetHeight(bounds) + CGRectGetHeight(vSliderContainer.frame))) : (CGRectGetMaxY(imagePlayView.frame) + ((CGRectGetHeight(bounds) - CGRectGetMaxY(imagePlayView.frame) - CGRectGetHeight(frame)) * 0.6));
    bottomView.frame = frame;
    
    vButtonsContainer.frame = bottomView.bounds;

    //RecFileView
    //add by lusongbin 20160615
    frame = _vRecFileNameView.frame;
    frame.origin.y = CGRectGetMaxY(imagePlayView.frame);
    frame.origin.x = 0;
    frame.size.width = imagePlayView.frame.size.width;
    frame.size.height = 40;
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
    frame.size.width = imagePlayView.frame.size.width;
    frame.size.height = 40;
    _lblRceFileName.frame = frame;
    //end add by lusongbin 20160615
    
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
    
    nToolViewShowTickCount = 10;
    
    bottomView.hidden = NO;
    topView.hidden = NO;
    
    //设置横屏竖屏button图片
//    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
    if (CGRectGetWidth(bounds) > CGRectGetHeight(bounds)){

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
        
        //截图
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_playback_screenshot_normal"] forState:UIControlStateNormal];
       
        //声音
        //竖屏
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_normal"] forState:UIControlStateNormal];//
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_pressed.png"] forState:UIControlStateHighlighted];
        }
    }
    
    
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
    [playSlider setValue:0];
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
    
    isPlayingClouldFile = NO;
    
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
    
    if (isPlaying) {
        
        [self StopPlay];
        
    } else {
        
        if (isPlayingClouldFile) {
            [self startPlayCloudFileInArea:0];
        }else{
            [self StartPlayInArea:0];
        }
    }
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
    
        nToolViewShowTickCount = 10;
        
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
        
        NSLog(@"TouchUpInside:SetPlayIndex :%f" ,playSlider.value);
 
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

- (void)onProgressChange:(int) nProgress timeIndexID:(int)nTimeIndexID {

    NSLog(@"nPlayIndexId = %i, nTimeIndexID= %i", nPlayIndexId, nTimeIndexID);//
    
    if (playSlider && !isEditingSlider && nPlayIndexId==nTimeIndexID) {
        
        [playSlider setValue:nProgress];
        if (nProgress>=100) {
            NSLog(@"回放结束！！");
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
                }];
            }
        }
    }
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
    
    nvMediaPlayer = [[NVMediaPlayer alloc] initWithFrame:imagePlayView.frame];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {

    topView.backgroundColor = [DEFAULT_COLOR colorWithAlphaComponent:0.5];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }else{
    topView.backgroundColor = DEFAULT_COLOR;
    bottomView.backgroundColor = BACKGROUND_COLOR;
    }
    
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
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
        
        //截图
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_playback_screenshot_normal"] forState:UIControlStateNormal];
        
        //声音
        //竖屏
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_normal"] forState:UIControlStateNormal];//
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_playback_sound_off_pressed.png"] forState:UIControlStateHighlighted];
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
    [super dealloc];
}

#pragma mark - 云服务录像文件回放

// 销毁相关属性
- (void)tearDown {
    
    [toolViewShowTickCountTimmer invalidate];
    toolViewShowTickCountTimmer = nil;
    
    [nvMediaPlayer removeGestureRecognizer:gesture];
}

// 设置云服务录像文件列表的各种信息
- (void)setList:(NSArray *)list index:(int)index user:(CLDUser *)user device:(NVDevice *)device {
    
   }

// 开始播放云服务录像文件
- (void)startPlayCloudFileInArea:(int)area {
   }

// 停止播放
- (void)stopPlayCloudFile {
    
    // 设置横屏竖屏 button 图片
    [self updateButtonPhoto];
    
    [nvMediaPlayer setPlaybackDelegate:nil];
    [nvMediaPlayer StopCloudPlayBack];
    
    isPlaying = NO;
    nPlayIndexId = 0;
    playSlider.value =0;
    playSlider.userInteractionEnabled = YES;
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

@end

//
//  IMobilePlayerPlayController.m
//  IMobilePlayer
//
//  Created by luo king on 11-12-12.
//  Copyright 2011 cctv. All rights reserved.
//

#import "PlayViewController.h"
#import "GestureRecognizer.h"
#import "QuartzCore/QuartzCore.h"
#import "LoginHandle.h"
#import "FunctionTools.h"
#import "AppDelegate.h"
#import "iToast.h"
#import "DXAlertView.h"
#import "UIPTZLocationNote.h"
#import "UIWindow+YzdHUD.h"
#import "LibContext.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "LoginHelper.h"

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
CGFloat const gestureMinimumTranslation = 20.0;


@interface PlayViewController()<UIAlertViewDelegate>{
    NSString *strurl;
    BOOL isShowPanel;
    BOOL isRecording;
}
@property (nonatomic, copy) NSString *strName;

@property (retain, nonatomic) IBOutlet UIView *PlayBottomView;

@end

@implementation PlayViewController

@synthesize nChannels;
@synthesize imagePlayView, ivImagePlayViewBg;//the

@synthesize vScreenShotView;
@synthesize topView, headerNote, ivTopViewBg, btnShowMore;

@synthesize isPlaying;

@synthesize chnFlag;
@synthesize rowHeight;
@synthesize strName;


@synthesize bottomView;
@synthesize customSize;
@synthesize nZoomIndex;
@synthesize btnBackToList, btnSoundEnable, btnImgQL, btnReverseImage, btnScreenShot, btnBack;
@synthesize m_bSoundEnable;
@synthesize lblPTZNotice;
@synthesize vQLPanel, ivQLPanelBg, ivQLPanelSpiter, btnQualityHD, btnQualitySmooth;
@synthesize lblCanSpeakNotice;
@synthesize ivBottomViewBg;

@synthesize vPTZPanel, ivPTZLeft, ivPTZRight, ivPTZUp, ivPTZDown;
@synthesize fScreenWith, fScreenHeight,fStepDistance;
@synthesize nPTZXCount;
@synthesize vPTZXPanel, ivPTZXBG;
@synthesize vPTZXLanBtnContanner, ivTZXLanBtnBG, btnPTZXLan;
@synthesize vPTZXContainView, ivPTZXContainViewBG, vPTZXContainViewTop, ivPTZXContainViewTopBG,btnPTZXPanelClose, scvPTZXPointList, lblPTZXTitle;

@synthesize _loginParam;


-(void)loginServer{
    
    
    NVDevice *info = [[NVDevice alloc] init];
    
    [info setStrServer:@"192.168.1.1"];
    [info setNPort:8800];
    [info setStrMacAddress:@"ABC"];
    [info setDevID:28182146];
    [info setStrUsername:@"admin"];
    [info setStrPassword:@"admin123"];
    [info setNAddType:ADD_TYPE_SEARCH_FROM_LAN];
    [info setNConfigID:1];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self loginThreadFunc:info];
        
    });
}
-(void)loginThreadFunc:(NVDevice *)device {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    LoginHandle *loginResult = [LoginHelper getDeviceParam:device withConnectType:0];
    
        if(loginResult!=nil){
            NSLog(@"loginResult result = %d",[loginResult nResult]);//add for test
        }else{
            NSLog(@"loginResult nil");//add for test
        }
        if (loginResult && [loginResult nResult]==RESULT_CODE_SUCCESS) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                nStreamType=STREAM_TYPE_SMOOTH;
                
                [self set_loginParam:loginResult];
                
                [ivPTZLeft setUserInteractionEnabled:YES];
                [ivPTZRight setUserInteractionEnabled:YES];
                [ivPTZUp setUserInteractionEnabled:YES];
                [ivPTZDown setUserInteractionEnabled:YES];
                
                if (strName && [strName length]>0) {
                    
                    [headerNote setText:[NSString stringWithFormat:@"%@", strName]];
                }else{
                    
                    [headerNote setText:[NSString stringWithFormat:@"%i", [_loginParam nDevID]]];
                }
                
                [self initInferface];
                
                [self StartPlay:1 area:0];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                iToast *toast = [iToast makeToast:@"登录失败,请重新登陆"];
                [toast retain];
                [toast setToastPosition:kToastPositionCenter];
                [toast setToastDuration:kToastDurationShort];
                [toast show];
                [toast release];
                
                NSLog(@"登录失败");
                [self onBackAnStopClick:nil];
            });
            
        }
    
    
    [pool release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        [self onBackAnStopClick:nil];
    }else {
        [self loginServer];
    }
    
}
-(IBAction) onScreenShotClick:(id)sender{
    
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [self.view.window addSubview:HUD];
    
    HUD.delegate = nil;
    HUD.labelText =  @"正在截图...";
    [HUD showWhileExecuting:nil onTarget:self withObject:nil animated:YES];
    dispatch_after(1.0f, dispatch_get_main_queue(), ^{
        [self screenShot];
        
    });
    
}

-(IBAction) onReverseImageClick:(id)sender{
    if ([_loginParam bReverse_PRI]) {
        [nvMediaPlayer SetImageOrientation:1000];
    }else{
        isReverse=!isReverse;
        [self setPlayViewOrentation];
    }
}


#define NV_PRESET_ACTION_SET 102//
#define NV_PRESET_ACTION_LOCATION 103//
//设置预置位按下事件
-(void) onPTZXSettingClick:(id)sender{
    NSLog(@"onPTZXSettingClick 1");
    UIPTZLocationNote *ptzxNote = sender;
    [ptzxNote retain];
    if (ptzxNote) {
        NSLog(@"onPTZXSettingClick 2");
        if (ptzxNote.tag>=0 && ptzxNote.tag<nPTZXCount) {
            NSLog(@"onPTZXSettingClick 3");
            [self ptzcxSet:ptzxNote.tag action:NV_PRESET_ACTION_SET];
        }
    }
    [ptzxNote release];
    
}

//设置预置位
-(void)ptzcxLocat:(int)nPTZXID action:(int)nAction{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        int bResult = [nvMediaPlayer setPTZXLocationID:nPTZXID handle:_loginParam];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (bResult==RESULT_CODE_SUCCESS) {
                //                :NSLocalizedString(@"noticeHDTips", @"Horizontal screen will present better for HD Video")
                iToast *toast = [iToast makeToast:@"set ok"];
                [toast retain];
                [toast setToastPosition:kToastPositionCenter];
                [toast setToastDuration:kToastDurationShort];
                [toast show];
                [toast release];
            }else{
                iToast *toast = [iToast makeToast:@"set fail"];
                [toast retain];
                [toast setToastPosition:kToastPositionCenter];
                [toast setToastDuration:kToastDurationShort];
                [toast show];
                [toast release];
            }
            
        });
        
    });
}
-(void)ptzcxSet:(int)nPTZXID action:(int)nAction{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//note for temp
        int bResult = [nvMediaPlayer setPTZXLocationID:nPTZXID handle:_loginParam];
        if (bResult) {
            UIImage *image =[nvMediaPlayer screenShot];
            [image retain];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updatePTZXPic:nPTZXID image:image];
                });
                
                [vPTZXPanel setHidden:YES];
                
                iToast *toast = [iToast makeToast:NSLocalizedString(@"lblLocationOK", @"Position setting OK")];
                [toast retain];
                [toast setToastPosition:kToastPositionCenter];
                [toast setToastDuration:kToastDurationShort];
                [toast show];
                [toast release];
            });
            
            [image release];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [vPTZXPanel setHidden:YES];
                iToast *toast = [iToast makeToast:NSLocalizedString(@"lblLocationFail", @"Position setting fail")];
                [toast retain];
                [toast setToastPosition:kToastPositionCenter];
                [toast setToastDuration:kToastDurationShort];
                [toast show];
                [toast release];
                
            });
        }
    });
}

-(BOOL)updatePTZXPic:(int) nPTZXID image:(UIImage *)image{
      return YES;
}
-(void) onPTZXLocatingClick:(id)sender{
    UIPTZLocationNote *ptzxNote = sender;
    [ptzxNote retain];
    if (ptzxNote) {
        if (ptzxNote.tag>=0 && ptzxNote.tag<nPTZXCount) {
            [nvMediaPlayer callPTZXLocationID:ptzxNote.tag handle:_loginParam];
            [vPTZXPanel setHidden:YES];
        }
    }
    [ptzxNote release];
}


-(void)showLanPTZXButton:(BOOL)isShow{
    
    [vPTZXLanBtnContanner setHidden:!isShow];
    if (isShow) {
        CGRect frame = vPTZXLanBtnContanner.frame;
        frame.origin.x = m_rectFull.size.width - 80;
        frame.origin.y = 0;
        frame.size.width = 80;
        frame.size.height = 80;
        [vPTZXLanBtnContanner setFrame:frame];
        
        frame = btnPTZXLan.frame;
        frame.size.width = 50;
        frame.size.height = 50;
        frame.origin.x = (vPTZXLanBtnContanner.frame.size.width -frame.size.width)/2;
        frame.origin.y =  (vPTZXLanBtnContanner.frame.size.height -frame.size.height)/2;
        [btnPTZXLan setFrame:frame];
        [vPTZXLanBtnContanner addSubview:btnPTZXLan];
        
        
    }
    
}

-(void)setPlayViewOrentation{
    
    [nvMediaPlayer SetImageOrientation:isReverse];
}

-(IBAction) onMicShowClick:(id)sender{
    
}

-(IBAction)canShowPTZLocationSetting{
    
    NSLog(@"canShowPTZLocationSetting");//
    
    if ([_loginParam bPTZX_PRI]){
        nPTZXCount = [_loginParam nPTZXCount];
        [self onShowPTZLocationSettingView:nil];
    }else{
        iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeDeviceNoPTZ", @"Device does not support ptz")];
        [toast setToastPosition:kToastPositionCenter];
        [toast setToastDuration:kToastDurationShort];
        [toast show];
    }

}
#define PTZX_ITEM_HEIGHT 80

-(IBAction) onShowPTZLocationSettingView:(id)sender{
    if (![vPTZXPanel isHidden]) {//关闭
        [vPTZXPanel setHidden:YES];
        [self.view removeFromSuperview];
        return;
    }
    
    //显示预置位配置
    CGRect rect = m_rectFull;
    rect.origin.x  = 0;
    rect.origin.y = 0;
    [vPTZXPanel setFrame:rect];
    [ivPTZXBG setFrame:rect];
    
    [ivPTZXBG setHidden:YES];
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        rect = vPTZXPanel.frame;
        rect.size.height = m_rectFull.size.height;
        rect.size.width = m_rectFull.size.height;
        rect.origin.x = 0;
        rect.origin.y = 0;
        [vPTZXContainView setFrame:rect];
        
        rect.origin.x = 0;
        rect.origin.y = 0;
        [ivPTZXContainViewBG setFrame:rect];
        
        rect = vPTZXContainView.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        [scvPTZXPointList setFrame:rect];
        
        rect = scvPTZXPointList.frame;
        rect.size.height = 80;
        rect.size.width = scvPTZXPointList.frame.size.width*0.8;
        if (rect.size.width>250) {
            rect.size.width = 250;
        }else if (rect.size.width<160) {
            rect.size.width = 160;
        }
        rect.origin.x = (scvPTZXPointList.frame.size.width-rect.size.width)/2;
        rect.origin.y = 2;
        [location1 setFrame:rect];
        
        [vPTZXContainViewTop setHidden:YES];
        [lblPTZXTitle setHidden:YES];
        
        
        
    }else{
        
        [vPTZXContainViewTop setHidden:NO];
        [lblPTZXTitle setHidden:NO];
        
        rect = vPTZXPanel.frame;
        //        rect.size.height = PTZX_ITEM_HEIGHT *nPTZXCount+30;
        //        if (rect.size.height>vPTZXPanel.frame.size.height * 0.65) {
        //            rect.size.height = vPTZXPanel.frame.size.height * 0.65;
        //        }else if (rect.size.height<vPTZXPanel.frame.size.height*0.4){
        //            rect.size.height = vPTZXPanel.frame.size.height * 0.4;
        //        }
        rect.size.height=vPTZXPanel.frame.size.height - imagePlayView.frame.size.height;
        
        rect.origin.y = vPTZXPanel.frame.size.height - rect.size.height;
        [vPTZXContainView setFrame:rect];
        rect.origin.x = 0;
        rect.origin.y = 0;
        [ivPTZXContainViewBG setFrame:rect];
        
        rect = vPTZXContainView.frame;
        rect.size.height = 30;
        rect.origin.x = 0;
        rect.origin.y = 0;
        [lblPTZXTitle setFrame:rect];
        
        rect = vPTZXContainView.frame;
        rect.size.height = 40;
        rect.origin.x = 0;
        rect.origin.y = vPTZXContainView.frame.size.height-rect.size.height;
        
        [vPTZXContainViewTop setFrame:rect];
        rect.origin.y = 0;
        [ivPTZXContainViewTopBG setFrame:rect];
        
        rect = ivPTZXContainViewTopBG.frame;
        rect.size.height = rect.size.height-4;
        rect.size.width = rect.size.width *0.6;
        if (rect.size.width>250) {
            rect.size.width = 250;
        }
        rect.origin.x = (ivPTZXContainViewTopBG.frame.size.width - rect.size.width)/2;
        rect.origin.y = (ivPTZXContainViewTopBG.frame.size.height - rect.size.height)/2;
        [btnPTZXPanelClose setFrame:rect];
        
        rect = vPTZXContainView.frame;
        rect.origin.x = 0;
        rect.origin.y = lblPTZXTitle.frame.origin.y + lblPTZXTitle.frame.size.height;
        rect.size.height = vPTZXContainView.frame.origin.y- rect.origin.y+10;
        [scvPTZXPointList setFrame:rect];
        
        rect = scvPTZXPointList.frame;
        rect.size.height = 80;
        rect.size.width = scvPTZXPointList.frame.size.width*0.8;
        if (rect.size.width>250) {
            rect.size.width = 250;
        }else if (rect.size.width<160) {
            rect.size.width = 160;
        }
        rect.origin.x = (scvPTZXPointList.frame.size.width-rect.size.width)/2;
        rect.origin.y = 2;
        [location1 setFrame:rect];
        
    }
    CGSize cgSize;
    cgSize.width = scvPTZXPointList.frame.size.width;
    cgSize.height = location1.frame.size.height*nPTZXCount+nPTZXCount*2 ;
    [scvPTZXPointList setContentSize:cgSize];
    
    
    //
    if (nPTZXCount>=1) {
        [location1 setHidden:NO];
    }else{
        [location1 setHidden:YES];
    }
    if (nPTZXCount>=2) {
        [location2 setHidden:NO];
    }else{
        [location2 setHidden:YES];
    }
    if (nPTZXCount>=3) {
        [location3 setHidden:NO];
    }else{
        [location3 setHidden:YES];
    }
    if (nPTZXCount>=4) {
        [location4 setHidden:NO];
    }else{
        [location4 setHidden:YES];
    }
    if (nPTZXCount>=5) {
        [location5 setHidden:NO];
    }else{
        [location5 setHidden:YES];
    }
    if (nPTZXCount>=6) {
        [location6 setHidden:NO];
    }else{
        [location6 setHidden:YES];
    }
    if (nPTZXCount>=7) {
        [location7 setHidden:NO];
    }else{
        [location7 setHidden:YES];
    }
    if (nPTZXCount>=8) {
        [location8 setHidden:NO];
    }else{
        [location8 setHidden:YES];
    }
    if (nPTZXCount>=9) {
        [location9 setHidden:NO];
    }else{
        [location9 setHidden:YES];
    }
    
    
    rect=location1.frame;
    rect.origin.y = location1.frame.origin.y + location1.frame.size.height;
    [location2 setFrame:rect];
    
    rect=location2.frame;
    rect.origin.y = location2.frame.origin.y + location2.frame.size.height;
    [location3 setFrame:rect];
    
    rect=location3.frame;
    rect.origin.y = location3.frame.origin.y + location3.frame.size.height;
    [location4 setFrame:rect];
    
    rect=location4.frame;
    rect.origin.y = location4.frame.origin.y + location4.frame.size.height;
    [location5 setFrame:rect];
    
    rect=location5.frame;
    rect.origin.y = location5.frame.origin.y + location5.frame.size.height;
    [location6 setFrame:rect];
    
    rect=location6.frame;
    rect.origin.y = location6.frame.origin.y + location6.frame.size.height;
    [location7 setFrame:rect];
    
    rect=location7.frame;
    rect.origin.y = location7.frame.origin.y + location7.frame.size.height;
    [location8 setFrame:rect];
    
    rect=location8.frame;
    rect.origin.y = location8.frame.origin.y + location8.frame.size.height;
    [location9 setFrame:rect];
    
    [scvPTZXPointList addSubview:location1];
    [scvPTZXPointList addSubview:location2];
    [scvPTZXPointList addSubview:location3];
    [scvPTZXPointList addSubview:location4];
    [scvPTZXPointList addSubview:location5];
    [scvPTZXPointList addSubview:location6];
    [scvPTZXPointList addSubview:location7];
    [scvPTZXPointList addSubview:location8];
    [scvPTZXPointList addSubview:location1];
    
    
    [vPTZXPanel setHidden:NO];
    [self.view addSubview:vPTZXPanel];
    
    [vPTZXPanel addSubview:ivPTZXBG];
    [vPTZXPanel addSubview:vPTZXContainView];
    
    vPTZXContainView.transform = CGAffineTransformIdentity;
    
    [self initPTZXUI];
    
    // 延迟2秒执行线程
    double delayInSeconds =0.5;
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        CGRect rectEnd = vPTZXContainView.frame;
        CGRect rectStart = rectEnd;
        rectStart.origin.x = rectEnd.origin.x-rectEnd.size.width;
        vPTZXContainView.frame=rectStart;
        
        [UIView beginAnimations:@"pullup" context:vPTZXContainView];
        [UIView setAnimationDuration:delayInSeconds];
        [UIView setAnimationDelegate:self];
        
        [UIView setAnimationDidStopSelector:nil];
        vPTZXContainView.frame=rectEnd;
        
        [UIView commitAnimations];
    }else{
        CGRect rectEnd = vPTZXContainView.frame;
        CGRect rectStart = rectEnd;
        rectStart.origin.y = rectEnd.origin.y+rectEnd.size.height;
        vPTZXContainView.frame=rectStart;
        
        [UIView beginAnimations:@"pullup" context:vPTZXContainView];
        [UIView setAnimationDuration:delayInSeconds];
        [UIView setAnimationDelegate:self];
        
        [UIView setAnimationDidStopSelector:nil];
        vPTZXContainView.frame=rectEnd;
        
        [UIView commitAnimations];
    }
    
    
    
    dispatch_time_t popTime =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
    dispatch_after(popTime,dispatch_get_main_queue(), ^(void){
        [ivPTZXBG setHidden:NO];
    });

   
}
-(void)topMoreStatChange:(BOOL)isHide{
    [vPTZXPanel setHidden:YES];
    
}
-(void) onHidePTZLocationSettingView:(id)sender{
    
    // 延迟2秒执行线程
    double delayInSeconds =0.5;
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        CGRect rectEnd = vPTZXContainView.frame;
        CGRect rectStart = rectEnd;
        rectStart.origin.x = rectEnd.origin.x-rectEnd.size.width;
        vPTZXContainView.frame=rectEnd;
        
        [UIView beginAnimations:@"pullup"context:vPTZXContainView];
        [UIView setAnimationDuration:delayInSeconds];
        [UIView setAnimationDelegate:self];
        
        [UIView setAnimationDidStopSelector:nil];
        vPTZXContainView.frame= rectStart;
        
        [UIView commitAnimations];
    }else{
        CGRect rectEnd = vPTZXContainView.frame;
        CGRect rectStart = rectEnd;
        rectStart.origin.y = rectEnd.origin.y+rectEnd.size.height;
        vPTZXContainView.frame=rectEnd;
        
        [UIView beginAnimations:@"pullup"context:vPTZXContainView];
        [UIView setAnimationDuration:delayInSeconds];
        [UIView setAnimationDelegate:self];
        
        [UIView setAnimationDidStopSelector:nil];
        vPTZXContainView.frame= rectStart;
        
        [UIView commitAnimations];
    }
    
    dispatch_time_t popTime =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
    dispatch_after(popTime,dispatch_get_main_queue(), ^(void){
        [vPTZXPanel setHidden:YES];
        [vPTZXPanel removeFromSuperview];
    });
    
    
    return;
}

-(void)qlStatChange:(BOOL)isHide{//add by luo 20141104
    
}

-(void)micStatChange:(BOOL)isHide{
    
}


-(void)screenShot{
    [btnScreenShot setEnabled:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image =[nvMediaPlayer screenShot];
        [image retain];
        dispatch_after(0.1f, dispatch_get_main_queue(), ^{
            
            if (image) {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveImageResult:hasBeenSavedInPhotoAlbumWithEro:usingContextInfo:), nil);
                
                
            }else{
                if (HUD) {
                    [HUD hide:YES];
                }
                
                dispatch_after(1.f, dispatch_get_main_queue(), ^{
                    iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeScreenshotFail", @"Screenshot fail")];
                    [toast setToastPosition:kToastPositionCenter];
                    [toast setToastDuration:kToastDurationShort];
                    [toast show];
                });
                
                
                [btnScreenShot setEnabled:YES];
            }
            
            
        });
        
        [image release];
    });
    
}
//ok
-(void)saveImageResult:(UIImage *)image hasBeenSavedInPhotoAlbumWithEro:(NSError *)error usingContextInfo:(void *)ctxInfo{ [btnScreenShot setEnabled:YES];
    
    if (error) {
        
        if (image && [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
            
            if (HUD) {
                [HUD hide:YES];
            }
            
            dispatch_after(1.f, dispatch_get_main_queue(), ^{
                iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeSCNOAlbumsPri", @"Screenshot fail, check if the app has the permission to access album")];
                [toast setToastPosition:kToastPositionCenter];
                [toast setToastDuration:kToastDurationShort];
                [toast show];
            });
            
        }else{
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
        
    }else{
        
        if (HUD) {
            [HUD hide:YES];
        }
        
        dispatch_after(1.f, dispatch_get_main_queue(), ^{
            iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeFileSaveToAlbums", @"Picture has been save to album")];
            [toast setToastPosition:kToastPositionCenter];
            [toast setToastDuration:kToastDurationShort];
            [toast show];
        });
        
        
    }
    
}

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    
    return bCanRecord;
}

-(IBAction) onBackAnStopClick:(id)sender{
    
        if (isPlaying) {
            
            isBackAlertShow=YES;
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"noticeMsgStopAndback", @"Whether to stop and return to the list of devices?") leftButtonTitle:NSLocalizedString(@"btnYES", @"YES") rightButtonTitle:NSLocalizedString(@"btnNO", @"NO")];
            [alert show];
            alert.leftBlock = ^() {
                
                if (isRecording) {
                    [self SetbtnEnable:YES];
                    [_btnStartRecord setImage:[UIImage imageNamed:@"btn_recording.png"] forState:UIControlStateNormal];
                    [nvMediaPlayer StopRecord];
                    isRecording = NO;
                    
                    NSURL *url = [NSURL fileURLWithPath:strurl];
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                    NSString *albumName = NSLocalizedString(@"appName", @"app's name");
                    
                    [library saveVideo:url toAlbum:albumName completion:^(NSURL *assetURL, NSError *error) {
                        NSLog(@"保存成功");
                        if (error == nil) {
                            
                            if (HUD) {
                                [HUD hide:YES];
                            }
                            
                            dispatch_after(1.f, dispatch_get_main_queue(), ^{
                                iToast *toast = [iToast makeToast:@"录像已经保存到相册"];
                                [toast setToastPosition:kToastPositionCenter];
                                [toast setToastDuration:kToastDurationShort];
                                [toast show];
                                [_btnStartRecord setEnabled:YES];
                            });
                            
                        } else {
                            
                            NSLog(@"err = %@", error);
                        }
                    } failure:^(NSError *error) {
                        NSLog(@"err = %@", error);
                        NSLog(@"保存失败");
                    }];
                }
                [self StopPlay:YES];
                
                AppDelegate *deleget = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [deleget retain];
                if (deleget) {
                    [deleget set_isPlaying:NO];
                }
                [deleget release];
                
                [self dismissViewControllerAnimated:NO completion:^{}];
                //                [self dismissModalViewControllerAnimated:NO];
                
                isBackAlertShow=NO;
                if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
                    [nvMediaPlayer setFrame:m_rectFull];
                }else{
                    
                    [nvMediaPlayer setFrame:m_rectNormal];
                }
                
                isBackAlertShow=NO;
            };
            alert.rightBlock = ^() {
                isBackAlertShow=NO;
            };
            
            
            
        }else{
            if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
                [nvMediaPlayer setFrame:m_rectFull];
            }else{
                
                [nvMediaPlayer setFrame:m_rectNormal];
            }
            
            
            AppDelegate *deleget = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [deleget retain];
            if (deleget) {
                [deleget set_isPlaying:NO];
            }
            [deleget release];
            
            [self dismissViewControllerAnimated:NO completion:^{}];
        }
        
        
        
    
    
}

-(IBAction) SoundEnableClick:(id)sender{
    
    m_bSoundEnable = !m_bSoundEnable;
    

    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs_click"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_pressed.png"] forState:UIControlStateHighlighted];
        }
  
    }else{
    
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_on_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_mute"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_mute_click"] forState:UIControlStateHighlighted];
        }
       
    }
    dispatch_async(dispatch_get_main_queue(), ^{

        [nvMediaPlayer SetAudioParam:m_bSoundEnable];
    });
    
    [self SaveSettings];
}

-(IBAction) onImageQLClick:(id)sender{
    
    UIButton *btn = sender;
    [btnImgQL setUserInteractionEnabled:NO];
    
        if (nStreamType==STREAM_TYPE_HD) {
            [btnImgQL setTitle:NSLocalizedString(@"lblNormal", @"SD") forState:UIControlStateNormal];

            if (nStreamType!=STREAM_TYPE_SMOOTH) {
               
                
                nStreamType=STREAM_TYPE_SMOOTH;
                if(isPlaying){
                    [self StopPlay: NO];
                    [self StartPlay:1 area:0];
                    //禁止点击延迟一秒 add by lusongbin 20160926
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [btnImgQL setUserInteractionEnabled:YES];
                    });
                    //add by luo 20141009
                    if(nStreamType==STREAM_TYPE_HD && (self.interfaceOrientation!=UIDeviceOrientationLandscapeRight && self.interfaceOrientation!=UIDeviceOrientationLandscapeLeft)){
                        
                        //当前为屏竖
                        iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeHDTips", @"Horizontal screen will present better for HD Video")];
                        [toast retain];
                        [toast setToastPosition:kToastPositionCenter];
                        [toast setToastDuration:kToastDurationShort];
                        [toast show];
                        [toast release];
                        
                    }
                    //end add by luo 20141009
                }
            }
        }else if (nStreamType==STREAM_TYPE_SMOOTH){
            
            [btnImgQL setTitle:NSLocalizedString(@"lblHD", @"HD") forState:UIControlStateNormal];
           
            if (nStreamType!=STREAM_TYPE_HD) {
                nStreamType=STREAM_TYPE_HD;
                if(isPlaying){
                    [self StopPlay: NO];
                    [self StartPlay:1 area:0];
                    //禁止点击延迟一秒
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [btnImgQL setUserInteractionEnabled:YES];
                    });
                    //add by luo 20141009
                    if(nStreamType==STREAM_TYPE_HD && (self.interfaceOrientation!=UIDeviceOrientationLandscapeRight && self.interfaceOrientation!=UIDeviceOrientationLandscapeLeft)){//当前为屏竖
                        iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeHDTips", @"Horizontal screen will present better for HD Video")];
                        [toast retain];
                        [toast setToastPosition:kToastPositionCenter];
                        [toast setToastDuration:kToastDurationShort];
                        [toast show];
                        [toast release];
                    }
                    //end add by luo 20141009
                }
                
            }
        }
}

-(IBAction) onImageQLSelectClick:(id)sender{
    if (sender==btnQualityHD) {
        
        if (nStreamType==STREAM_TYPE_HD) {
            return;
        }
        [btnQualityHD setTitleColor:[UIColor colorWithRed:0.246 green:0.467 blue:0.894 alpha:1]  forState:UIControlStateNormal];
//        [btnQualityHD setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];

        
        [btnQualitySmooth setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        
        
        nStreamType=STREAM_TYPE_HD;
        
        
    }else if (sender==btnQualitySmooth){
        if (nStreamType==STREAM_TYPE_SMOOTH) {
            return;
        }
        
        [btnQualityHD setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btnQualitySmooth setTitleColor:[UIColor colorWithRed:0.246 green:0.467 blue:0.894 alpha:1] forState:UIControlStateNormal];
        
        nStreamType=STREAM_TYPE_SMOOTH;
        
    }
    
    //重启连接
    if(isPlaying){
        [self StopPlay: NO];
        [self StartPlay:1 area:0];
        
        //add by luo 20141009
        if(nStreamType==STREAM_TYPE_HD && (self.interfaceOrientation!=UIDeviceOrientationLandscapeRight && self.interfaceOrientation!=UIDeviceOrientationLandscapeLeft)){//当前为屏竖
            iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeHDTips", @"Horizontal screen will present better for HD Video")];
            [toast retain];
            [toast setToastPosition:kToastPositionCenter];
            [toast setToastDuration:kToastDurationShort];
            [toast show];
            [toast release];
            
        }
        //end add by luo 20141009
    }
    
    [self micStatChange:YES];
    [self qlStatChange:YES];
}
//ok
-(void)initPTZXUI{

}
//ok
-(void) SetLoginParam:(id)param{
    LoginHandle *loginParam = (LoginHandle *)param;
    [loginParam retain];
    if (loginParam) {
        nStreamType=STREAM_TYPE_SMOOTH;
        
        [self set_loginParam:loginParam];
        
        
        
        [ivPTZLeft setUserInteractionEnabled:YES];
        [ivPTZRight setUserInteractionEnabled:YES];
        [ivPTZUp setUserInteractionEnabled:YES];
        [ivPTZDown setUserInteractionEnabled:YES];
        
        
        if (strName && [strName length]>0) {
            
            [headerNote setText:[NSString stringWithFormat:@"%@", strName]];
        }else{
            
            [headerNote setText:[NSString stringWithFormat:@"%i", [_loginParam nDevID]]];
        }
        
        
    }
    
    [loginParam release];
    [self initPTZXUI];
    
    [self initInferface];
    }
//ok
-(void)SaveSettings{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault retain];
    
    if (userDefault) {
        
        [userDefault setValue:[NSNumber numberWithBool:m_bSoundEnable] forKey:@"sound_enable"];
        [userDefault synchronize];
        
    }
    [userDefault release];
}
//ok
-(void)GetSettings{
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
    
    
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs_click"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_pressed.png"] forState:UIControlStateHighlighted];
        }
        
    }else{
        
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_on_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_mute"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_mute_click"] forState:UIControlStateHighlighted];
        }
        
    }
}

//iOS 5
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (isRecording || [nvMediaPlayer isSpeaking]) {//add by luo 20150323
        return NO;
    }
    return (toInterfaceOrientation == self.preferredInterfaceOrientationForPresentation);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    [self initInferface];
    
    
    [nvMediaPlayer updateRender];
    [nvMediaPlayer freshRender];
    if (isBackAlertShow) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"noticeMsgStopAndback", @"Whether to stop and return to the list of devices?") leftButtonTitle:NSLocalizedString(@"btnYES", @"YES") rightButtonTitle:NSLocalizedString(@"btnNO", @"NO")];
        [alert show];
        alert.leftBlock = ^() {
            [self StopPlay:YES];
            
            [self dismissModalViewControllerAnimated:NO];
            isBackAlertShow=NO;
            if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
                [nvMediaPlayer setFrame:m_rectFull];
            }else{
                
                [nvMediaPlayer setFrame:m_rectNormal];
            }
            
            isBackAlertShow=NO;
        };
        alert.rightBlock = ^() {
            isBackAlertShow=NO;
        };
        
        
    }
    
}

//iOS 6
- (BOOL) shouldAutorotate
{
    if (isRecording || [nvMediaPlayer isSpeaking]) {//add by luo 20150323
        return NO;
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

-(void) initInferface{
    
    CGRect screenSize = [[UIScreen mainScreen] applicationFrame];
    [self.view setFrame:screenSize];
    
    
    isPTZLeftPressed = NO;
    isPTZRightPressed = NO;
    isPTZUPPressed=NO;
    isPTZDownPressed=NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {//modify by luo 20141104
        if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
            
            
            CGFloat fWidth = screenSize.size.width;
            screenSize.size.width =  screenSize.size.height;
            screenSize.size.height = fWidth;
            
        }
    }
    
    screenSize.origin.x = 0;
    screenSize.origin.y = 0;
    
    //
    [vScreenShotView setFrame:screenSize];

    //init top view
    CGRect frame = screenSize;
    frame.size.height = 45;
    frame.origin.x =0;
    frame.origin.y =0;
    
    [topView setFrame:frame];
    [headerNote setFrame:frame];
    
    frame = btnBackToList.frame;
    frame.size.height = 40;
    frame.size.width = frame.size.height;
    frame.origin.y = (topView.frame.size.height - frame.size.height)/2;
    frame.origin.x = frame.origin.y;
    [btnBackToList setHidden:NO];
    [btnBackToList setFrame:frame];
    [topView addSubview:btnBackToList];
    
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs_click"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_pressed.png"] forState:UIControlStateHighlighted];
        }
        
    }else{
        
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_on_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_on_pressed.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_mute"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_mute_click"] forState:UIControlStateHighlighted];
        }
        
    }
//    frame = btnShowMore.frame;
//    frame.size.height = 40;
//    frame.size.width = frame.size.height;
//    frame.origin.x = topView.frame.size.width - frame.size.width - 10;
//    frame.origin.y = (topView.frame.size.height - frame.size.height)/2;
//    [btnShowMore setFrame:frame];
//    [topView addSubview:btnShowMore];
    
    //
    m_rectFull = screenSize;
    
    [lblPTZNotice setHidden:YES];
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        CGFloat fWidth = screenSize.size.width;
        screenSize.size.width =  screenSize.size.height;
        screenSize.size.height = fWidth;
        
        [imagePlayView setFrame:m_rectFull];
        [nvMediaPlayer setFrame:m_rectFull];
        
        
        [ivImagePlayViewBg setFrame:m_rectFull];
        [imagePlayView addSubview:ivImagePlayViewBg];
        
    }else{
        m_rectNormal = m_rectFull;
        m_rectNormal.size.width = m_rectFull.size.width;
        m_rectNormal.size.height = m_rectNormal.size.width*0.82;
        m_rectNormal.origin.x = 0;
        m_rectNormal.origin.y = 0;
        
        CGRect rect = m_rectNormal;
        rect.origin.y = topView.frame.origin.y +topView.frame.size.height;
        [imagePlayView setFrame:rect];
        
        rect.size.height = m_rectNormal.size.height+0.2;
        rect.size.width = m_rectNormal.size.width+0.2;
        rect.origin.x = (m_rectNormal.size.width - rect.size.width)/2;
        rect.origin.y = (m_rectNormal.size.height - rect.size.height)/2;
        [nvMediaPlayer setFrame:rect];
        
        [ivImagePlayViewBg setFrame:m_rectNormal];
        [imagePlayView addSubview:ivImagePlayViewBg];
       
        rect = lblPTZNotice.frame;
        rect.size.width = nvMediaPlayer.frame.size.width;
        rect.origin.x =(imagePlayView.frame.size.width - rect.size.width)/2;
        rect.origin.y = nvMediaPlayer.frame.origin.y + nvMediaPlayer.frame.size.height;
        [lblPTZNotice setFrame:rect];
        [self.view addSubview:lblPTZNotice];
        [self.view bringSubviewToFront:lblPTZNotice];
        
        if ([_loginParam bPTZ_PRI]) {
            [lblPTZNotice setHidden:NO];
        }
    }
    
    
    
    [nvMediaPlayer removeFromSuperview];
    //
    
    [imagePlayView addSubview:nvMediaPlayer];//
    
    [nvMediaPlayer setContentMode:UIViewContentModeScaleAspectFit];
    [imagePlayView addSubview:nvMediaPlayer];

    //init playbottom View
    
    if (self.interfaceOrientation==UIDeviceOrientationPortrait || self.interfaceOrientation==UIDeviceOrientationPortraitUpsideDown) {
        _PlayBottomView.hidden = NO;
        //_PlayBottomView
        //add by lusongbin
        frame = _PlayBottomView.frame;
        frame.size.height = 50;
        frame.size.width = imagePlayView.frame.size.width;
        frame.origin.x = 0;
        frame.origin.y = 0;
        _PlayBottomView.frame = frame;
        
        CGFloat playbottom_margin = (_PlayBottomView.frame.size.width - _PlayBottomView.frame.size.height * 0.5 * 4) / 5;
        frame = btnSoundEnable.frame;
        frame.size.height = _PlayBottomView.frame.size.height * 0.5;
        frame.size.width =frame.size.height;
        
        frame.origin.x = playbottom_margin;
        frame.origin.y = (_PlayBottomView.frame.size.height - frame.size.height) /2;
        btnSoundEnable.frame = frame;
        
        frame = _btnPreviousCam.frame;
        frame.size.height = _PlayBottomView.frame.size.height * 0.5;
        frame.size.width =frame.size.height;
        frame.origin.x = CGRectGetMaxX(btnSoundEnable.frame) + playbottom_margin;
        frame.origin.y =(_PlayBottomView.frame.size.height - frame.size.height) /2;
        _btnPreviousCam.frame = frame;
        
        
        frame = _btnNextCam.frame;
        frame.size.height = _PlayBottomView.frame.size.height * 0.5;
        frame.size.width =frame.size.height;
        frame.origin.x = CGRectGetMaxX(_btnPreviousCam.frame)+ playbottom_margin;
        frame.origin.y =(_PlayBottomView.frame.size.height - frame.size.height) /2;    //end add by lusongbin
        _btnNextCam.frame = frame;
        
        frame = btnImgQL.frame;
        frame.size.height = _PlayBottomView.frame.size.height * 0.5;
        frame.size.width =_PlayBottomView.frame.size.height;
        frame.origin.x = CGRectGetMaxX(_btnNextCam.frame)+ playbottom_margin;
        frame.origin.y =(_PlayBottomView.frame.size.height - frame.size.height) /2;    //end add by lusongbin
        btnImgQL.frame = frame;
        btnImgQL.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_PlayBottomView addSubview:btnImgQL];
        
        //end add by lusongbin 20160612
        
        [_PlayBottomView addSubview:btnSoundEnable];
        [_PlayBottomView addSubview:btnImgQL];
        
    }else{
        
        _PlayBottomView.hidden = YES;
    
    }
    
    //init bottom view
    CGFloat fBottonHeight=80;
    
    if (self.interfaceOrientation==UIDeviceOrientationPortrait || self.interfaceOrientation==UIDeviceOrientationPortraitUpsideDown) {
        if (fBottonHeight>(m_rectFull.size.height-topView.frame.size.height-m_rectNormal.size.height)) {
            fBottonHeight = (m_rectFull.size.height-topView.frame.size.height-m_rectNormal.size.height);
        }
        //竖屏
        //
        //add by lusongbin 20160615
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_screenshot_normal"] forState:UIControlStateNormal];
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_screenshot_on"] forState:UIControlStateHighlighted];
        
        [btnReverseImage setImage:[UIImage imageNamed:@"btn_rotate_180_normal"] forState:UIControlStateNormal];
        [btnReverseImage setImage:[UIImage imageNamed:@"btn_rotate_180_pressed"] forState:UIControlStateHighlighted];

        [btnMicView setText:NSLocalizedString(@"lblHoldToTalk", @"Hold to talk")];
        
        //end add by lusongbin 20160615
        
        //add by lusongbin
        btnShowMore.hidden = NO;
        _btnShowPTZ.hidden = NO;
        //end add by lusongbin
        
        frame.size.width = m_rectFull.size.width;
        
        frame.size.height = [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(imagePlayView.frame);
        
        frame.origin.x = (m_rectFull.size.width-frame.size.width)/2;
        frame.origin.y = m_rectFull.size.height-frame.size.height;
        [bottomView setFrame:frame];
        
        frame =bottomView.frame;
        frame.origin.x=0;
        frame.origin.y=0;
        
        [ivBottomViewBg setFrame:frame];
        
        ivBottomViewBg.layer.cornerRadius = 0;
        ivBottomViewBg.layer.borderWidth = 0;
        ivBottomViewBg.layer.borderColor=[UIColor clearColor].CGColor;
        
        CGFloat btnWidth = bottomView.frame.size.height * 0.35;
        if([UIScreen mainScreen].bounds.size.height < 568){
            btnWidth =bottomView.frame.size.height * 0.3;
        }
        CGFloat btnMargin = bottomView.frame.size.height * 0.05;
        //显示预置位
        frame = btnShowMore.frame;
        frame.size.width = btnWidth;
        frame.size.height = btnWidth;
        frame.origin.x = btnMargin;
        frame.origin.y = CGRectGetMaxY(_PlayBottomView.frame)+ btnMargin;
        btnShowMore.frame = frame;
        
        //图片翻转
        frame = btnReverseImage.frame;
        frame.size.width = btnWidth;
        frame.size.height = btnWidth;
        frame.origin.y = bottomView.frame.size.height - btnMargin - btnWidth;
        frame.origin.x = btnMargin;
        [btnReverseImage setFrame:frame];
        
        //云台
        frame = _btnShowPTZ.frame;
        frame.size.width = btnWidth;
        frame.size.height = btnWidth;
        frame.origin.y = CGRectGetMaxY(_PlayBottomView.frame) + btnMargin;
        frame.origin.x = bottomView.frame.size.width / 2 - btnWidth / 2;
        [_btnShowPTZ setFrame:frame];
        
        //对讲按钮
        frame = btnMicView.frame;
        frame.size.width = btnWidth;
        frame.size.height = btnWidth;
        frame.origin.y = bottomView.frame.size.height -btnMargin - btnWidth;
        frame.origin.x = bottomView.frame.size.width / 2 - btnWidth / 2;
        [btnMicView setFrame:frame];
        [btnMicView setImage:[UIImage imageNamed:@"mic_normal.png"]];
        
        //截图
        frame = btnScreenShot.frame;
        frame.size.width = btnWidth;
        frame.size.height = btnWidth;
        frame.origin.y = CGRectGetMaxY(_PlayBottomView.frame)+ btnMargin;
        frame.origin.x = bottomView.frame.size.width - frame.size.width - btnMargin;
        [btnScreenShot setFrame:frame];
        
        //录像
        frame = _btnStartRecord.frame;
        frame.size.width = btnWidth;
        frame.size.height = btnWidth;
        frame.origin.y = bottomView.frame.size.height - btnMargin - btnWidth;
        frame.origin.x = bottomView.frame.size.width - frame.size.width - btnMargin;
        [_btnStartRecord setFrame:frame];

        
        [btnShowMore setTitle:NSLocalizedString(@"btnPosition", @"预置位") forState:UIControlStateNormal];
        [btnShowMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btnReverseImage setTitle:NSLocalizedString(@"btnRotate", @"旋转") forState:UIControlStateNormal];
        [btnReverseImage setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnShowPTZ setTitle:NSLocalizedString(@"btnHolder", @"云台") forState:UIControlStateNormal];
        [_btnShowPTZ setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btnScreenShot setTitle:NSLocalizedString(@"btnScreenshot", @"截图") forState:UIControlStateNormal];
        [btnScreenShot setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnStartRecord setTitle:NSLocalizedString(@"btnRecord", @"录像") forState:UIControlStateNormal];
        [_btnStartRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btnMicView setTitleColor:[UIColor lightGrayColor]];
        
        
        [btnMicView setHidden:NO];
        [bottomView addSubview:_btnShowPTZ];
        [bottomView addSubview:btnReverseImage];
        [bottomView addSubview:btnMicView];
        [bottomView addSubview:btnScreenShot];
        [bottomView addSubview:btnShowMore];

    }else{
        //横屏
        
        [btnShowMore setTitle:nil forState:UIControlStateNormal];
        [btnReverseImage setTitle:nil forState:UIControlStateNormal];
        [_btnShowPTZ setTitle:nil forState:UIControlStateNormal];
        [btnScreenShot setTitle:nil forState:UIControlStateNormal];
        [_btnStartRecord setTitle:nil forState:UIControlStateNormal];
        //add by lusongbin 20160615
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_screenshot_cs_normal"] forState:UIControlStateNormal];
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_screenshot_cs_on"] forState:UIControlStateHighlighted];
        
        [btnReverseImage setImage:[UIImage imageNamed:@"btn_rotate_180_cs_normal"] forState:UIControlStateNormal];
        [btnReverseImage setImage:[UIImage imageNamed:@"btn_rotate_180_cs_pressed"] forState:UIControlStateHighlighted];
        
        //20160607
        btnShowMore.hidden = YES;
        _btnShowPTZ.hidden = YES;
        [btnMicView setText:nil];
        //end add 20160607
        frame.size.width = m_rectFull.size.width;
        
        fBottonHeight = 60;
        
        frame.size.height = fBottonHeight;
        
        frame.origin.x = 0;
        frame.origin.y = m_rectFull.size.height-frame.size.height;
        [bottomView setFrame:frame];
        
        frame =bottomView.frame;
        frame.origin.x=0;
        frame.origin.y=0;
#pragma mark - UpsideDown  ivBottomViewBg
        [ivBottomViewBg setFrame:frame];
//        
//        ivBottomViewBg.layer.cornerRadius = 5;
//        ivBottomViewBg.layer.borderWidth = 0.5;
//        ivBottomViewBg.layer.borderColor=[UIColor whiteColor].CGColor;
        
        //add by lusongbin
        CGFloat btnWidth = bottomView.frame.size.height;
        CGFloat bottomview_H = bottomView.frame.size.height;
        CGFloat btnMargin = btnWidth / 3;
        CGFloat midleft = m_rectFull.size.width / 2;
        CGFloat midright = m_rectFull.size.width / 2 + btnWidth /2;

        //显示云台
        frame = _btnShowPTZ.frame;
        frame.size.width = btnWidth;
        frame.size.height = btnWidth;
        frame.origin.x = midleft - btnWidth * 2 - btnMargin * 2;
        frame.origin.y = 0;
        _btnShowPTZ.frame = frame;
        
        //对讲按钮
        frame = btnMicView.frame;
        frame.size.width = btnWidth;
        frame.size.height = btnWidth;
        frame.origin.x = midleft - btnMargin /2 - btnWidth;
        frame.origin.y = (bottomview_H - frame.size.height * 0.8) / 2;
        [btnMicView setFrame:frame];
        [btnMicView setImage:[UIImage imageNamed:@"mic_cs_normal.png"]];
        
        //图片翻转
        frame = btnReverseImage.frame;
        frame.size.width = btnWidth;
        frame.size.height = btnWidth;
        frame.origin.y = (bottomview_H - frame.size.height * 0.8) / 2;
        frame.origin.x = CGRectGetMaxX(btnMicView.frame) + btnMargin ;
        [btnReverseImage setFrame:frame];
        
        //截图
        frame = btnScreenShot.frame;
        frame.size.width = btnWidth;
        frame.size.height = btnWidth;
        frame.origin.y = (bottomview_H - frame.size.height * 0.8) / 2;
        frame.origin.x =btnMicView.frame.origin.x - btnMargin - btnWidth;
        [btnScreenShot setFrame:frame];
        
        //声音
        frame = btnSoundEnable.frame;
        frame.size.width = btnWidth*0.8;
        frame.size.height = btnWidth*0.8;
        frame.origin.y = (bottomview_H - frame.size.height) / 2;
        frame.origin.x = CGRectGetMaxX(btnReverseImage.frame) + btnMargin;
        [btnSoundEnable setFrame:frame];
        CGFloat btnImgEdge = btnSoundEnable.frame.size.height * 0.2;
        
        [btnMicView setHidden:NO];
        [bottomView addSubview:_btnShowPTZ];
        [bottomView addSubview:btnSoundEnable];
        [bottomView addSubview:btnReverseImage];
        [bottomView addSubview:btnMicView];
        [bottomView addSubview:btnScreenShot];
        //end add by lusongbin
    }
    
    [vPTZXPanel setHidden:YES];
    
//    NSLog(@"_loginParam bPTZX_PRI = %d", [_loginParam bPTZX_PRI]);//add for test
#pragma mark - 显示预置位设置按钮
//    if ([_loginParam bPTZX_PRI]) {
//        
//        [btnShowMore setHidden:NO];
//    }else{
//        [btnShowMore setHidden:YES];AVAuthorizationStatus
//    }
    
    //
    [self topMoreStatChange: YES];
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
#pragma mark - LandscapeLeft ivBottomViewBg  blackColor
        
        [ivTopViewBg setAlpha:0.5];
        [ivBottomViewBg setAlpha:0.5];
        ivBottomViewBg.layer.cornerRadius = 2;
        [ivBottomViewBg setBackgroundColor:[UIColor blackColor]];
        [ivBottomViewBg setImage:nil];
        
        //set site
        CGRect qlFrame = vQLPanel.frame;
        qlFrame.size.height = 80;
        qlFrame.size.width = 90;
        qlFrame.origin.x=m_rectFull.size.width -qlFrame.size.width-5;
        qlFrame.origin.y=(m_rectFull.size.height -qlFrame.size.height)/2;
        [vQLPanel setFrame:qlFrame];
        
        qlFrame = vQLPanel.frame;
        qlFrame.origin.x = 0;
        qlFrame.origin.y = 0;
        [ivQLPanelBg setFrame:qlFrame];
        [ivQLPanelBg.layer setCornerRadius:2];
        [vQLPanel addSubview:ivQLPanelBg];
        
        qlFrame = vQLPanel.frame;
        qlFrame.size.height = 1;
        qlFrame.size.width =  vQLPanel.frame.size.width*0.85;
        qlFrame.origin.x = (vQLPanel.frame.size.width-qlFrame.size.width)/2;
        qlFrame.origin.y = (vQLPanel.frame.size.height-qlFrame.size.height)/2;
        [ivQLPanelSpiter setFrame:qlFrame];
        
        qlFrame = btnQualityHD.frame;
        qlFrame.size.width = vQLPanel.frame.size.width * 0.9;
        qlFrame.size.height = vQLPanel.frame.size.height/2*0.95;
        qlFrame.origin.x = (vQLPanel.frame.size.width - qlFrame.size.width)/2;
        qlFrame.origin.y = (vQLPanel.frame.size.height/2-btnQualityHD.frame.size.height)/2;
        [btnQualityHD setFrame:qlFrame];
        
        qlFrame = btnQualityHD.frame;
        qlFrame.origin.y =vQLPanel.frame.size.height/2+qlFrame.origin.y;
        [btnQualitySmooth setFrame:qlFrame];
        [vQLPanel addSubview:btnQualityHD];
        [vQLPanel addSubview:btnQualitySmooth];
        [vQLPanel addSubview:ivQLPanelSpiter];
        [self.view addSubview:vQLPanel];
        //
        
        if (nStreamType==STREAM_TYPE_HD) {
            
            
            [btnQualityHD setTitleColor:[UIColor colorWithRed:0.246 green:0.467 blue:0.894 alpha:1]  forState:UIControlStateNormal];
            
            [btnQualitySmooth setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
            
            
        }else if (nStreamType==STREAM_TYPE_SMOOTH){
            
            [btnQualityHD setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [btnQualitySmooth setTitleColor:[UIColor colorWithRed:0.246 green:0.467 blue:0.894 alpha:1] forState:UIControlStateNormal];
            
        }
        
//        [btnBack setFrame:btnScreenShot.frame];
//        [btnScreenShot setFrame:btnImgQL.frame];
//        [btnImgQL setHidden:YES];
        
        [btnBack setHidden:YES];
        [vQLPanel setHidden:YES];
        
        nToolViewShowTickCount=0;
        [bottomView setHidden:YES];
        [topView setHidden:YES];
        
        //ptz panel
        [self showLanPTZXButton:NO];
        

    }else{
        
        if (nStreamType==STREAM_TYPE_HD) {
            [btnImgQL setTitle:NSLocalizedString(@"lblHD", @"HD") forState:UIControlStateNormal];
            
            
        }else if (nStreamType==STREAM_TYPE_SMOOTH){
            [btnImgQL setTitle:NSLocalizedString(@"lblNormal", @"SD") forState:UIControlStateNormal];
            
        }
        
        [bottomView setHidden:NO];
        [self showLanPTZXButton:NO];
        [btnBack setHidden:YES];
        [btnImgQL setHidden:NO];
        [vQLPanel setHidden:YES];
        //ptz panel
        [vPTZPanel setHidden:NO];
        
#pragma mark - LandscapeLeft ivBottomViewBg  whiteColor

        [ivTopViewBg setAlpha:1.0];
        [ivBottomViewBg setAlpha:1.0];
        [ivBottomViewBg setBackgroundColor:[UIColor whiteColor]];
//        [ivBottomViewBg setImage:[UIImage imageNamed:@"play_bottom_bg.png"]];
        ivBottomViewBg.layer.cornerRadius = 0;
        
        [topView setHidden:NO];
        
//        frame = vPTZPanel.frame;
//        frame.size.height = vPTZPanel.frame.size.height/2;
//        if (frame.size.height>60) {
//            frame.size.height=60;
//        }
//        
//        frame.size.width =frame.size.height;
        
    }
    
    //intit vPTZPanel
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        
        [vPTZPanel setHidden:YES];

        
        frame = vPTZPanel.frame;
        frame.size.height = frame.size.width = imagePlayView.frame.size.height *0.6;
        frame.origin.x = (imagePlayView.frame.size.width - frame.size.width) * 0.5;
        frame.origin.y = imagePlayView.frame.size.height - frame.size.height - 60;        //        frame.size.height = bottomView.frame.origin.y - frame.origin.y;
        [vPTZPanel setFrame:frame];
        
        
    }else{
        
        isShowPanel = YES;
        vPTZPanel.hidden = isShowPanel;
        frame = vPTZPanel.frame;
        frame.size.height = bottomView.frame.size.height;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.width = bottomView.frame.size.width;
        [vPTZPanel setFrame:frame];
        vPTZPanel.alpha = 0.8;
        
    }
    
    CGFloat panelArrow_H = 60;
    CGFloat panelMargin = 50;
    
    //ptz 上
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        
        frame = ivPTZUp.frame;
        frame.size.width = frame.size.height = panelArrow_H;
        frame.origin.x = (vPTZPanel.frame.size.width - frame.size.width)/2;
        frame.origin.y = panelMargin * 0.5;
        ivPTZUp.frame = frame;
    }else{
        frame = ivPTZUp.frame;
        frame.size.width = frame.size.height = panelArrow_H;
        frame.origin.x = (vPTZPanel.frame.size.width - frame.size.width)/2;
        frame.origin.y = panelMargin;
        ivPTZUp.frame = frame;
    }
    
    //PTZ 下
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        
        frame = ivPTZDown.frame;
        frame.size.width = frame.size.height = panelArrow_H;
        frame.origin.x = (vPTZPanel.frame.size.width - frame.size.width)/2;
        frame.origin.y = vPTZPanel.frame.size.height - frame.size.height - panelMargin * 0.5;
        ivPTZDown.frame = frame;
    }else{
        frame = ivPTZDown.frame;
        frame.size.width = frame.size.height = panelArrow_H;
        frame.origin.x = (vPTZPanel.frame.size.width - frame.size.width)/2;
        frame.origin.y = vPTZPanel.frame.size.height - frame.size.height - panelMargin;
        ivPTZDown.frame = frame;
    }
    
    //PTZ 左
    frame = ivPTZLeft.frame;
    frame.size.width = frame.size.height = panelArrow_H;
    frame.origin.x = panelMargin;
    frame.origin.y = (vPTZPanel.frame.size.height - frame.size.width)/2;
    ivPTZLeft.frame = frame;
    
    //PTZ 右
    frame = ivPTZRight.frame;
    frame.size.width = frame.size.height = panelArrow_H;
    frame.origin.x = vPTZPanel.frame.size.width - frame.size.width - panelMargin;
    frame.origin.y = (vPTZPanel.frame.size.height - frame.size.height)/2;
    ivPTZRight.frame = frame;
    
    
    frame = _btnClosePtzPanel.frame;
    frame.size.width = 50;
    frame.size.height = 50;
    frame.origin.x = vPTZPanel.frame.size.width - frame.size.width;
    frame.origin.y = 0;
    _btnClosePtzPanel.frame = frame;
    [_btnClosePtzPanel setTitle:NSLocalizedString(@"btnClose", nil) forState:UIControlStateNormal];
    //
    [self.view addSubview:imagePlayView];
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    [self.view addSubview:lblCanSpeakNotice];
    [self.view addSubview:vQLPanel];
    [self.view addSubview:vPTZXLanBtnContanner];
    [bottomView addSubview:_PlayBottomView];
    [bottomView addSubview:vPTZPanel];

    
    if (_loginParam) {
//        if ([_loginParam strName] && [[_loginParam strName] length]>0) {
//            
//            [headerNote setText:[NSString stringWithFormat:@"%@", [_loginParam strName]]];
//        }else{
//            
            [headerNote setText:[NSString stringWithFormat:@"%i", [_loginParam nDevID]]];
            self.navigationController.title =[NSString stringWithFormat:@"%i", [_loginParam nDevID]];
//        }
        
    }else{
        
        [headerNote setText:nil];
    }
    
    
    [btnQualityHD setTitle:NSLocalizedString(@"lblHD", @"HD") forState:UIControlStateNormal];
    [btnQualitySmooth setTitle:NSLocalizedString(@"lblNormal", @"SD") forState:UIControlStateNormal];
    
    [lblPTZNotice setText:NSLocalizedString(@"lblPTZCtrlNotice", @"Slide to adjust the direction of yhe lens")];
    [lblCanSpeakNotice setText:NSLocalizedString(@"lblCanSpeak", @"You can start talking")];
//    [btnMicView setText:NSLocalizedString(@"lblHoldToTalk", @"Hold to talk")];
    
    [lblPTZXTitle setText:NSLocalizedString(@"lblPTZXTitle", @"Preset position setting and position")];
    
    [lblCanSpeakNotice setHidden:YES];
    
    [btnPTZXPanelClose setTitle:NSLocalizedString(@"btnCancel", @"Cancel")forState:UIControlStateNormal];
  
    
    [location1 setTitle:[NSString stringWithFormat:@"%@1",NSLocalizedString(@"lblLocation", @"Location")]];
    [location1 setID:1];
    [location2 setTitle:[NSString stringWithFormat:@"%@2",NSLocalizedString(@"lblLocation", @"Location")]];
    [location2 setID:2];
    [location3 setTitle:[NSString stringWithFormat:@"%@3",NSLocalizedString(@"lblLocation", @"Location")]];
    [location3 setID:3];
    [location4 setTitle:[NSString stringWithFormat:@"%@4",NSLocalizedString(@"lblLocation", @"Location")]];
    [location4 setID:4];
    [location5 setTitle:[NSString stringWithFormat:@"%@5",NSLocalizedString(@"lblLocation", @"Location")]];
    [location5 setID:5];
    [location6 setTitle:[NSString stringWithFormat:@"%@6",NSLocalizedString(@"lblLocation", @"Location")]];
    [location6 setID:6];
    [location7 setTitle:[NSString stringWithFormat:@"%@7",NSLocalizedString(@"lblLocation", @"Location")]];
    [location7 setID:7];
    [location8 setTitle:[NSString stringWithFormat:@"%@8",NSLocalizedString(@"lblLocation", @"Location")]];
    [location8 setID:8];
    [location9 setTitle:[NSString stringWithFormat:@"%@9",NSLocalizedString(@"lblLocation", @"Location")]];
    [location9 setID:9];
    
    [btnPTZXPanelClose setTitle:NSLocalizedString(@"btnCancel", @"Cancel")forState:UIControlStateNormal];
    btnPTZXPanelClose.hidden = YES;

    [self setPlayViewOrentation];
}

-(void)doZoom{
    
}

-(void)SetbtnEnable:(BOOL)enable{
    btnMicView.userInteractionEnabled = enable;
    btnReverseImage.enabled = enable;
    btnShowMore.enabled = enable;
    _btnShowPTZ.enabled = enable;
    btnScreenShot.enabled = enable;
    btnImgQL.enabled = enable;
}
    
#pragma mark - 实时录像
//实时录像
- (IBAction)onRecordingClick:(id)sender {
    if (!strurl) {
        strurl = [[NSString alloc]init];
    }
    if (isRecording) {
        
        [self SetbtnEnable:YES];
        
        [_btnStartRecord setImage:[UIImage imageNamed:@"btn_recording.png"] forState:UIControlStateNormal];
        [_btnStartRecord setTitle:NSLocalizedString(@"btnRecord", @"录像") forState:UIControlStateNormal];
        [nvMediaPlayer StopRecord];
        isRecording = NO;
        
        NSURL *url = [NSURL fileURLWithPath:strurl];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSString *albumName = NSLocalizedString(@"appName", @"app's name");
        
        [library saveVideo:url toAlbum:albumName completion:^(NSURL *assetURL, NSError *error) {
            NSLog(@"保存成功");
            if (error == nil) {
                
                if (HUD) {
                    [HUD hide:YES];
                }
                
                dispatch_after(1.f, dispatch_get_main_queue(), ^{
                    iToast *toast = [iToast makeToast:NSLocalizedString(@"lblsavesuccess", @"录像已经保存到相册")];
                    [toast setToastPosition:kToastPositionCenter];
                    [toast setToastDuration:kToastDurationShort];
                    [toast show];
                    [_btnStartRecord setEnabled:YES];
                });
                
            } else {
                
                NSLog(@"err = %@", error);
            }
        } failure:^(NSError *error) {
            NSLog(@"err = %@", error);
            
            NSLog(@"保存失败");
        }];
        
    }else{
        

        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.calendar = [[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian]autorelease];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter release];
        
        NSString *filePath=[NSString stringWithFormat:@"%@(%i).mp4",currentDateStr, [_loginParam nDevID]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *strMP4FilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filePath]];   // 保存文件的名称
        
        strurl = strMP4FilePath;
        
        [nvMediaPlayer StartRecord: strMP4FilePath];

        isRecording = YES;

        if (isRecording) {
            [_btnStartRecord setImage:[UIImage imageNamed:@"btn_recording_click.png"] forState:UIControlStateNormal];
            [_btnStartRecord setTitle:NSLocalizedString(@"btnRecording", @"录像中") forState:UIControlStateNormal];
        }else{
            [_btnStartRecord setImage:[UIImage imageNamed:@"btn_recording.png"] forState:UIControlStateNormal];
        }
        [self SetbtnEnable:NO];

    
    }

}


//显示云台
- (IBAction)showPTZPanel:(id)sender {
    
    if (![_loginParam bPTZ_PRI]) {//前端设备不支持
        
        iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeDeviceNoPTZ", @"Device does not support ptz")];
        [toast retain];
        [toast setToastPosition:kToastPositionCenter];
        [toast setToastDuration:kToastDurationShort];
        [toast show];
        [toast release];
        return;
    }else{

    isShowPanel = !isShowPanel;
    vPTZPanel.hidden = NO;
    }
}
-(BOOL)ptzxSetDirectID:(int)nPTZXID action:(int)nAction{
    
    return YES;
}

-(BOOL)ptzxSetFromMRID:(int)nPTZXID action:(int)nAction{
    return YES;
}
//关闭云台
- (IBAction)SetHiddenPTZPanel:(id)sender {
    vPTZPanel.hidden = YES;

}


-(void) animationDidStop{

}

-(void) StopPlay:(BOOL)isShotCut{
    
    if (isShotCut && [nvMediaPlayer isShotcutEnable]) {
        if ([_loginParam nAddType]!=ADD_TYPE_DEMO) {//modify by luo 20141106
            [self SavePlayScreenShot];
        }
        
    }
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        [nvMediaPlayer setFrame:m_rectFull];
        
    }else{
        
        [nvMediaPlayer setFrame:m_rectNormal];
    }
    
    [nvMediaPlayer StopPlay];
    isPlaying=NO;
    nPTZCtrlThreadID++;
    isRecording=NO;

}

//ok
- (void)SavePlayScreenShot {
}
-(void) StopNotice{
    isPlaying=NO;
    
}
//ok
-(void) StartPlay:(int) nChn area:(int) nPlayArea{
    [self startPtzCtrlThread];
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        CGRect frame =m_rectFull;
        frame.size.width = frame.size.width+0.2;
        frame.size.height = frame.size.height+0.2;
        frame.origin.x = (m_rectFull.size.width - frame.size.width)/2;
        frame.origin.y = (m_rectFull.size.height - frame.size.height)/2;
        [nvMediaPlayer setFrame:frame];
        
    }else{
        [nvMediaPlayer setFrame:m_rectNormal];
        
    }
    m_bSoundEnable = YES;
    
    [nvMediaPlayer StartPlay:0 streamType:nStreamType audio:  m_bSoundEnable loginHandel:_loginParam];

    isPlaying=YES;
}
//ok
-(void) onPlayAreaClick{
    
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        nToolViewShowTickCount=10;
        if (isAudioRecording) {
            return;
        }
        
        [topView setHidden:YES];
        if ([bottomView isHidden]) {
            
            [self showLanPTZXButton:[_loginParam bPTZX_PRI]];
            
            [bottomView setHidden:NO];
            [vQLPanel setHidden:NO];
            
        }else{
            [self showLanPTZXButton:NO];
            [self qlStatChange:YES];
            [self topMoreStatChange: YES];
            
            
            [bottomView setHidden:YES];
            [vQLPanel setHidden:YES];
            
            [lblCanSpeakNotice setHidden:YES];
            
        }
        
    }
    
}
//手势判断

-(void)handelTap:(UITapGestureRecognizer *)recognizer{
    //
    
    [self onPlayAreaClick];
}
-(void)handelPinch:(UIPinchGestureRecognizer *)recognizer{
    
    [nvMediaPlayer scale:[(UIPinchGestureRecognizer*)recognizer scale]];
    //
    
    
}
-(void)handelSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    
}
-(void)handelPan:(UIPanGestureRecognizer *)recognizer{
    
    if(![_loginParam bPTZ_PRI] ){
        return;
    }
    
    
    if (isPTZLeftPressed||isPTZRightPressed||isPTZUPPressed||isPTZDownPressed) {//以按钮按下优先
        return;
    }
    
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    if (recognizer.state ==UIGestureRecognizerStateBegan)
        
    {
        //add by luo 20150516
        if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
            
            nToolViewShowTickCount=10;
            if (isAudioRecording) {
                return;
            }
            
            [topView setHidden:YES];
            if (![bottomView isHidden]) {
                
                [self qlStatChange:YES];
                [self topMoreStatChange: YES];
                
                [self showLanPTZXButton:NO];
                [bottomView setHidden:YES];
                [vQLPanel setHidden:YES];
                
                [lblCanSpeakNotice setHidden:YES];
                
            }
            
        }
        
        //end add by luo 20150516
        
        direction = kCameraMoveDirectionNone;
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone)
        
    {
        
        direction = [self determineCameraDirectionIfNeeded:translation];
        
        // ok, now initiate movement in the direction indicated by the user's gesture
        
        
    }
    
    else if (recognizer.state ==UIGestureRecognizerStateEnded)
        
    {
        // now tell the camera to stop
        nStep = [self getStep:translation];
        
        switch (direction) {
                
            case kCameraMoveDirectionDown:
                
                isPTZLeft=NO;
                isPTZRight=NO;
                isPTZUP=NO;
                isPTZDown=YES;
                
                [nvMediaPlayer SetPTZActionLeft:isPTZLeft Right:isPTZRight Up:isPTZUP Down:isPTZDown step:nStep];
                break;
                
            case kCameraMoveDirectionUp:
                
                isPTZLeft=NO;
                isPTZRight=NO;
                isPTZUP=YES;
                isPTZDown=NO;
                [nvMediaPlayer SetPTZActionLeft:isPTZLeft Right:isPTZRight Up:isPTZUP Down:isPTZDown step:nStep];
                break;
                
            case kCameraMoveDirectionRight:
                
                isPTZLeft=NO;
                isPTZRight=YES;
                isPTZUP=NO;
                isPTZDown=NO;
                
                [nvMediaPlayer SetPTZActionLeft:isPTZLeft Right:isPTZRight Up:isPTZUP Down:isPTZDown step:nStep];
                break;
                
            case kCameraMoveDirectionLeft:
                
                isPTZLeft=YES;
                isPTZRight=NO;
                isPTZUP=NO;
                isPTZDown=NO;
                [nvMediaPlayer SetPTZActionLeft:isPTZLeft Right:isPTZRight Up:isPTZUP Down:isPTZDown step:nStep];
                break;
               
            default:
                
                break;
                
        }
        
    }
}

// This method will determine whether the direction of the user's swipe
-(int)getStep:(CGPoint)translation{
    
    
    int nDistStep=0;
    double fDeltaX = fabs(translation.x);
    double fDeltaY = fabs(translation.y);
    
    
    if (fDeltaX>fDeltaY) {
        if (fDeltaX>fStepDistance) {
            nDistStep=fDeltaX/fStepDistance;
        }
    }else{
        
        if (fDeltaY>fStepDistance) {
            nDistStep=fDeltaY/fStepDistance;
        }
    }
    
    return nDistStep;
}

- (CameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation{
    
    nStep=0;
    ///
    CameraMoveDirection cDirection=kCameraMoveDirectionNone;
    double fDeltaX = fabs(translation.x);
    double fDeltaY = fabs(translation.y);
    
    ///单方向
    if (fDeltaX>fDeltaY) {
        if (fDeltaX > gestureMinimumTranslation) {
            
            
            if (translation.x >0.0){
                cDirection = kCameraMoveDirectionRight;
            } else{
                cDirection = kCameraMoveDirectionLeft;
            }
        }
    }else{
        if (fDeltaY > gestureMinimumTranslation) {
            
            
            if (translation.y >0.0){
                cDirection = kCameraMoveDirectionDown;
            }else{
                cDirection = kCameraMoveDirectionUp;
            }
            
            
        }
        
    }
    
    return cDirection;
    
}
-(void) addGestureRecognizer{
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap:)];
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handelPinch:)];
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handelSwipe:)];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    
    [nvMediaPlayer addGestureRecognizer:tapGestureRecognizer];
    [nvMediaPlayer addGestureRecognizer:pinchGestureRecognizer];
    [nvMediaPlayer addGestureRecognizer:panGestureRecognizer];
    
    [tapGestureRecognizer autorelease];
    [pinchGestureRecognizer autorelease];
    [swipeGestureRecognizer autorelease];
    [panGestureRecognizer autorelease];
    
    
    GestureRecognizer * tapInterceptor = [[[GestureRecognizer alloc] init] autorelease];
    
    tapInterceptor.touchesBeganCallback =  ^(NSSet * touches, UIEvent * event) {
        [btnMicView setImage:[UIImage imageNamed:@"mic_on.png"]];
        isAudioRecording=YES;
        
        [lblCanSpeakNotice setHidden:NO];
        
        
        [nvMediaPlayer startSpeak];
        
        CGRect frame = lblCanSpeakNotice.frame;
        frame.size.height = 40;
        frame.size.width = imagePlayView.frame.size.width;
        frame.origin.y =imagePlayView.frame.origin.y +(imagePlayView.frame.size.height-frame.size.height)/2;
        frame.origin.x =(imagePlayView.frame.size.width-frame.size.width)/2;
        [lblCanSpeakNotice setFrame:frame];
        
        [vQLPanel setHidden:YES];
        
        [btnSoundEnable setEnabled:NO];
        [btnReverseImage setEnabled:NO];
        [btnScreenShot setEnabled:NO];
        [btnImgQL setEnabled:NO];
        [btnBackToList setEnabled:NO];
        [btnShowMore setEnabled:NO];
        [_btnStartRecord setEnabled:NO];
        [_btnShowPTZ setEnabled:NO];
        
        [ivPTZRight setUserInteractionEnabled:NO];
        [ivPTZLeft setUserInteractionEnabled:NO];
        [ivPTZUp setUserInteractionEnabled:NO];
        [ivPTZDown setUserInteractionEnabled:NO];
        
    };
    
    tapInterceptor.touchesEndedCallback =  ^(NSSet * touches, UIEvent * event) {
        isAudioRecording=NO;
        
        [NSThread sleepForTimeInterval:0.400];
        [nvMediaPlayer stopSpeak];
        [lblCanSpeakNotice setHidden:YES];
        
        if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
            
            [vQLPanel setHidden:NO];
            
            [btnMicView setImage:[UIImage imageNamed:@"mic_cs_normal.png"]];

        }else{
            
            [btnMicView setImage:[UIImage imageNamed:@"mic_normal.png"]];

        }
        
        [btnSoundEnable setEnabled:YES];
        [btnReverseImage setEnabled:YES];
        [btnScreenShot setEnabled:YES];
        [btnImgQL setEnabled:YES];
        [btnBackToList setEnabled:YES];
        
        [btnShowMore setEnabled:YES];
        [_btnStartRecord setEnabled:YES];
        [_btnShowPTZ setEnabled:YES];
        
        [ivPTZRight setUserInteractionEnabled:YES];
        [ivPTZLeft setUserInteractionEnabled:YES];
        [ivPTZUp setUserInteractionEnabled:YES];
        [ivPTZDown setUserInteractionEnabled:YES];
        
    };
    
    
    tapInterceptor.touchesMovedCallback =  ^(NSSet * touches, UIEvent * event) {
        [btnMicView setImage:[UIImage imageNamed:@"mic_on.png"]];
        isAudioRecording=YES;
        
        [btnSoundEnable setEnabled:NO];
        [btnReverseImage setEnabled:NO];
        [btnScreenShot setEnabled:NO];
        [btnImgQL setEnabled:NO];
        [btnBackToList setEnabled:NO];
        [btnShowMore setEnabled:NO];
        [_btnStartRecord setEnabled:NO];
        [_btnShowPTZ setEnabled:NO];
        
        [ivPTZRight setUserInteractionEnabled:NO];
        [ivPTZLeft setUserInteractionEnabled:NO];
        [ivPTZUp setUserInteractionEnabled:NO];
        [ivPTZDown setUserInteractionEnabled:NO];
        
        [vQLPanel setHidden:YES];
        [lblCanSpeakNotice setHidden:NO];
        
        if (![nvMediaPlayer isSpeaking]) {
            [nvMediaPlayer startSpeak];
        }
        
        
    };
    
    [btnMicView setUserInteractionEnabled: YES];
    [btnMicView addGestureRecognizer:tapInterceptor];
    
    GestureRecognizer * tapInterceptor2 = [[[GestureRecognizer alloc] init] autorelease];
    
    tapInterceptor2.touchesBeganCallback =  ^(NSSet * touches, UIEvent * event) {
        
        
        [self topMoreStatChange: YES];
        [self qlStatChange:YES];
    };
    
    [imagePlayView addGestureRecognizer:tapInterceptor2];
    
    
    GestureRecognizer * tapInterceptor3 = [[[GestureRecognizer alloc] init] autorelease];
    
    tapInterceptor3.touchesBeganCallback =  ^(NSSet * touches, UIEvent * event) {
        [self onHidePTZLocationSettingView:nil];
    };
    [ivPTZXBG setUserInteractionEnabled:YES];
    [ivPTZXBG addGestureRecognizer:tapInterceptor3];
    
    
    [self addPTZGestureRecognizer];
    
    
}

-(void) addPTZGestureRecognizer{
    
    
    GestureRecognizer * tapInterceptorL = [[[GestureRecognizer alloc] init] autorelease];
    
    tapInterceptorL.touchesBeganCallback =  ^(NSSet * touches, UIEvent * event) {
        
        if (![_loginParam bPTZ_PRI]) {//前端设备不支持
            
            [ivPTZLeft setUserInteractionEnabled:NO];
            [ivPTZRight setUserInteractionEnabled:NO];
            [ivPTZUp setUserInteractionEnabled:NO];
            [ivPTZDown setUserInteractionEnabled:NO];
            
            iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeDeviceNoPTZ", @"Device does not support ptz")];
            [toast retain];
            [toast setToastPosition:kToastPositionCenter];
            [toast setToastDuration:kToastDurationShort];
            [toast show];
            [toast release];
            return;
        }
        isPTZLeftPressed = YES;
        [ivPTZLeft setImage:[UIImage imageNamed:@"ptz_left_on.png"]];
    };
    
    tapInterceptorL.touchesEndedCallback =  ^(NSSet * touches, UIEvent * event) {
        isPTZLeftPressed = NO;
        [ivPTZLeft setImage:[UIImage imageNamed:@"ptz_left_normal.png"]];
    };
    
    tapInterceptorL.touchesMovedCallback =  ^(NSSet * touches, UIEvent * event) {
        isPTZLeftPressed = YES;
        [ivPTZLeft setImage:[UIImage imageNamed:@"ptz_left_on.png"]];
        
    };
    
    [ivPTZLeft setUserInteractionEnabled: YES];
    [ivPTZLeft addGestureRecognizer:tapInterceptorL];
    
    GestureRecognizer * tapInterceptorR = [[[GestureRecognizer alloc] init] autorelease];
    
    tapInterceptorR.touchesBeganCallback =  ^(NSSet * touches, UIEvent * event) {
        
        if (![_loginParam bPTZ_PRI]) {//前端设备不支持
            
            [ivPTZLeft setUserInteractionEnabled:NO];
            [ivPTZRight setUserInteractionEnabled:NO];
            [ivPTZUp setUserInteractionEnabled:NO];
            [ivPTZDown setUserInteractionEnabled:NO];
            
            iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeDeviceNoPTZ", @"Device does not support ptz")];
            [toast retain];
            [toast setToastPosition:kToastPositionCenter];
            [toast setToastDuration:kToastDurationShort];
            [toast show];
            [toast release];
            return;
        }
        
        isPTZRightPressed = YES;
        [ivPTZRight setImage:[UIImage imageNamed:@"ptz_right_on.png"]];
        
    };
    
    tapInterceptorR.touchesEndedCallback =  ^(NSSet * touches, UIEvent * event) {
        isPTZRightPressed = NO;
        [ivPTZRight setImage:[UIImage imageNamed:@"ptz_right_normal.png"]];
    };
    
    tapInterceptorR.touchesMovedCallback =  ^(NSSet * touches, UIEvent * event) {
        isPTZRightPressed = YES;
        [ivPTZRight setImage:[UIImage imageNamed:@"ptz_right_on.png"]];
        
    };
    
    [ivPTZRight setUserInteractionEnabled: YES];
    [ivPTZRight addGestureRecognizer:tapInterceptorR];
    
    GestureRecognizer * tapInterceptorU = [[[GestureRecognizer alloc] init] autorelease];
    
    tapInterceptorU.touchesBeganCallback =  ^(NSSet * touches, UIEvent * event) {
        
        if (![_loginParam bPTZ_PRI]) {//前端设备不支持
            
            [ivPTZLeft setUserInteractionEnabled:NO];
            [ivPTZRight setUserInteractionEnabled:NO];
            [ivPTZUp setUserInteractionEnabled:NO];
            [ivPTZDown setUserInteractionEnabled:NO];
            
            iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeDeviceNoPTZ", @"Device does not support ptz")];
            [toast retain];
            [toast setToastPosition:kToastPositionCenter];
            [toast setToastDuration:kToastDurationShort];
            [toast show];
            [toast release];
            return;
        }
        
        isPTZUPPressed=YES;
        [ivPTZUp setImage:[UIImage imageNamed:@"ptz_up_on.png"]];
        
        
    };
    
    tapInterceptorU.touchesEndedCallback =  ^(NSSet * touches, UIEvent * event) {
        isPTZUPPressed=NO;
        [ivPTZUp setImage:[UIImage imageNamed:@"ptz_up_normal.png"]];
    };
    
    tapInterceptorU.touchesMovedCallback =  ^(NSSet * touches, UIEvent * event) {
        isPTZUPPressed=YES;
        [ivPTZUp setImage:[UIImage imageNamed:@"ptz_up_on.png"]];
    };
    
    [ivPTZUp setUserInteractionEnabled: YES];
    [ivPTZUp addGestureRecognizer:tapInterceptorU];
    
    GestureRecognizer * tapInterceptorD = [[[GestureRecognizer alloc] init] autorelease];
    
    tapInterceptorD.touchesBeganCallback =  ^(NSSet * touches, UIEvent * event) {
        if (![_loginParam bPTZ_PRI]) {//前端设备不支持
            
            [ivPTZLeft setUserInteractionEnabled:NO];
            [ivPTZRight setUserInteractionEnabled:NO];
            [ivPTZUp setUserInteractionEnabled:NO];
            [ivPTZDown setUserInteractionEnabled:NO];
            
            iToast *toast = [iToast makeToast:NSLocalizedString(@"noticeDeviceNoPTZ", @"Device does not support ptz")];
            [toast retain];
            [toast setToastPosition:kToastPositionCenter];
            [toast setToastDuration:kToastDurationShort];
            [toast show];
            [toast release];
            return;
        }
        
        isPTZDownPressed=YES;
        [ivPTZDown setImage:[UIImage imageNamed:@"ptz_down_on.png"]];
    };
    
    tapInterceptorD.touchesEndedCallback =  ^(NSSet * touches, UIEvent * event) {
        isPTZDownPressed=NO;
        [ivPTZDown setImage:[UIImage imageNamed:@"ptz_down_normal.png"]];
    };
    
    tapInterceptorD.touchesMovedCallback =  ^(NSSet * touches, UIEvent * event) {
        isPTZDownPressed=YES;
        [ivPTZDown setImage:[UIImage imageNamed:@"ptz_down_on.png"]];
    };
    
    [ivPTZDown setUserInteractionEnabled: YES];
    [ivPTZDown addGestureRecognizer:tapInterceptorD];
    
}
//show alert function
-(void)showAlertTitel:(NSString *)titel withMessage: (NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle: titel message:message delegate: nil cancelButtonTitle: NSLocalizedString(@"btnOK", @"OK") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

//

-(void)doLocalizable{
    chnFlag=@"通道";
    noteSelectAChnToPlay = @"请选择播放的通道";
    notePlayingChn = @"正在播放通道 ";
    
    return;
}

//
-(void)onApplicationDidBecomeActiveHandle:(NSNotification *)notification{

    [nvMediaPlayer onApplicationDidBecomeActive];
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        CGRect frame =m_rectFull;
        frame.size.width = frame.size.width+2;
        frame.origin.x = frame.origin.x-1;
        [nvMediaPlayer setFrame:frame];
        
    }else{
        CGRect frame =m_rectNormal;
        frame.size.width = frame.size.width+2;
        frame.origin.x = frame.origin.x-1;
        [nvMediaPlayer setFrame:frame];
        
    }
    
    
    //add by luo 20150701
    if (isPlaying) {
        [self startPtzCtrlThread];
    }
    
}

-(void)onApplicationWillResignActiveHandle:(NSNotification *)notification{

    nPTZCtrlThreadID++;
    if(isRecording){
        [self onRecordingClick:nil];
    }
    [nvMediaPlayer onApplicationWillResignActive];
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        [nvMediaPlayer setFrame:m_rectFull];
    }else{
        
        [nvMediaPlayer setFrame:m_rectNormal];
    }
    
}


- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

-(void) onTickCountTimer:(id)param{
    nToolViewShowTickCount--;
    if (nToolViewShowTickCount<=0) {

        if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
            
            
            if (![vPTZXPanel isHidden]) {
                nToolViewShowTickCount++;
                return;
            }
            if (isAudioRecording) {
                return;
            }
            
            if (![bottomView isHidden] || ![topView isHidden]) {
                [self showLanPTZXButton:NO];
                [bottomView setHidden:YES];
                [self qlStatChange:YES];
                [vQLPanel setHidden:YES];
                [topView setHidden:YES];
                [self topMoreStatChange: YES];
                [lblCanSpeakNotice setHidden:YES];
                
            }
            
        }else{
            
            if ([bottomView isHidden] || [topView isHidden]) {
                
                [bottomView setHidden:NO];
                [topView setHidden:NO];
                [vQLPanel setHidden:YES];
            }
        }
    }
}

-(void) ptzCtrlThreadFucn:(int)nThreadID{
    
    while (nThreadID==nPTZCtrlThreadID) {
        
        if (isPTZLeftPressed || isPTZRightPressed || isPTZUPPressed || isPTZDownPressed) {
            if (isPTZLeftPressed && isPTZRightPressed) {
                [NSThread sleepForTimeInterval:0.05];
                continue;
            }
            
            if (isPTZUPPressed && isPTZDownPressed) {
                [NSThread sleepForTimeInterval:0.05];
                continue;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                isPTZLeft=isPTZLeftPressed;
                isPTZRight=isPTZRightPressed;
                isPTZUP=isPTZUPPressed;
                isPTZDown=isPTZDownPressed;
                nStep=0;
                
                if ([_loginParam bPTZ_PRI]) {
                    
                    [nvMediaPlayer SetPTZActionLeft:isPTZLeft Right:isPTZRight Up:isPTZUP Down:isPTZDown step:nStep];
                }
            });
        }
        
        
        [NSThread sleepForTimeInterval:0.3];
    }
}

-(void)startPtzCtrlThread{
    if ([_loginParam bPTZ_PRI]) {
        nPTZCtrlThreadID++;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            [self ptzCtrlThreadFucn:nPTZCtrlThreadID];
            [pool release];
        });
    }
    
}

////////////////////////////////////////////////////
//
-(NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section{
    return nPTZXCount;
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [nvMediaPlayer StopPlay];
    
}
////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    
    
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
    
    isRecording=NO;

    if (ptzxPicList==nil) {
        ptzxPicList =[[NSMutableArray alloc] init];
    }
    
    [btnPTZXPanelClose addTarget:self action:@selector(onHidePTZLocationSettingView:) forControlEvents:UIControlEventTouchUpInside];
    [btnPTZXPanelClose setTitle:NSLocalizedString(@"btnClose", nil) forState:UIControlStateNormal];
    
    location1 = [[UIPTZLocationNote alloc] init];
    location2 = [[UIPTZLocationNote alloc] init];
    location3 = [[UIPTZLocationNote alloc] init];
    location4 = [[UIPTZLocationNote alloc] init];
    location5 = [[UIPTZLocationNote alloc] init];
    location6 = [[UIPTZLocationNote alloc] init];
    location7 = [[UIPTZLocationNote alloc] init];
    location8 = [[UIPTZLocationNote alloc] init];
    location9 = [[UIPTZLocationNote alloc] init];
    location1.tag = 0;
    location2.tag = 1;
    location3.tag = 2;
    location4.tag = 3;
    location5.tag = 4;
    location6.tag = 5;
    location7.tag = 6;
    location8.tag = 7;
    location9.tag = 8;
    
    
    [location1 setSettingTarget:self action:@selector(onPTZXSettingClick:)];
    [location1 setLocationTarget:self action:@selector(onPTZXLocatingClick:)];
    
    [location2 setSettingTarget:self action:@selector(onPTZXSettingClick:)];
    [location2 setLocationTarget:self action:@selector(onPTZXLocatingClick:)];
    
    [location3 setSettingTarget:self action:@selector(onPTZXSettingClick:)];
    [location3 setLocationTarget:self action:@selector(onPTZXLocatingClick:)];
    
    [location4 setSettingTarget:self action:@selector(onPTZXSettingClick:)];
    [location4 setLocationTarget:self action:@selector(onPTZXLocatingClick:)];
    
    [location5 setSettingTarget:self action:@selector(onPTZXSettingClick:)];
    [location5 setLocationTarget:self action:@selector(onPTZXLocatingClick:)];
    
    [location6 setSettingTarget:self action:@selector(onPTZXSettingClick:)];
    [location6 setLocationTarget:self action:@selector(onPTZXLocatingClick:)];
    
    [location7 setSettingTarget:self action:@selector(onPTZXSettingClick:)];
    [location7 setLocationTarget:self action:@selector(onPTZXLocatingClick:)];
    
    [location8 setSettingTarget:self action:@selector(onPTZXSettingClick:)];
    [location8 setLocationTarget:self action:@selector(onPTZXLocatingClick:)];
    
    [location9 setSettingTarget:self action:@selector(onPTZXSettingClick:)];
    [location9 setLocationTarget:self action:@selector(onPTZXLocatingClick:)];
    
    
    fScreenWith = [[UIScreen mainScreen] bounds].size.width;
    fScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if (fScreenWith>fScreenHeight) {
        fScreenWith = fScreenHeight;
        fScreenHeight = [[UIScreen mainScreen] bounds].size.width;
    }
    
    fStepDistance = fScreenWith/3;
    
    nPTZCtrlThreadID = 0;
    nStep=0;
    btnMicView = [[UINVMicPhoneView alloc] init];
    
    isAudioRecording=NO;
    
    toolViewShowTickCountTimmer = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(onTickCountTimer:)userInfo:nil repeats:YES];
    
    [[NSRunLoop  currentRunLoop] addTimer:toolViewShowTickCountTimmer forMode:NSDefaultRunLoopMode];
    nToolViewShowTickCount = 8;
    
    isBackAlertShow=NO;
    
    nStreamType=STREAM_TYPE_SMOOTH;
    
    nvMediaPlayer = [[NVMediaPlayer alloc] initWithFrame:imagePlayView.frame];
    nvMediaPlayer.contentMode = UIViewContentModeScaleAspectFit;
    [nvMediaPlayer setBackgroundColor:[UIColor blackColor]];
    [imagePlayView addSubview:nvMediaPlayer];
    
    [nvMediaPlayer SetAudioParam:YES];
    
    
    [self addGestureRecognizer];
    [self doLocalizable];
    
    isPTZhorizontalAutoOn=NO;
    isPTZVerticalAutoOn=NO;
    
    m_bSoundEnable = YES;
    
    [self GetSettings];
    
    lastScale=1.0;
    m_rectNormal = CGRectMake(0, 0, 320, 240);
    m_rectFull = CGRectMake(0, 0, 320, 240);
    
    [self qlStatChange:YES];
    [self micStatChange: YES];
    //
    operationQueue = [[NSOperationQueue alloc] init];
    
    // Do any additional setup after loading the view, typically from a nib.
    [LibContext InitResuorce];
    
    [headerNote setText:nil];
    
    //添加 消息observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActiveHandle:) name:@"ON_BECOME_ACTIVE" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActiveHandle:) name:@"ON_RESIGN_ACTIVE" object:nil];
    
    [self initInferface];
    
    
}




-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initInferface];
    [self loginServer];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ON_BECOME_ACTIVE" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ON_RESIGN_ACTIVE" object:nil];
    
    [vPTZXLanBtnContanner release];
    [ivTZXLanBtnBG release];
    [btnPTZXLan release];
    
    [ivPTZXContainViewBG release];
    [vPTZXContainView release];
    [vPTZXContainViewTop release];
    [ivPTZXContainViewTopBG release];
    [btnPTZXPanelClose release];
    [scvPTZXPointList release];
    [lblPTZXTitle release];
    
     [ptzxPicList release];
    [location1 release];
    [location2 release];
    [location3 release];
    [location4 release];
    [location5 release];
    [location6 release];
    [location7 release];
    [location8 release];
    [location9 release];
    [ivPTZXBG release];
    
    [vPTZPanel release];
    [ivPTZLeft release];
    [ivPTZRight release];
    [ivPTZUp release];
    [ivPTZDown release];
    
    [vScreenShotView release];
    [lblCanSpeakNotice release];
    [lblPTZNotice release];
    [operationQueue release];
    
    [nvMediaPlayer release];
    
    [topView release];
    [ivTopViewBg release];
    [btnShowMore release];
    
    [bottomView release];
    [ivBottomViewBg release];
    
   	[chnFlag release];
    
    [imagePlayView release];
    
    [vQLPanel release];
    [ivQLPanelBg release];
    [ivQLPanelSpiter release];
    [btnQualityHD release];
    [btnQualitySmooth release];
    
    [btnBackToList release];
    [btnBack release];
    [btnReverseImage release];
    [btnScreenShot release];
    
    [headerNote release];
    [btnSoundEnable release];
    [btnImgQL release];
    
    [btnMicView release];
    
    [_btnShowPTZ release];
    [_PlayBottomView release];
    [_btnPreviousCam release];
    [_btnNextCam release];
    [_btnStartRecord release];
    [_btnClosePtzPanel release];
    [super dealloc];
}

@end

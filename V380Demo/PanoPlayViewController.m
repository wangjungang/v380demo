//
//  IMobilePlayerPlayController.m
//  IMobilePlayer
//
//  Created by luo king on 11-12-12.
//  Copyright 2011 cctv. All rights reserved.
//

#import "PanoPlayViewController.h"
#import "GestureRecognizer.h"
#import "QuartzCore/QuartzCore.h"
#import "LoginHandle.h"
#import "FunctionTools.h"
#import "AppDelegate.h"
#import "iToast.h"
#import "DXAlertView.h"
#import "UIWindow+YzdHUD.h"
#import "LibContext.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "PanoModeView.h"
#import "CamTypePopView.h"
#import "LoginHelper.h"

CGFloat const pgestureMinimumTranslation = 20.0;

#define widthDelta 1.0

#define IS_USER_LOGIN ([((AppDelegate *)[UIApplication sharedApplication].delegate) isUserLogin])

@interface PanoPlayViewController ()

@property (nonatomic, retain) PanoModeView *panoModeView;
@property (nonatomic, retain) CamTypePopView *camtypePopView;
@property(nonatomic,assign) int currentMode;
@property(nonatomic,assign) int currentCamType;
@property (retain, nonatomic) IBOutlet UILabel *PanoTimeLabel;

@end

@implementation PanoPlayViewController

@synthesize nChannels;
@synthesize imagePlayView, ivImagePlayViewBg;//the

@synthesize vScreenShotView;
@synthesize topView, headerNote, ivTopViewBg;

@synthesize nChnBase;
@synthesize isPlaying;

@synthesize chnFlag;
@synthesize rowHeight;
@synthesize bottomView;
@synthesize customSize;
@synthesize nZoomIndex;
@synthesize btnBackToList, btnSoundEnable, btnImgQL, btnReverseImage, btnScreenShot, btnBack;
@synthesize m_bSoundEnable;
@synthesize vQLPanel, ivQLPanelBg, ivQLPanelSpiter, btnQualityHD, btnQualitySmooth;
@synthesize lblCanSpeakNotice;
@synthesize ivBottomViewBg;
@synthesize fScreenWith, fScreenHeight,fStepDistance;
@synthesize btnRecord;
@synthesize _loginParam;

-(void)loginServer{
    //设置国家地区
    [LibContext setZoneIndex:1];//1是中国
    
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
            
            nStreamType=STREAM_TYPE_HD;

            [self SetLoginParam:loginResult];
            [headerNote setText:[NSString stringWithFormat:@"%i", [_loginParam nDevID]]];
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
    //    }
    
    
    [pool release];
}
// 全景模式控件 getter
- (PanoModeView *)panoModeView {
    
    if (_panoModeView == nil) {
        
        _panoModeView = [[PanoModeView panoModeViewWithType:_currentCamType] retain];
        
        [_panoModeView addTarget:self action:@selector(panoModeButtonPressed:)];
        CGFloat width;
        CGFloat height;

        if (CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds)) {//横屏
            
            if (_currentCamType == FISHEYECAMTYPEWALL) {
                
                height = 150.0;
            }else if (_currentCamType == FISHEYECAMTYPETOP){
                height = 300.0;
            }
            width = 50.0;
            CGFloat x =nvMediaPlayer.frame.size.width - width - 10;
            CGFloat y = (nvMediaPlayer.frame.size.height - height) * 0.5;
            _panoModeView.frame = CGRectMake(x, y, width, height);
            
        }else{
            
            if (_currentCamType == FISHEYECAMTYPEWALL) {
                
                width = 150.0;
            }else if (_currentCamType == FISHEYECAMTYPETOP){
                width = 300.0;
            }
            height = 50.0;
            CGFloat x = CGRectGetMaxX(btnImgQL.frame) - width;
            CGFloat y = CGRectGetMinY(bottomView.frame) - height - 10;
            _panoModeView.frame = CGRectMake(x, y, width, height);
            
        }
        
    }else{
        
        [_panoModeView setFixType:_currentCamType];
        CGFloat width;
        CGFloat height;
        
        if (CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds)) {//横屏
            
            if (_currentCamType == FISHEYECAMTYPEWALL) {
                
                height = 150.0;
            }else if (_currentCamType == FISHEYECAMTYPETOP){
                height = 300.0;
            }
           width = 50.0;
            CGFloat x =nvMediaPlayer.frame.size.width - width - 10;
            CGFloat y = (nvMediaPlayer.frame.size.height - height) * 0.5;
            _panoModeView.frame = CGRectMake(x, y, width, height);

        }else{
            
            
            if (_currentCamType == FISHEYECAMTYPEWALL) {
                
                width = 150.0;
            }else if (_currentCamType == FISHEYECAMTYPETOP){
                width = 300.0;
            }
            height = 50.0;
            CGFloat x = CGRectGetMaxX(btnImgQL.frame) - width;
            CGFloat y = CGRectGetMinY(bottomView.frame) - height - 10;
            _panoModeView.frame = CGRectMake(x, y, width, height);
            
        }
        
    }
    
    return _panoModeView;
}
-(void)ResetPopviewStatu{
    
    [nvMediaPlayer SetMode:0];
    _currentMode =0;
    [self.panoModeView selecteItemAtIndex:0];
    [btnImgQL setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fisheye_0_logo"]] forState:UIControlStateNormal];
    if ([self.view.subviews containsObject:self.camtypePopView]) [self.camtypePopView removeFromSuperview];
    if ([self.view.subviews containsObject:self.panoModeView]) [self.panoModeView removeFromSuperview];
    if ([nvMediaPlayer.subviews containsObject:self.panoModeView]) [self.panoModeView removeFromSuperview];
}

// 全景模式点击事件, 切换模式
- (void)panoModeButtonPressed:(UIButton *)sender {
    
    if((int)sender.tag == 13){
        
        if ([_loginParam bReverse_PRI]) {
            [nvMediaPlayer SetImageOrientation:1000];
            isReverse=!isReverse;
            self.panoModeView.isRe = isReverse;
            [self.panoModeView selecteItemAtIndex:13];

        }else{
            isReverse=!isReverse;
            [self setPlayViewOrentation];

            self.panoModeView.isRe = isReverse;
        }
        
    }else{
       
    _currentMode =(int)sender.tag;

    [nvMediaPlayer SetMode:_currentMode];
        
    [self.panoModeView selecteItemAtIndex:_currentMode];
    [btnImgQL setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fisheye_%d_logo", _currentMode]] forState:UIControlStateNormal];
    
    }
    
    //modify by zhantian 20170802
    if(CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds)){
        
        
    }else{
        
        [self.panoModeView removeFromSuperview];
        
    }
    //end by zhantian
}

#pragma mark - camtype
-(CamTypePopView *)camtypePopView{
    
    if (_camtypePopView == nil) {
        //创建选择界面
        _camtypePopView = [[CamTypePopView camtypePopview] retain];
        //设置切换方法
        [_camtypePopView addTarget:self action:@selector(panoCamtypeModeButtonPressed:)];
        //设置弹出框的frame
        CGFloat width;
        
        width = 100.0;
        
        CGFloat height = 50.0;
        CGFloat x = CGRectGetMaxX(btnReverseImage.frame) - width;
        CGFloat y = CGRectGetMinY(bottomView.frame) - height - 10;
        _camtypePopView.frame = CGRectMake(x, y, width, height);

    }
    [_camtypePopView selecteItemAtIndex:_currentCamType];
    
    return _camtypePopView;
    
}

//点击镜头类型选择
-(void)panoCamtypeModeButtonPressed:(UIButton *)sender{
    //
    _currentCamType = sender.tag;
    
    CGFloat width;
    if (_currentCamType == FISHEYECAMTYPEWALL) {

        width = 100.0;
    }else if (_currentCamType == FISHEYECAMTYPETOP){

        width = 250.0;
    }
    CGFloat height = 50.0;
    CGFloat x = CGRectGetMaxX(btnImgQL.frame) - width;
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
    [btnImgQL setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fisheye_%d_logo", _currentMode]] forState:UIControlStateNormal];
    [btnReverseImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"camtype_%d_logo", _currentCamType]] forState:UIControlStateNormal];
    
    [self.camtypePopView removeFromSuperview];//消失

}

//显示镜头类型
- (IBAction) ShowCamtypeSettingView{
    if ([self.view.subviews containsObject:self.panoModeView]) {
        
        [self.panoModeView removeFromSuperview];
        
    }
    
    if ([self.view.subviews containsObject:self.camtypePopView]) {
        
        [self.camtypePopView removeFromSuperview];
        
    } else {
        
        [self.view addSubview:self.camtypePopView];
    }
        
}




- (IBAction) onScreenShotClick:(id)sender{
    
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];// modify by zhantian 20170731 self.view.window --> self.view
    }
    
    [self.view addSubview:HUD];// modify by zhantian 20170731 self.view.window --> self.view
    
    HUD.delegate = nil;
    HUD.labelText =  NSLocalizedString(@"noticeScreenShot", @"Save picture...");
    [HUD showWhileExecuting:nil onTarget:self withObject:nil animated:YES];
    dispatch_after(1.0f, dispatch_get_main_queue(), ^{
        [self screenShot];
        
    });
}

- (IBAction) onReverseImageClick:(id)sender{
    if ([_loginParam bReverse_PRI]) {
        [nvMediaPlayer SetImageOrientation:1000];
    }else{
        isReverse=!isReverse;
        [self setPlayViewOrentation];
    }
    
}
- (void)setPlayViewOrentation{
    
    [nvMediaPlayer SetImageOrientation:isReverse];
}

- (IBAction) onMicShowClick:(id)sender{
    
}

#define PTZX_ITEM_HEIGHT 80

- (void)qlStatChange:(BOOL)isHide{//add by luo 20141104
    
//        if ([vQLPanel isHidden]) {
//            [btnImgQL setImage:[UIImage imageNamed:@"btn_frame_size_normal.png"] forState:UIControlStateNormal];
//            [btnImgQL setImage:[UIImage imageNamed:@"btn_frame_size_on.png"] forState:UIControlStateHighlighted];
//    
//    
//        }else{
//    
//            [btnImgQL setImage:[UIImage imageNamed:@"btn_frame_size_on.png"] forState:UIControlStateNormal];
//            [btnImgQL setImage:[UIImage imageNamed:@"btn_frame_size_normal.png"] forState:UIControlStateHighlighted];
//    
//    
//        }
    //
    
}



- (void)screenShot{
    
    [btnScreenShot setEnabled:NO];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.calendar = [[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian]autorelease];

//    dateFormatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    NSString *strFilename=[NSString stringWithFormat:@"%@(%i).jpg",currentDateStr, [_loginParam nDevID]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",strFilename]];   // 保存文件的名称
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image =[nvMediaPlayer screenShot];
        [image retain];
        dispatch_after(0.1f, dispatch_get_main_queue(), ^{
            
            if (image) {
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                NSString *albumName = NSLocalizedString(@"appName", @"app's name");
                [library saveImage:image toAlbum:albumName completion:^(NSURL *assetURL, NSError *error) {
                    
                    if (error == nil) {
//                        DLog(@"screenshot ok");
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
                        
//                        DLog(@"err = %@", error);
                    }
                    
                } failure:^(NSError *error) {
                    
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
                        
                    }
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
                });
                
                
                [btnScreenShot setEnabled:YES];
            }
            
            
        });
        
        [image release];
    });
}

- (void)saveImageResult:(UIImage *)image hasBeenSavedInPhotoAlbumWithEro:(NSError *)error usingContextInfo:(void *)ctxInfo{
    [btnScreenShot setEnabled:YES];
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

- (IBAction) onBackAnStopClick:(id)sender{
    
        if (isPlaying) {
            
            isBackAlertShow=YES;
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"noticeMsgStopAndback", @"Whether to stop and return to the list of devices?") leftButtonTitle:NSLocalizedString(@"btnYES", @"YES") rightButtonTitle:NSLocalizedString(@"btnNO", @"NO")];
            [alert show];
            alert.leftBlock = ^() {
                [self StopPlay:YES];
                
                AppDelegate *deleget = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [deleget retain];
                if (deleget) {
                    [deleget set_isPlaying:NO];
                }
                [deleget release];
                
                [self dismissViewControllerAnimated:NO completion:^{}];
                
                
                isBackAlertShow=NO;
                if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
                    [nvMediaPlayer setFrame:m_rectFull];
                }else{
                    
                    [nvMediaPlayer setFrame:m_rectNormal];
                }
                
                [self ResetPopviewStatu];
                //add by lusongbin 20160922
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

- (IBAction) SoundEnableClick:(id)sender{
        
    m_bSoundEnable = !m_bSoundEnable;
    //add by zhantian 20170802 横竖屏按钮的修改
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft){
        
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs_click.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_pressed"] forState:UIControlStateHighlighted];
        }
        
    }else{
        
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_pressed"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_pressed"] forState:UIControlStateHighlighted];
        }
        
    }
    
    //end by zhantian
//    if (m_bSoundEnable) {
//        [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_normal"] forState:UIControlStateNormal];
//        [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_pressed"] forState:UIControlStateHighlighted];
//    }else{
//        [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_normal"] forState:UIControlStateNormal];
//        [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_pressed"] forState:UIControlStateHighlighted];
//    }
    [nvMediaPlayer SetAudioParam:m_bSoundEnable];
    
    [self SaveSettings];
}
#pragma mark - 方法为弹出全景模式选择
- (IBAction) onImageQLClick:(id)sender{
    
    if ([self.view.subviews containsObject:self.camtypePopView]) {
        
        [self.camtypePopView removeFromSuperview];
    }
    
    
    if ([self.view.subviews containsObject:self.panoModeView]) {
        
        [self.panoModeView removeFromSuperview];
        
        
    } else {
        
        [self.view addSubview:self.panoModeView];
    }
}

- (IBAction) onImageQLSelectClick:(id)sender{
    if (sender==btnQualityHD) {
        
        if (nStreamType==STREAM_TYPE_HD) {
            return;
        }
        [btnQualityHD setTitleColor:[UIColor colorWithRed:0.246 green:0.467 blue:0.894 alpha:1]  forState:UIControlStateNormal];
        
        [btnQualitySmooth setTitleColor:[UIColor darkGrayColor]  forState:UIControlStateNormal];
        
        nStreamType=STREAM_TYPE_HD;
        
        
    }else if (sender==btnQualitySmooth){
        if (nStreamType==STREAM_TYPE_SMOOTH) {
            return;
        }
        
        [btnQualityHD setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
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
    
    [self qlStatChange:YES];
}

- (void) SetLoginParam:(id)param{
    
    LoginHandle *loginParam = (LoginHandle *)param;
    [loginParam retain];
    
    
    if (loginParam) {
        nStreamType=STREAM_TYPE_HD;
        
        [self set_loginParam:loginParam];
        
        if (_loginParam) {
            if ([_loginParam strName] && [[_loginParam strName] length]>0) {
                
                [headerNote setText:[NSString stringWithFormat:@"%@", [_loginParam strName]]];
            }else{
                self.navigationController.title =[NSString stringWithFormat:@"%i", [_loginParam nDevID]];
                [headerNote setText:[NSString stringWithFormat:@"%i", [_loginParam nDevID]]];
            }
            
        }else{
            [headerNote setText:nil];
        }
        //add by lusongbin 20161011
        _currentCamType = [loginParam nCamType];
        nZoomIndex=0;
        
        isReverse=NO;
        self.panoModeView.isRe = isReverse;
        [self.panoModeView selecteItemAtIndex:13];


    }
    [loginParam release];
    [self initInferface];
    
}

- (void)SaveSettings{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault retain];
    
    if (userDefault) {
        
        [userDefault setValue:[NSNumber numberWithBool:m_bSoundEnable] forKey:@"sound_enable"];
        [userDefault synchronize];
        
    }
    [userDefault release];
}
- (void)GetSettings{
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
    
    
//    if (m_bSoundEnable) {
//        [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_normal"] forState:UIControlStateNormal];
//        [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_pressed"] forState:UIControlStateHighlighted];
//    }else{
//        [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_normal"] forState:UIControlStateNormal];
//        [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_pressed"] forState:UIControlStateHighlighted];
//    }
    //add by zhantian 20170802 横竖屏按钮的修改
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft){
        
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs_click.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_pressed"] forState:UIControlStateHighlighted];
        }
        
    }else{
        
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_pressed"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_pressed"] forState:UIControlStateHighlighted];
        }
        
    }
    
    //end by zhantian
}


//iOS 5
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (isAudioRecording) {//add by luo 20150323
        return NO;
    }
    return YES;//modify by lusongbin
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    //旋转弹出框消失
    [self.camtypePopView removeFromSuperview];
     [self.panoModeView removeFromSuperview];
    
    [self initInferface];
    [nvMediaPlayer updateRender];
    [nvMediaPlayer freshRender];
    if (isBackAlertShow) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"noticeMsgStopAndback", @"Whether to stop and return to the list of devices?") leftButtonTitle:NSLocalizedString(@"btnYES", @"YES") rightButtonTitle:NSLocalizedString(@"btnNO", @"NO")];
        [alert show];
        alert.leftBlock = ^() {
            [self StopPlay:YES];
            AppDelegate *deleget = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [deleget retain];
            if (deleget) {
                [deleget set_isPlaying:NO];
            }
            [deleget release];
            
            [self dismissModalViewControllerAnimated:NO];
//            [playDelegate PlayDelegateStopPlay];
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
    if (isAudioRecording) {//add by luo 20150323
        return NO;
    }
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void) initInferface{
//    DLog(@"initInferface");//add for test
    [self panoModeView];
    CGRect screenSize = [[UIScreen mainScreen] applicationFrame];
    [self.view setFrame:screenSize];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {//modify by luo 20141104
        if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
            
            CGFloat fWidth = screenSize.size.width;
            screenSize.size.width =  screenSize.size.height;
            screenSize.size.height = fWidth;
            
        }
        
    }
    
    screenSize.origin.x = 0;
    screenSize.origin.y = 0;
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
    
    [btnBackToList setFrame:frame];
    [topView addSubview:btnBackToList];
    
    m_rectFull = screenSize;
#pragma mark - 播放器
//    [lblPTZNotice setHidden:YES];
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        CGFloat fWidth = screenSize.size.width;
        screenSize.size.width =  screenSize.size.height;
        screenSize.size.height = fWidth;
        
        [imagePlayView setFrame:m_rectFull];
        [nvMediaPlayer setFrame:m_rectFull];
        
        [ivImagePlayViewBg setFrame:m_rectFull];
        [imagePlayView addSubview:ivImagePlayViewBg];
        //播放器横屏改变为固定模式
        if(_currentCamType == FISHEYECAMTYPETOP){
            [nvMediaPlayer SetMode:12];// 12 为模式
        }

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
        frame.origin.x =nvMediaPlayer.frame.size.width - frame.size.width - 5;
        frame.origin.y = 5;
        _PanoTimeLabel.frame = frame;
        
    }else{
        //播放器竖屏恢复之前的模式
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
        
        [self.view addSubview:_PanoTimeLabel];
        CGRect frame = _PanoTimeLabel.frame;
        frame.size.width = textW;
        frame.size.height = textH;
        frame.origin.x = self.view.frame.size.width - frame.size.width-5;
        frame.origin.y = CGRectGetMaxY(topView.frame)+5;
        _PanoTimeLabel.frame = frame;
        //end add by lusongbin 20161019
        
        if(_currentCamType == FISHEYECAMTYPETOP){

            [nvMediaPlayer SetMode:_currentMode];
            
        }
        
        m_rectNormal = m_rectFull;
        m_rectNormal.size.width = m_rectFull.size.width;
        if(m_rectNormal.size.width*1.2 >= ( m_rectNormal.size.height - topView.frame.size.height - 80)){
            m_rectNormal.size.height = ( m_rectNormal.size.height - topView.frame.size.height - 80);
        }else{
            m_rectNormal.size.height =m_rectNormal.size.width*1.2;//m_rectNormal.size.width*0.82;

        }
        m_rectNormal.origin.x = 0;
        m_rectNormal.origin.y = 0;
        
        CGRect rect = m_rectNormal;
        rect.origin.y = (([UIScreen mainScreen].bounds.size.height - topView.frame.size.height - 80) - rect.size.height) * 0.5 + CGRectGetMaxY(topView.frame);//设置播放器居中, 80为bottomview的高度
        
        [imagePlayView setFrame:rect];
        
        rect.size.height = m_rectNormal.size.height-0.1;
        rect.size.width = m_rectNormal.size.width-0.1;
        rect.origin.x = (m_rectNormal.size.width - rect.size.width)/2;
        rect.origin.y = (m_rectNormal.size.height - rect.size.height)/2;
        [nvMediaPlayer setFrame:rect];
        
        [ivImagePlayViewBg setFrame:m_rectNormal];
        [imagePlayView addSubview:ivImagePlayViewBg];

    }

    
    [nvMediaPlayer removeFromSuperview];
    [imagePlayView addSubview:nvMediaPlayer];//
    [nvMediaPlayer setContentMode:UIViewContentModeScaleAspectFit];
    [imagePlayView addSubview:nvMediaPlayer];
    
    //init bottom view
    CGFloat fBottonHeight=80;
    
    if (self.interfaceOrientation==UIDeviceOrientationPortrait || self.interfaceOrientation==UIDeviceOrientationPortraitUpsideDown) {
        if (fBottonHeight>(m_rectFull.size.height-topView.frame.size.height-m_rectNormal.size.height)) {
            fBottonHeight = (m_rectFull.size.height-topView.frame.size.height-m_rectNormal.size.height);
        }
        
        frame.size.width = m_rectFull.size.width;
        
        frame.size.height = fBottonHeight;
        
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
        
    }else{
        frame.size.width = m_rectFull.size.height;
        
        if(frame.size.width>320){
            frame.size.width = 320;
        }
        
        fBottonHeight = 60;
        
        frame.size.height = fBottonHeight;
        
        frame.origin.x = (m_rectFull.size.width-frame.size.width)/2;
        frame.origin.y = m_rectFull.size.height-frame.size.height-5;
        [bottomView setFrame:frame];
        
        frame =bottomView.frame;
        frame.origin.x=0;
        frame.origin.y=0;
        
        [ivBottomViewBg setFrame:frame];
        
        ivBottomViewBg.layer.cornerRadius = 5;
        ivBottomViewBg.layer.borderWidth = 0.5;
        ivBottomViewBg.layer.borderColor=[UIColor whiteColor].CGColor;
    }
    
    CGFloat containerWidth = m_rectNormal.size.width/6;
    CGFloat btnHeight = bottomView.frame.size.height*0.99;
#pragma mark - bottomview
    // add by zhantian 20170731
    //横屏
    if(self.interfaceOrientation == UIDeviceOrientationLandscapeLeft || self.interfaceOrientation == UIDeviceOrientationLandscapeRight){
        //横屏模式下底部view的fram
        frame.size.width = m_rectFull.size.height;
        if(frame.size.width>320){
            frame.size.width = 320;
        }
        
        
        
        fBottonHeight = 60;
        
        frame.size.height = fBottonHeight;
        
        frame.origin.x = (m_rectFull.size.width-frame.size.width)/2;
        frame.origin.y = m_rectFull.size.height-frame.size.height-5;
        [bottomView setFrame:frame];
        
        frame = bottomView.frame;
        frame.origin.x=0;
        frame.origin.y=0;
        
        [ivBottomViewBg setFrame:frame];
        
        
        ivBottomViewBg.layer.cornerRadius = 5;
        ivBottomViewBg.layer.borderWidth = 0.5;
        ivBottomViewBg.layer.borderColor=[UIColor blackColor].CGColor; //modify by zhantian 20170731
        
        [btnMicView setText:nil];
        [btnSoundEnable setTitle:nil forState:UIControlStateNormal];
        [btnScreenShot setTitle:nil forState:UIControlStateNormal];
        //有对话功能
        if ([_loginParam bSpeak_PRI]) {
            
            
            CGFloat btnWidth = containerWidth*2;
            if (btnWidth>btnHeight) {
                btnWidth = btnHeight;
            }else{
                btnWidth=btnWidth*0.98;
            }
            
            btnHeight = btnWidth;
            
            frame = btnMicView.frame;
            frame.size.width = btnWidth;
            frame.size.height = btnHeight;
            frame.origin.y = (bottomView.frame.size.height-frame.size.height + frame.size.height*0.15)/2;
            frame.origin.x = (bottomView.frame.size.width-frame.size.width)/2;
            [btnMicView setFrame:frame];
            
            
            
            containerWidth = bottomView.frame.size.width/3;
            
            
            //声音
            frame = btnSoundEnable.frame;
            frame.size.width = btnWidth ;
            frame.size.height = btnHeight;
            frame.origin.y = (bottomView.frame.size.height-frame.size.height + frame.size.height*0.3)/2;
            frame.origin.x =  CGRectGetMaxX(btnMicView.frame) + (containerWidth-frame.size.width)/2 ;
            [btnSoundEnable setFrame:frame];
            // [btnSoundEnable setTitle:NSLocalizedString(@"btnSoundEnable", @"監聽") forState:UIControlStateNormal];
            [btnSoundEnable setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            
            //截图btnScreenShot
            frame = btnSoundEnable.frame;
            frame.size.width = btnWidth;
            frame.size.height = btnHeight;
            frame.origin.x = btnMicView.frame.origin.x - (containerWidth-frame.size.width)/2 - btnWidth;
            frame.origin.y = (bottomView.frame.size.height - frame.size.height+ frame.size.height*0.3)/2;
            [btnScreenShot setFrame:frame];
            // [btnScreenShot setTitle:NSLocalizedString(@"btnScreenShot", @"抓拍") forState:UIControlStateNormal];
            [btnScreenShot setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            //
            [btnMicView setHidden:NO];
            
            //清空bottom所有子空间
            btnReverseImage.hidden = YES;
            btnImgQL.hidden = YES;
            //btnScreenShot.hidden = YES;
            
            [bottomView addSubview:btnSoundEnable];
            // [bottomView addSubview:btnReverseImage];
            [bottomView addSubview:btnMicView];
            [bottomView addSubview:btnScreenShot];
            
            
            //           // [bottomView addSubview:btnImgQL];
            
           
            NSLog(@"一次");
    
            
        }else{
            
            CGFloat btnWidth = containerWidth;
            if (btnWidth>btnHeight) {
                btnWidth=btnHeight;
            }else{
                btnWidth=btnWidth*0.98;
            }
            btnHeight = btnWidth;
            
            containerWidth = bottomView.frame.size.width/4;
            
            //声音
            frame = btnSoundEnable.frame;
            frame.size.width = btnWidth;
            frame.size.height = btnHeight;
            frame.origin.y = (bottomView.frame.size.height-frame.size.height)/2;
            frame.origin.x = (containerWidth-frame.size.width)/2;
            [btnSoundEnable setFrame:frame];
            [btnSoundEnable setTitle:NSLocalizedString(@"btnSoundEnable", @"監聽") forState:UIControlStateNormal];
            [btnSoundEnable setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            //截图
            frame = btnSoundEnable.frame;
            frame.origin.x = containerWidth+btnSoundEnable.frame.origin.x;
            [btnScreenShot setFrame:frame];
            [btnScreenShot setTitle:NSLocalizedString(@"btnScreenShot", @"抓拍") forState:UIControlStateNormal];
            [btnScreenShot setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            //录像(cametype button now)
            frame = btnSoundEnable.frame;
            frame.origin.x = containerWidth+btnScreenShot.frame.origin.x;
            [btnReverseImage setFrame:frame];
            [btnReverseImage setTitle:NSLocalizedString(@"btnCamType", @"镜头") forState:UIControlStateNormal];
            [btnReverseImage setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            if (_currentCamType == FISHEYECAMTYPEWALL) {
                [btnReverseImage setImage:[UIImage imageNamed:@"camtype_1_logo"] forState:UIControlStateNormal];
            }else if (_currentCamType == FISHEYECAMTYPETOP){
                [btnReverseImage setImage:[UIImage imageNamed:@"camtype_2_logo"] forState:UIControlStateNormal];
            }
            
            //画质
            frame = btnSoundEnable.frame;
            frame.origin.x = containerWidth+btnReverseImage.frame.origin.x;
            [btnImgQL setFrame:frame];
            [btnImgQL setTitle:NSLocalizedString(@"btnViewMode", @"模式")forState:UIControlStateNormal];
            [btnImgQL setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            [btnMicView setHidden:YES];
            [bottomView addSubview:btnSoundEnable];
            [bottomView addSubview:btnReverseImage];
            [bottomView addSubview:btnScreenShot];
            [bottomView addSubview:btnImgQL];
            
     
            
        }
        
      
        
        //    NSLog(@"_loginParam bPTZX_PRI = %d", [_loginParam bPTZX_PRI]);//add for test
        
        if ([_loginParam bPTZX_PRI]) {
            
            //        [btnShowMore setHidden:NO];
        }else{
   
        }
        
        //
       // [self topMoreStatChange: YES];
        
        
        
    }else{
        //竖屏
        /************zt修改前的代码--start ***************/
        //有对话功能
        btnReverseImage.hidden = NO; //add by zhantian
        btnImgQL.hidden = NO;
        if ([_loginParam bSpeak_PRI]) {
            
            CGFloat btnWidth = containerWidth*2;
            if (btnWidth>btnHeight) {
                btnWidth=btnHeight;
            }else{
                btnWidth=btnWidth*0.98;
            }
            btnHeight = btnWidth;
            frame = btnMicView.frame;
            frame.size.width = btnWidth;
            frame.size.height = btnHeight;
            frame.origin.y = (bottomView.frame.size.height-frame.size.height)/2;
            frame.origin.x = (bottomView.frame.size.width-frame.size.width)/2;
            [btnMicView setFrame:frame];
            [btnMicView setImage:[UIImage imageNamed:@"mic_normal.png"]];
            
            btnWidth = containerWidth;
            if (btnWidth>btnHeight) {
                btnWidth=btnHeight;
            }else{
                btnWidth=btnWidth*0.98;
            }
            btnHeight = btnWidth;
            
            containerWidth = bottomView.frame.size.width/6;
            
            
            //声音
            frame = btnSoundEnable.frame;
            frame.size.width = btnWidth;
            frame.size.height = btnHeight;
            frame.origin.y = (bottomView.frame.size.height-frame.size.height)/2;
            frame.origin.x = (containerWidth-frame.size.width)/2;
            [btnSoundEnable setFrame:frame];
            [btnSoundEnable setTitle:NSLocalizedString(@"btnSoundEnable", @"監聽") forState:UIControlStateNormal];
            [btnSoundEnable setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            
            //截图
            frame = btnSoundEnable.frame;
            frame.origin.x = containerWidth+btnSoundEnable.frame.origin.x;
            [btnScreenShot setFrame:frame];
            [btnScreenShot setTitle:NSLocalizedString(@"btnScreenShot", @"抓拍") forState:UIControlStateNormal];
            [btnScreenShot setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            //录像 翻转btnReverseImage camtype
            frame = btnSoundEnable.frame;
            frame.origin.x = containerWidth*3+btnScreenShot.frame.origin.x;
            [btnReverseImage setFrame:frame];
            
            [btnReverseImage setTitle:NSLocalizedString(@"btnCamType", @"镜头") forState:UIControlStateNormal];
            [btnReverseImage setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            if (_currentCamType == FISHEYECAMTYPEWALL) {
                [btnReverseImage setImage:[UIImage imageNamed:@"camtype_1_logo"] forState:UIControlStateNormal];
            }else if (_currentCamType == FISHEYECAMTYPETOP){
                [btnReverseImage setImage:[UIImage imageNamed:@"camtype_2_logo"] forState:UIControlStateNormal];
            }
            //cam mode
            frame = btnSoundEnable.frame;
            frame.origin.x = containerWidth+btnReverseImage.frame.origin.x;
            [btnImgQL setFrame:frame];
            [btnImgQL setTitle:NSLocalizedString(@"btnViewMode", @"模式")forState:UIControlStateNormal];
            [btnImgQL setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            [btnMicView setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1]];
            
            [btnMicView setHidden:NO];
            
            
            [bottomView addSubview:btnSoundEnable];
            [bottomView addSubview:btnReverseImage];
            [bottomView addSubview:btnMicView];
            [bottomView addSubview:btnScreenShot];
            [bottomView addSubview:btnImgQL];
            
         
            NSLog(@"一次");
 
            
        }else{
            
            CGFloat btnWidth = containerWidth;
            if (btnWidth>btnHeight) {
                btnWidth=btnHeight;
            }else{
                btnWidth=btnWidth*0.98;
            }
            btnHeight = btnWidth;
            
            containerWidth = bottomView.frame.size.width/4;
            
            //声音
            frame = btnSoundEnable.frame;
            frame.size.width = btnWidth;
            frame.size.height = btnHeight;
            frame.origin.y = (bottomView.frame.size.height-frame.size.height)/2;
            frame.origin.x = (containerWidth-frame.size.width)/2;
            [btnSoundEnable setFrame:frame];
            [btnSoundEnable setTitle:NSLocalizedString(@"btnSoundEnable", @"監聽") forState:UIControlStateNormal];
            [btnSoundEnable setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            //截图
            frame = btnSoundEnable.frame;
            frame.origin.x = containerWidth+btnSoundEnable.frame.origin.x;
            [btnScreenShot setFrame:frame];
            [btnScreenShot setTitle:NSLocalizedString(@"btnScreenShot", @"抓拍") forState:UIControlStateNormal];
            [btnScreenShot setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            //录像(cametype button now)
            frame = btnSoundEnable.frame;
            frame.origin.x = containerWidth+btnScreenShot.frame.origin.x;
            [btnReverseImage setFrame:frame];
            [btnReverseImage setTitle:NSLocalizedString(@"btnCamType", @"镜头") forState:UIControlStateNormal];
            [btnReverseImage setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            if (_currentCamType == FISHEYECAMTYPEWALL) {
                [btnReverseImage setImage:[UIImage imageNamed:@"camtype_1_logo"] forState:UIControlStateNormal];
            }else if (_currentCamType == FISHEYECAMTYPETOP){
                [btnReverseImage setImage:[UIImage imageNamed:@"camtype_2_logo"] forState:UIControlStateNormal];
            }
            
            //画质
            frame = btnSoundEnable.frame;
            frame.origin.x = containerWidth+btnReverseImage.frame.origin.x;
            [btnImgQL setFrame:frame];
            [btnImgQL setTitle:NSLocalizedString(@"btnViewMode", @"模式")forState:UIControlStateNormal];
            [btnImgQL setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            
            
            [btnMicView setHidden:YES];
            [bottomView addSubview:btnSoundEnable];
            [bottomView addSubview:btnReverseImage];
            [bottomView addSubview:btnScreenShot];
            [bottomView addSubview:btnImgQL];
            

            
        }
        
    
        
        //    NSLog(@"_loginParam bPTZX_PRI = %d", [_loginParam bPTZX_PRI]);//add for test
        
        if ([_loginParam bPTZX_PRI]) {
            
            //        [btnShowMore setHidden:NO];
        }else{
          
        }
        
        //
       // [self topMoreStatChange: YES];
        
        /************ zt修改前的代码--end ***************/
        
        
    }
   
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        
        
        
        [ivTopViewBg setAlpha:0.5];
        [ivBottomViewBg setAlpha:0.5];
        ivBottomViewBg.layer.cornerRadius = 2;
        [ivBottomViewBg setBackgroundColor:[UIColor blackColor]];
        [ivBottomViewBg setImage:nil];
        
        ///
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
            
            [btnQualitySmooth setTitleColor:[UIColor darkGrayColor]  forState:UIControlStateNormal];
            
        }else if (nStreamType==STREAM_TYPE_SMOOTH){
            
            [btnQualityHD setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [btnQualitySmooth setTitleColor:[UIColor colorWithRed:0.246 green:0.467 blue:0.894 alpha:1] forState:UIControlStateNormal];
            
        }
        //
        [btnBack setFrame:btnScreenShot.frame];
      //  [btnScreenShot setFrame:btnImgQL.frame];
        [btnImgQL setHidden:YES];
        [btnBack setHidden:YES];
        
        [vQLPanel setHidden:YES];
        
        nToolViewShowTickCount=0;
        [bottomView setHidden:YES];
        [topView setHidden:YES];
        
    }else{
        [bottomView setHidden:NO];
        [btnBack setHidden:YES];
        [btnImgQL setHidden:NO];
        [vQLPanel setHidden:YES];
        [ivTopViewBg setAlpha:1.0];
        [ivBottomViewBg setAlpha:1.0];
        [ivBottomViewBg setBackgroundColor:[UIColor whiteColor]];
        ivBottomViewBg.layer.cornerRadius = 0;
        [topView setHidden:NO];
    }
    
    [self.view addSubview:imagePlayView];
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    [self.view addSubview:lblCanSpeakNotice];
    [self.view addSubview:vQLPanel];
    if (self.interfaceOrientation==UIDeviceOrientationPortrait || self.interfaceOrientation==UIDeviceOrientationPortraitUpsideDown) {
        [self.view addSubview:_PanoTimeLabel];
    }
    
    if (_loginParam) {
        if ([_loginParam strName] && [[_loginParam strName] length]>0) {
            
            [headerNote setText:[NSString stringWithFormat:@"%@", [_loginParam strName]]];
        }else{
            
            [headerNote setText:[NSString stringWithFormat:@"%i", [_loginParam nDevID]]];
        }
        
    }else{
        [headerNote setText:nil];
    }
    
    
    [btnQualityHD setTitle:NSLocalizedString(@"lblHD", @"HD") forState:UIControlStateNormal];
    [btnQualitySmooth setTitle:NSLocalizedString(@"lblNormal", @"SD") forState:UIControlStateNormal];
    [lblCanSpeakNotice setText:NSLocalizedString(@"lblCanSpeak", @"You can start talking")];
    //modify by zhantian 20170731
    if(self.interfaceOrientation == UIDeviceOrientationLandscapeRight || self.interfaceOrientation == UIDeviceOrientationLandscapeLeft){
        [btnMicView setText:nil];
    }else{
        [btnMicView setText:NSLocalizedString(@"lblHoldToTalk", @"Hold to talk")];
    }
    //end by zhantian 20170731
    [lblCanSpeakNotice setHidden:YES];
    //add by zhantian 20170802 横竖屏按钮的修改
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft){
        [btnMicView setImage:[UIImage imageNamed:@"mic_cs_normal.png"]];
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_cs_click.png"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_normal.png"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"btn_sound_off_pressed"] forState:UIControlStateHighlighted];
        }
        
        
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_screenshot_cs_normal.png"] forState:UIControlStateNormal];
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_screenshot_cs_on.png"] forState:UIControlStateHighlighted];
        
    }else{
        [btnMicView setImage:[UIImage imageNamed:@"mic_normal.png"]];
        if (m_bSoundEnable) {
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_on_pressed"] forState:UIControlStateHighlighted];
        }else{
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_normal"] forState:UIControlStateNormal];
            [btnSoundEnable setImage:[UIImage imageNamed:@"pano_sound_off_pressed"] forState:UIControlStateHighlighted];
        }
        
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_screenshot_normal.png"] forState:UIControlStateNormal];
        [btnScreenShot setImage:[UIImage imageNamed:@"btn_screenshot_cs_on.png"] forState:UIControlStateHighlighted];
        
    }
    
    //end by zhantian
}

- (void)doZoom{
}

- (void) animationDidStop{
    //    [nvMediaPlayer setM_isPauseRender:NO];//add by luo 201410419
}

- (void) StopPlay:(BOOL)isShotCut{
    
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        [nvMediaPlayer setFrame:m_rectFull];
    }else{
        
        [nvMediaPlayer setFrame:m_rectNormal];
    }
    
    [nvMediaPlayer StopPlay];
    isPlaying=NO;
    isRecording=NO;
    
}

- (void) StopNotice{
    isPlaying=NO;
    
}

- (void) StartPlay:(int) nChn area:(int) nPlayArea{
//    [self startPtzCtrlThread];
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
    _PanoTimeLabel.hidden = YES;
    nStreamType=STREAM_TYPE_HD;
    [nvMediaPlayer StartPlay:0 streamType:nStreamType audio: m_bSoundEnable loginHandel:_loginParam];
    isPlaying=YES;
    [nvMediaPlayer setLblTimeOSD:_PanoTimeLabel];
    
}

- (void) onPlayAreaClick{
    
    //    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
    
    
    if (CGRectGetWidth(self.view.bounds) > CGRectGetHeight(self.view.bounds)) {
        
        nToolViewShowTickCount = 5;
        
        if ([self.view.subviews containsObject:self.camtypePopView]) {
            
            [self.camtypePopView removeFromSuperview];
            
        }
        
        
        if ([nvMediaPlayer.subviews containsObject:self.panoModeView]) {
            
            [self.panoModeView removeFromSuperview];
            
            
        } else if (_currentCamType ==  FISHEYECAMTYPEWALL){
            
            [nvMediaPlayer addSubview:self.panoModeView];
        }
        
        
    }
    
    
    //modify by zhantian 20170731
    if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
        nToolViewShowTickCount=10;
        if (isAudioRecording) {
            //            DLog(@"self.interfaceOrientation isAudioRecording");
            return;
        }
        
        [topView setHidden:YES];
        
        if ([bottomView isHidden]) {
            
           // [self showLanPTZXButton:[_loginParam bPTZX_PRI]];
            
            [bottomView setHidden:NO];
            if (_currentCamType ==  FISHEYECAMTYPEWALL && self.panoModeView){
                
                [nvMediaPlayer addSubview:self.panoModeView];
            }
            
            
            
            //add by zhantian 20170801
            
            
            // [vQLPanel setHidden:NO];
            
        }else{
      //      [self showLanPTZXButton:NO];
            [self qlStatChange:YES];
           // [self topMoreStatChange: YES];
            
            
            [bottomView setHidden:YES];
            
            if (_currentCamType ==  FISHEYECAMTYPEWALL && self.panoModeView){
                
                [self.panoModeView removeFromSuperview];
            }
            
            // [vQLPanel setHidden:YES];
            
            [lblCanSpeakNotice setHidden:YES];
            
        }
    }
    //
    //   }
    
    
}
//手势判断

- (void)handelTap:(UITapGestureRecognizer *)recognizer{
    //
    //    if (recognizer.view!=vQLPanel) {
    //        [self qlStatChange:YES];
    //    }
    [self onPlayAreaClick];
}
- (void)handelPinch:(UIPinchGestureRecognizer *)recognizer{
    
    [nvMediaPlayer scale:[(UIPinchGestureRecognizer*)recognizer scale]];
   
}
- (void)handelSwipe:(UISwipeGestureRecognizer *)recognizer{
   
}
- (void)handelPan:(UIPanGestureRecognizer *)recognizer{
    
    if(![_loginParam bPTZ_PRI] ){
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
                [bottomView setHidden:YES];
                [vQLPanel setHidden:YES];
                
                [lblCanSpeakNotice setHidden:YES];
                
            }
            
        }
        
        //end add by luo 20150516
        
        direction = pkCameraMoveDirectionNone;
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged && direction == pkCameraMoveDirectionNone)
        
    {
        
        direction = [self determineCameraDirectionIfNeeded:translation];
     
        
    }
}

// This method will determine whether the direction of the user's swipe
- (int)getStep:(CGPoint)translation{
    
    
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

- (pCameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation{
    
    nStep=0;
    ///
    pCameraMoveDirection cDirection=pkCameraMoveDirectionNone;
    double fDeltaX = fabs(translation.x);
    double fDeltaY = fabs(translation.y);
    
    ///单方向
    if (fDeltaX>fDeltaY) {
        if (fDeltaX > pgestureMinimumTranslation) {
            
            
            if (translation.x >0.0){
                cDirection = pkCameraMoveDirectionRight;
            } else{
                cDirection = pkCameraMoveDirectionLeft;
            }
        }
    }else{
        if (fDeltaY > pgestureMinimumTranslation) {
            
            
            if (translation.y >0.0){
                cDirection = pkCameraMoveDirectionDown;
            }else{
                cDirection = pkCameraMoveDirectionUp;
            }
            
            
        }
        
    }
    
    return cDirection;
    
}
- (void) addGestureRecognizer{
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap:)];
    [nvMediaPlayer addGestureRecognizer:tapGestureRecognizer];
    
    GestureRecognizer * tapInterceptor = [[[GestureRecognizer alloc] init] autorelease];
    
    // 声音按钮的点击移动和释放
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
        
    };
    
    tapInterceptor.touchesEndedCallback =  ^(NSSet * touches, UIEvent * event) {
        [btnMicView setImage:[UIImage imageNamed:@"mic_normal.png"]];
        isAudioRecording=NO;
        
        [NSThread sleepForTimeInterval:0.400];
        [nvMediaPlayer stopSpeak];
        [lblCanSpeakNotice setHidden:YES];
        
        if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
            
            // [vQLPanel setHidden:NO]; //modify by zhantian 20170731
            [btnMicView setImage:[UIImage imageNamed:@"mic_cs_normal.png"]]; //zhantian
            
            
        }
        
        [btnSoundEnable setEnabled:YES];
        [btnReverseImage setEnabled:YES];
        [btnScreenShot setEnabled:YES];
        [btnImgQL setEnabled:YES];
        [btnBackToList setEnabled:YES];
        
    };
    
    
    tapInterceptor.touchesMovedCallback =  ^(NSSet * touches, UIEvent * event) {
        [btnMicView setImage:[UIImage imageNamed:@"mic_on.png"]];
        isAudioRecording=YES;
        
        [btnSoundEnable setEnabled:NO];
        [btnReverseImage setEnabled:NO];
        [btnScreenShot setEnabled:NO];
        [btnImgQL setEnabled:NO];
        [btnBackToList setEnabled:NO];
        
        [vQLPanel setHidden:YES];
        [lblCanSpeakNotice setHidden:NO];
        
        if (![nvMediaPlayer isSpeaking]) {
            [nvMediaPlayer startSpeak];
        }
        
        
    };
    
    [btnMicView setUserInteractionEnabled: YES];
    [btnMicView addGestureRecognizer:tapInterceptor];
    
}
//show alert function
- (void)showAlertTitel:(NSString *)titel withMessage: (NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle: titel message:message delegate: nil cancelButtonTitle: NSLocalizedString(@"btnOK", @"OK") otherButtonTitles:nil];
    [alert show];
    [alert release];
}


- (void)doLocalizable{
    chnFlag=@"通道";
    noteSelectAChnToPlay = @"请选择播放的通道";
    notePlayingChn = @"正在播放通道 ";
    
    return;
}

- (void)onApplicationDidBecomeActiveHandle:(NSNotification *)notification{
    NSLog(@"onApplicationDidBecomeActiveHandle");
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
    
    
}

- (void)onApplicationWillResignActiveHandle:(NSNotification *)notification{
    NSLog(@"onApplicationWillResignActiveHandle");
    
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

- (void) onTickCountTimer:(id)param{
    
    nToolViewShowTickCount--;
    if (nToolViewShowTickCount<=0) {
        
        
        if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([nvMediaPlayer.subviews containsObject:self.panoModeView]) {
                    
                    [self.panoModeView removeFromSuperview];
                    
                }
                
            });
            
        }
        
    }
}

//
- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section{
    return 0;
    
}

- (void)viewDidLoad
{
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
    _currentMode = 0;//add by lusongbin
    isRecording=NO;
    
    fScreenWith = [[UIScreen mainScreen] bounds].size.width;
    fScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if (fScreenWith>fScreenHeight) {
        fScreenWith = fScreenHeight;
        fScreenHeight = [[UIScreen mainScreen] bounds].size.width;
    }
    
    fStepDistance = fScreenWith/3;
    
    nStep=0;
    btnMicView = [[UINVMicPhoneView alloc] init];
    
    isAudioRecording=NO;
    
    toolViewShowTickCountTimmer = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(onTickCountTimer:)userInfo:nil repeats:YES];
    
    [[NSRunLoop  currentRunLoop] addTimer:toolViewShowTickCountTimmer forMode:NSDefaultRunLoopMode];
    nToolViewShowTickCount = 8;
    
    isBackAlertShow=NO;
    nStreamType=STREAM_TYPE_HD;//全景默认设置应该是高清
    nvMediaPlayer = [[NVPanoPlayer alloc] initWithFrame:imagePlayView.frame];
    nvMediaPlayer.contentMode = UIViewContentModeScaleAspectFit;
    [nvMediaPlayer setBackgroundColor:[UIColor blackColor]];
    [imagePlayView addSubview:nvMediaPlayer];
    [nvMediaPlayer SetAudioParam:YES];
    nChnBase=0;
    [self addGestureRecognizer];
    [self doLocalizable];
    m_bSoundEnable = YES;
    
    [self GetSettings];
    
    lastScale=1.0;
    m_rectNormal = CGRectMake(0, 0, 320, 240);
    m_rectFull = CGRectMake(0, 0, 320, 240);
    
    [self qlStatChange:YES];
    //
    operationQueue = [[NSOperationQueue alloc] init];
    [LibContext InitResuorce];
    [headerNote setText:nil];
    
    //添加 消息observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActiveHandle:) name:@"ON_BECOME_ACTIVE" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActiveHandle:) name:@"ON_RESIGN_ACTIVE" object:nil];
    
    [self initInferface];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [nvMediaPlayer StopPlay];
    [self ResetPopviewStatu];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loginServer];

}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setBtnScreenShot2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ON_BECOME_ACTIVE" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ON_RESIGN_ACTIVE" object:nil];
    [vScreenShotView release];
    [lblCanSpeakNotice release];
    [operationQueue release];
    [nvMediaPlayer release];
    [topView release];
    [ivTopViewBg release];
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
    [btnRecord release];
    [_btnScreenShot2 release];
    [_PanoTimeLabel release];
    [super dealloc];
}

@end

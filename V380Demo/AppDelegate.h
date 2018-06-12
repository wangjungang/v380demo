//
//  AppDelegate.h
//  V380Demo
//
//  Created by zuxi li on 2018/6/1.
//  Copyright © 2018年 blej. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlayViewController.h"
#import "PanoPlayViewController.h"
#import "rootVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (copy) NSDictionary *_launchOptions;
@property (assign) BOOL _isSavePrompts;
@property (assign) BOOL _isToLoadDeviceList;
@property (copy) NSString * _strMRServer;//
@property (assign) int _nMRPort;
@property (assign) int _nMROnlinePort;
@property (assign) int _nRegistClientThreadID;//是否使用转发模式
@property (assign) BOOL _isMRMode;//是否使用转发模式
@property (assign) int _nMRServerIndex;//是否使用转发模式
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) PlayViewController *PlayviewController;
@property (retain, nonatomic) PanoPlayViewController *panoPlayviewController;
@property (retain, nonatomic) rootVC *viewController;


@property (assign) int _nListViewPosition;//列表定位位置 add by luo 20141010

@property (assign) BOOL _isPlaying;//

@property (assign) BOOL _isAlarmSound;//
@property (assign) BOOL _isAlarmVibrate;//

@property (assign) BOOL _isPWDEnable;//
@property (assign) BOOL _isListModify;//

@property (assign) BOOL _isDevcieRegisted;//
@property (copy) NSString * _strPassword;//

@property (assign) double _nLastLoginTime;//
@property (assign) BOOL _isLimitOn;
@property (assign) int _nTryTimes;
@property (assign) BOOL _isAppLock;//
@property (assign) double _nLockTime;//

@property (assign) int _timeLeft;//

@property (assign) int _timerID;//

@property (assign) int _DBVer;//数据库创建的版本

@property (copy) NSString *_strClientID;//
@property (copy) NSString * _strPhoneNumber;//
@property (copy) NSString * _strAPIKey;//
@property (copy) NSString * _strSecretKey;//
@property (assign) long long _lChennelID;//
@property (copy) NSString * _strUserID;//
@property (readonly, assign) BOOL _isRecvMsg;//
@property (readonly, assign) BOOL _isPushOn;//


@end


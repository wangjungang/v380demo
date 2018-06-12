//
//  AppDelegate.m
//  test
//
//  Created by macrovideo on 13-6-17.
//  Copyright (c) 2013年 macrovideo. All rights reserved.
//

#import "AppDelegate.h"
#import "GTMBase64.h"
#import "FunctionTools.h"
#import "SVProgressHUD.h"

@implementation AppDelegate
@synthesize _isMRMode, _nMRServerIndex,_nListViewPosition;
@synthesize _isAlarmSound, _isAlarmVibrate;//
@synthesize _isPWDEnable;//
@synthesize _strPassword;//
@synthesize _nLastLoginTime;

@synthesize _isLimitOn;//
@synthesize _nTryTimes;
@synthesize _isAppLock;//
@synthesize _nLockTime;//
@synthesize _timeLeft;
@synthesize _timerID;
@synthesize _isPlaying;
@synthesize _isListModify;
@synthesize _isDevcieRegisted;
@synthesize _isRecvMsg;
@synthesize _DBVer;
@synthesize _nRegistClientThreadID;
//@synthesize _strMRServer, _nMRPort, _nMROnlinePort;
@synthesize _isSavePrompts;
//push
@synthesize _strClientID,  _strPhoneNumber,  _strAPIKey,  _strSecretKey,_strUserID;//
@synthesize _lChennelID;//
@synthesize _isToLoadDeviceList;
@synthesize _launchOptions;
@synthesize _isPushOn;


-(void)dealloc
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


void handle_PIPE(int sig){
}

-(void)addSIGPIPHandle{
    struct sigaction action;
    action.sa_handler = handle_PIPE;
    sigemptyset(&action.sa_mask);
    action.sa_flags = 0;
    sigaction(SIGPIPE, &action, NULL);
    
}

int _nDataWidth=640;
int _nDateHeight = 480;
int _nDataSize=0;
char *_pData=NULL;

-(int)getDataHeight{
    return _nDateHeight;
}
-(int)getDataWidth{
    return _nDataWidth;
}
-(int)getData:(char *)pData Max:(int)nMax{
    int nSize = 0;
    if (pData && nMax>=_nDataSize) {
        nSize=_nDataSize;
        memcpy(pData, _pData, nSize);
        
    }
    return nSize;
}

- (void)exitApplication {
    
    [UIView animateWithDuration:1.0f animations:^{
        self.window.alpha = 0;
        self.window.frame = CGRectMake(0, self.window.bounds.size.width, 0, 0);
    } completion:^(BOOL finish){
        exit(0);
    }];
    
}



- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}
//GesturePasswordDelegate
- (void)cancelView{
    _timerID++;
    _isLimitOn = NO;
    _nTryTimes = 5;
    
    [self updateUserSetting];
    [self exitApplication];
}
//add by luo 20140402
-(void)initPlayFaceData{}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [self set_launchOptions:launchOptions];
    
    
    [self addSIGPIPHandle];
    
    [self initPlayFaceData];
    
    _isAlarmVibrate = NO;
    _isAlarmSound = YES;
    _isPlaying = NO;
    
    [self loadUserSetting];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] ;
    [self.window makeKeyAndVisible];
    
    //    self.panoPlayviewController = [[PanoPlayViewController alloc] initWithNibName:@"PanoPlayViewController_iphone" bundle:nil];
    rootVC *vc = [[rootVC alloc]init];
    // 1.1 初始化
    // 1.2 把oneVC添加为UINavigationController的根控制器
//    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc];
    // 设置tabBar的标题
    nav1.title = @"首页";
    
    // 设置tabBar的图标
    // 设置navigationBar的标题
    vc.navigationItem.title = @"首页";
    // 设置背景色（这些操作可以交给每个单独子控制器去做）
    vc.view.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = nav1;
    
    return YES;
}


-(void)loadUserSetting{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSNumber *numberAlarmSound = [defaults objectForKey:@"isAlarmSound"];//
    NSNumber *numberAlarmVibrate = [defaults objectForKey:@"isAlarmVidrate"];//
    NSNumber *numberRecvMsg = [defaults objectForKey:@"isRecvMsg"];//
    
    NSNumber *numberPWDEnable = [defaults objectForKey:@"isGesturePWDEnable"];//
    NSNumber *numberLastLoginTime = [defaults objectForKey:@"lastLoginTime"];//
    
    NSNumber *numberLimitOn = [defaults objectForKey:@"isLimitOn"];//
    NSNumber *numberTryTimes = [defaults objectForKey:@"tryTimes"];//
    NSNumber *numberLock = [defaults objectForKey:@"isLock"];//
    NSNumber *numberLockTime = [defaults objectForKey:@"lockTime"];//
    
    NSNumber *numberDBVer = [defaults objectForKey:@"dbVer"];//
    NSNumber *numberPWDPrompts = [defaults objectForKey:@"save_prompts"];//
    
    if (numberPWDPrompts) {
        _isSavePrompts=[numberPWDPrompts boolValue];
    }
    
    _DBVer = [numberDBVer intValue];
    _isLimitOn = [numberLimitOn boolValue];
    _isAppLock = [numberLock boolValue];
    if (_isAppLock) {
        _isLimitOn = NO;
        _nTryTimes=5;
        _nLockTime=[numberLockTime doubleValue];
    }else {
        _nLockTime=0;
        if (_isLimitOn) {
            _nTryTimes=[numberTryTimes intValue];
        }else{
            _nTryTimes=5;
        }
        
    }
    
    if (numberLastLoginTime) {
        _nLastLoginTime = [numberLastLoginTime doubleValue];
    }else{
        _nLastLoginTime = 0;
    }
    
    if (numberPWDEnable) {
        _isPWDEnable = [numberPWDEnable boolValue];
    }else{
        _isPWDEnable = NO;
    }
    
    NSString *strPassword = [defaults objectForKey:@"gesturePWD"];
    
    [self set_strPassword:strPassword];
    
    if (numberAlarmVibrate) {
        _isAlarmVibrate = [numberAlarmVibrate boolValue];
    }else{
        _isAlarmVibrate = NO;
    }
    
    
    if (numberAlarmSound) {
        _isAlarmSound = [numberAlarmSound boolValue];
    }else{
        _isAlarmSound = NO;
    }
    
    if (numberRecvMsg) {
        _isRecvMsg = [numberRecvMsg boolValue];
    }else{
        _isRecvMsg= YES;
    }
}
-(void)updateUserSetting{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSNumber numberWithBool:_isRecvMsg] forKey:@"isRecvMsg"];
    
    [defaults setObject:[NSNumber numberWithBool:_isAlarmSound] forKey:@"isAlarmSound"];
    [defaults setObject:[NSNumber numberWithBool:_isAlarmVibrate] forKey:@"isAlarmVidrate"];
    
    [defaults setObject:[NSNumber numberWithBool:_isPWDEnable] forKey:@"isGesturePWDEnable"];
    
    [defaults setObject:[NSNumber numberWithDouble:_nLastLoginTime] forKey:@"lastLoginTime"];
    
    [defaults setObject:[NSNumber numberWithBool:_isLimitOn] forKey:@"isLimitOn"];
    [defaults setObject:[NSNumber numberWithBool:_isAppLock] forKey:@"isLock"];
    [defaults setObject:[NSNumber numberWithInt:_nTryTimes] forKey:@"tryTimes"];
    [defaults setObject:[NSNumber numberWithDouble:_nLockTime] forKey:@"lockTime"];
    
    [defaults setObject:_strPassword forKey:@"gesturePWD"];
    
    [defaults setObject:[NSNumber numberWithInt:_DBVer] forKey:@"dbVer"];
    
    [defaults setObject:[NSNumber numberWithBool:_isSavePrompts] forKey:@"save_prompts"];
    
    [defaults synchronize];
    
}


//
//       //禁止自动休眠可以通过这一句话搞定：
//　　[UIApplication sharedApplication].idleTimerDisabled=YES;
//　　//当然一定要慎用，记着退出程序时把自动休眠功能开启
//　　UIApplication sharedApplication].idleTimerDisabled=NO;
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    
    //    [self registDeviceToServer:NO];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ON_RESIGN_ACTIVE" object:nil];
    //    _nLastLoginTime =  CFAbsoluteTimeGetCurrent();
    [self updateUserSetting];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ON_BECOME_ACTIVE" object:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    if (!_isAppLock && _isPWDEnable) {
        _nLastLoginTime =0.0;
        [self updateUserSetting];
    }
}

@end

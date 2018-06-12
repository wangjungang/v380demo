//
//  AlarmPromptInfo.h
//  macroSEE
//
//  Created by macrovideo on 14-9-29.
//  Copyright (c) 2014年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmTimeModel.h"
@interface AlarmPromptInfo : NSObject

@property (copy) NSString *strSaveUsername;
@property (copy) NSString *strSavePassword;

@property (retain) NSDate *refreshTime;
@property (assign) int nResult;
@property (assign) int nServerID;
@property (assign) int nOPID;

@property (assign) BOOL hasSoundCtrl;
@property (assign) BOOL bSoundMainSwitch;
@property (assign) BOOL bAlarmAudioSwitch;
@property (assign) int nLanguage;

@property (assign) BOOL hasExternalIOCtrl;
@property (assign) int nIOMode;

@property (assign) BOOL hasAlarmCtrl;
@property (assign) BOOL bMotionAlarmSwitch;
@property (assign) BOOL bPRIAlarmSwitch;
@property (assign) BOOL bSmokeAlarmSwitch;
@property (assign) BOOL bMainAlarmSwitch;

//add by lusongbin 20170221
//add by lusongbin 报警时间 和区域 52时间区域使能（1byte）+53时间段数（1byte）+54时间段（（1+6）*3=21byte）+75报警区行数（1byte）+76报警区列数（1byte）+77报警区域（32byte）
//char bArea = 0;
//char nTimeCount = 0;
//char alarmTime_1[7] = {0};//54
//char alarmTime_2[7] = {0};//61
//char alarmTime_3[7] = {0};//68
//char nAlarmAreaLines = 0;
//char nAlarmAreaColumns = 0;
//char AlarmAreas[32] = {0};

@property(nonatomic,assign) BOOL canSetAlarmArea;
@property(nonatomic,assign) int AlarmTimeCount;
@property(nonatomic,copy) NSMutableArray *alarmTimeArr;
@property(nonatomic,assign) int AlarmAreaCount;
@property(nonatomic,assign) int AlarmAreaRow;
@property(nonatomic,assign) int AlarmAreaColumn;
@property(nonatomic,copy) NSMutableArray *alarmAreaArr;
@property(nonatomic,assign) BOOL isAlldayAlarm;

-(BOOL)checkSaveAcount:(int)nDevID usr:(NSString *)strSUsername pwd:(NSString *)strSPassword;

@end

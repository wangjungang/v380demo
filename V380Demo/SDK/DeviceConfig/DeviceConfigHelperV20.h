//
//  DeviceConfigHelperV20.h
//  NVSDK
//
//  Created by macrovideo on 27/06/2017.
//  Copyright © 2017 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "NVDevice.h"
#import "AccountInfo.h"
#import "RecordInfo.h"
#import "VersionInfo.h"
#import "DateTimeInfo.h"
#import "AlarmPromptInfo.h"
#import "NetworkInfo.h"
#import "DeviceUpdateInfo.h"
#import "IPConfigInfo.h"
#import "LoginHandle.h"


@interface DeviceConfigHelperV20 : NSObject
+(AccountInfo *)GetAccountInfo:(NVDevice *)device handle:(LoginHandle *)lHandle;
+(int)SetAcountInfo:(NVDevice *)device account:(AccountInfo *)account handle:(LoginHandle *)lHandle;

//
+(RecordInfo *)GetRecordInfo:(NVDevice *)device handle:(LoginHandle *)lHandle;
+(int)SetRecordInfo:(NVDevice *)device account:(RecordInfo *)info handle:(LoginHandle *)lHandle;
+(int)StartFormatSDCard:(NVDevice *)device handle:(LoginHandle *)lHandle;

//
+(VersionInfo *)GetVersionInfo:(NVDevice *)device handle:(LoginHandle *)lHandle;
+(DeviceUpdateInfo *)GetDeviceUpdateInfo:(NVDevice *)device handle:(LoginHandle *)lHandle;
+(int)StartDeviceUpdate:(NVDevice *)device handle:(LoginHandle *)lHandle;
//
+(DateTimeInfo *)GetDateTimeInfo:(NVDevice *)device handle:(LoginHandle *)lHandle;
+(int)SetDateTimeInfo:(NVDevice *)device account:(DateTimeInfo *)info handle:(LoginHandle *)lHandle;

//
+(AlarmPromptInfo *)GetAlarmPromptInfo:(NVDevice *)device handle:(LoginHandle *)lHandle;
+(int)SetAlarmPromptInfo:(NVDevice *)device account:(AlarmPromptInfo *)info handle:(LoginHandle *)lHandle;

+(int)SetOneKeyAlarm:(NVDevice *)device isAlarm:(BOOL)isAlarm handle:(LoginHandle *)lHandle;

//
+(NetworkInfo *)GetNetworkInfo:(NVDevice *)device handle:(LoginHandle *)lHandle;
+(int)SetNetworkInfo:(NVDevice *)device account:(NetworkInfo *)info handle:(LoginHandle *)lHandle;
+(IPConfigInfo *)GetIPConfigInfo:(NVDevice *)device handle:(LoginHandle *)lHandle;
+(int)SetIPConfigInfo:(NVDevice *)device info:(IPConfigInfo *)info handle:(LoginHandle *)lHandle;
+(NSArray *)GetDeviceVisibleWifiList:(NVDevice *)device handle:(LoginHandle *)lHandle;

+(void)cancelConfig;
@end

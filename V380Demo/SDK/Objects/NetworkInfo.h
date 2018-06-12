//
//  NetworkInfo.h
//  NVPlayer
//
//  Created by macrovideo on 13-9-4.
//  Copyright (c) 2013年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkInfo : NSObject 
@property (retain) NSDate *refreshTime;

@property (copy) NSString *strSaveUsername;
@property (copy) NSString *strSavePassword;
@property (assign) BOOL isMRMode;
@property (assign) int nServerInfoID;
@property (assign) int nDeviceAppVersion;
@property (assign) int nWifiMode;
@property (assign) BOOL isAPCheck;
@property (assign) BOOL isStationCheck;
@property (assign) int nResult;
@property (assign) int nOPID;
@property (assign) BOOL isStationWifiSet;
@property (copy) NSString *strAPName;
@property (copy) NSString *strAPPassword;

@property (copy) NSString *strStationName;
@property (copy) NSString *strStationPassword;

-(BOOL)checkSaveAcount:(int)nDevID usr:(NSString *)strSUsername pwd:(NSString *)strSPassword;
@end

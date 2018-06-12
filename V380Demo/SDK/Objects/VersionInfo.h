//
//  VersionInfo.h
//  macroSEE
//
//  Created by macrovideo on 14-3-7.
//  Copyright (c) 2014年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionInfo : NSObject

@property (copy) NSString *strSaveUsername;
@property (copy) NSString *strSavePassword;

@property (assign) int nVersionID;
@property (assign) BOOL hasUpdate;
@property (copy) NSString *strNewVersionName;

@property (retain) NSDate *refreshTime;
@property (assign) int nResult;
@property (assign) int nServerID;
@property (copy) NSString *strAPPVersionName;
@property (copy) NSString *strAPPVersionDate;
@property (copy) NSString *strKernalVersionName;
@property (copy) NSString *strKernalVersionDate;
@property (copy) NSString *strHardwareVersionName;
@property (copy) NSString *strHardwareVersionDate;

-(BOOL)checkSaveAcount:(int)nDevID usr:(NSString *)strSUsername pwd:(NSString *)strSPassword;

@end

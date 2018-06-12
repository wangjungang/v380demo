//
//  DeviceUpdateInfo.h
//  iCamSee
//
//  Created by macrovideo on 15/4/14.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUpdateInfo : NSObject 

@property (assign) int nResult;
@property (assign) int nServerID;


@property (assign) int nCurrentVersion;
@property (copy) NSString *strCurrentVersionName;
@property (copy) NSString *strCurrentVersionDate;

@property (assign) int nNewVersion;
@property (copy) NSString *strNewVersionName;
@property (copy) NSString *strNewVersionDate;


@end

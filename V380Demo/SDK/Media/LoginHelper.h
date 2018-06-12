//
//  LoginHelper.h
//  iCamSee
//
//  Created by macrovideo on 15/10/14.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginHandle.h"
#import "OnlineResult.h"

@class NVDevice;

@interface LoginHelper : NSObject
/*
 parm connectType:
 0 实时预览 
 1 本地录像回放  
 2 远程配置  
 3 其他
 */

+ (LoginHandle *)getDeviceParam:(NVDevice *)device withConnectType: (int8_t)connectType;

// + (LoginHandle *)getDeviceParam:(NVDevice *)device;

+ (LoginHandle *)getDeviceParam:(NVDevice *)device mrserver:(NSString *)strMRServer mrport:(int) nMRPort;

+ (OnlineResult *)getDeviceOnlineStat:(NVDevice *)device;

@end

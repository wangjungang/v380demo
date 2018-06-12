//
//  AlarmDevice.h
//  iCamSee
//
//  Created by macrovideo on 15/8/18.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmDevice : NSObject
@property (assign) int nIndex;
@property (assign) int nID;
@property (copy) NSString *strName;
@property (assign) int nAddress;
@property (assign) BOOL isAlarmEnable;
@property (assign) int nAlarmType;
@property (assign) int nAlarmLevel;
@property (assign) int nPTZXID;
@end

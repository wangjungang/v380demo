//
//  DateTimeInfo.h
//  NVPlayer
//
//  Created by macrovideo on 13-9-10.
//  Copyright (c) 2013年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeInfo : NSObject 

@property (assign) BOOL bTimeZoneEnable;
@property (assign) int nResult;
@property (assign) int nOPID;
@property (assign) int nDateType;
@property (assign) int nTimeZone;
@property (copy) NSString *strDateTime;

@end

//
//  AccountInfo.h
//  NVPlayer
//
//  Created by macrovideo on 13-9-4.
//  Copyright (c) 2013年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountInfo : NSObject

@property (assign) int nResult;
@property (assign) int nUID;
@property (retain) NSDate *refreshTime;
@property (copy) NSString *strUsername;
@property (copy) NSString *strPassword;
@end

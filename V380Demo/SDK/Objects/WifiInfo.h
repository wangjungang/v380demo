//
//  WifiInfo.h
//  NVPlayer
//
//  Created by macrovideo on 13-9-9.
//  Copyright (c) 2013年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiInfo : NSObject
{
    NSString *strBSSID;
    int nFrequency;
    int nSignalLevel;
    int nFlag;//0:开放 1:加密
    NSString *strSSID;
}

@property (assign) int nFrequency;
@property (assign) int nSignalLevel;
@property (assign) int nFlag;//0:开放 1:加密
@property (copy) NSString *strBSSID;
@property (copy) NSString *strSSID;
@end

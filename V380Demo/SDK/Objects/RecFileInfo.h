//
//  RecFileInfo.h
//  macroSEE
//
//  Created by macrovideo on 14-6-27.
//  Copyright (c) 2014年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecFileInfo : NSObject{
    int nFileID;
    int nFileSize;
    NSString *strFileName;
    int nStartHour;
    int nStartMin;
    int nStartSec;
    int nFileTimeLen;
}

@property (assign) int nFileID;
@property (assign) int nFileSize;
@property (copy) NSString *strFileName;
@property (assign) int nStartHour;
@property (assign) int nStartMin;
@property (assign) int nStartSec;
@property (assign) int nFileTimeLen;

@property (assign) int nDownloadStat;
@property (assign) float nDownloadProcess;
@end

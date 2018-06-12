//
//  RecordInfo.h
//  NVPlayer
//
//  Created by macrovideo on 13-9-4.
//  Copyright (c) 2013年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordInfo : NSObject 

@property (copy) NSString *strSaveUsername;
@property (copy) NSString *strSavePassword;

@property (retain) NSDate *refreshTime;

@property (assign) int nRecordStat;
@property (assign) BOOL isNewVersion;
@property (assign) BOOL isAudioEnable;
@property (assign) int nFrameSize;

@property (assign) BOOL is1080PEnable;
@property (assign) BOOL is960PEnable;
@property (assign) BOOL is720PEnable;
@property (assign) BOOL isD1Enable;
@property (assign) BOOL isVGAEnable;
@property (assign) BOOL isCIFEnable;
@property (assign) BOOL isQVGAEnable;


@property (assign) int nResult;
@property (assign) int nServerInfoID;
@property (assign) int nOPID;

@property (assign) int  nRecordFullDiskOP;
@property (assign) BOOL bAutoRecord;
@property (assign) BOOL bAlarmRecord;
@property (assign) int nDiskSize;
@property (assign) int nDiskRemainSize;

@property (assign) BOOL bCanFormat;

-(BOOL)checkSaveAcount:(int)nDevID usr:(NSString *)strSUsername pwd:(NSString *)strSPassword;
@end

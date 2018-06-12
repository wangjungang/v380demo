//
//  RecordFileHelper.h
//  iCamSee
//
//  Created by macrovideo on 15/10/23.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginHandle.h"
#import "NVDevice.h"
#import "RecFileSearchDelegate.h"

@interface RecordFileHelper : NSObject
+(BOOL)cancelOperation;//取消操作
//+(LoginHandle *)getRecordOPHandle:(NVDevice* )device;//获取操作句柄
+(LoginHandle *)getRecordOPHandle:(NVDevice *)device withConnectType:(UInt8)connectType;//获取操作句柄

+(int)getRecordFiles:(LoginHandle *)loginHandle receiver:(id<RecFileSearchDelegate>)delegate chn:(int)nSearchChn type:(int)nSearchType year:(short)nYear month:(short)nMonth day:(short)nDay SH:(short)nStartHour SM:(short)nStartMin SS:(short)nStartSec EH:(short)nEndHour EM:(short)nEndMin ES:(short)nEndSec;//获取操作句柄

@end

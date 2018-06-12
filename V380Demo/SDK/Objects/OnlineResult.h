//
//  OnlineResult.h
//  NVSDK
//
//  Created by macrovideo on 16/5/6.
//  Copyright © 2016年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlineResult : NSObject
@property (assign) int nResult;
/**
 *在线状态（-1：服务器出错 1：在线 0：离线 10：未知）
 */
@property (assign) int nOnlineStat;
/**
 *布撤防状态（0：未知 1：撤防状态 2：布防状态）
 */
@property (assign) int nAlarmStat;
/**
 *设备升级状态 （0 未知 1 不升级 2需要提示升级）
 */
@property(nonatomic,assign) int DeviceSoftwareUpdateStatu;
@end

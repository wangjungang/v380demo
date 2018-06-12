//
//  DeviceScanner.h
//  iCamSee
//
//  Created by macrovideo on 15/10/19.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceScanReceiverDelegate.h"

@interface DeviceScanner : NSObject

+(NSArray *)getLocalDeviceFromLan;
+(int)getLocalDeviceFromLanWithConfigID:(int)nConfigID receiver:(id<DeviceScanReceiverDelegate>)receiver;
+(void)stopLocalDeviceFromLanWithConfigID;
+(void)reset;
@end

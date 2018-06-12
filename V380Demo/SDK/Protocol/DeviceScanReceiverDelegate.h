//
//  DeviceScanReceiverDelegate.h
//  iCamSee
//
//  Created by macrovideo on 15/12/23.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@protocol DeviceScanReceiverDelegate <NSObject>
-(void)onDeviceReceive:(id)device;
@end

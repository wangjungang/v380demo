//
//  PlaybackDelegate.h
//  iCamSee
//
//  Created by macrovideo on 15/10/14.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlaybackDelegate <NSObject>
-(void)onProgressChange:(int) nProgress timeIndexID:(int)nTimeIndexID;//回放进度改变事件
@end
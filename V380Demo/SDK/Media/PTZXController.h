//
//  PTZXController.h
//  iCamSee
//
//  Created by macrovideo on 15/12/21.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginHandle.h"

@interface PTZXController : NSObject
+(int)setPTZXPoint:(LoginHandle *)lHandle id:(int)nPTZXID action:(int) nPTZXAction;
@end

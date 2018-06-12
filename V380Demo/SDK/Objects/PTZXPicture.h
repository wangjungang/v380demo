//
//  PTZXPicture.h
//  iCamSee
//
//  Created by macrovideo on 15/6/30.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PTZXPicture : NSObject
@property (assign) int nID;
@property (assign) int nDevID;
@property (assign) int nPTZXID;
@property (retain) UIImage *imageData;
@end

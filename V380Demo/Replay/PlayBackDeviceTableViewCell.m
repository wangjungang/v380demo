//
//  PlayBackDeviceTableViewCell.m
//  iCamSee
//
//  Created by macrovideo on 15/1/21.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import "PlayBackDeviceTableViewCell.h"
#import "FunctionTools.h"
#import "AppDelegate.h"
#import "NVDevice.h"

#define IS_USER_LOGIN ([((AppDelegate *)[UIApplication sharedApplication].delegate) isUserLogin])

@implementation PlayBackDeviceTableViewCell

@synthesize vContainer, lblInfo, btnFace, btnSelect;

- (void)setLoginInfo:(NVDevice *)info {

    [info retain];
    
    if (info.strName.length > 0) {
        
        [lblInfo setText:info.strName];
        
    } else {
        
        [lblInfo setText:@(info.NDevID).stringValue];
    }
    
    if (info.imageFace) {
        
        [btnFace setImage:info.imageFace];
        
    } else {
        
        [btnFace setImage:[UIImage imageNamed:@"deviceFace.png"]];
    }
    
    if (info.isSelect) {
        
        [btnSelect setImage:[UIImage imageNamed:@"btn_setting_checked.png"]];
        
    } else {
        
        [btnSelect setImage:[UIImage imageNamed:@"btn_setting_uncheck.png"]];
    }
    
    [info release];
}

-(void)initInterface:(CGRect)frame{

    self.frame = frame;
    
    CGRect rect = frame;
    
    rect.size.width = CGRectGetWidth(rect);
    rect.size.height = CGRectGetHeight(rect);
    rect.origin.x = 0;
    rect.origin.y = 0;
    vContainer.frame = rect;
    [self addSubview:vContainer];
    
    rect.size.width = CGRectGetHeight(vContainer.frame) * 1.25;
    rect.size.height = CGRectGetHeight(vContainer.frame);
    rect.origin.x = 10;
    rect.origin.y = 0;
    btnFace.frame = rect;
    
    rect.size.width = 40;
    rect.size.height = 40;
    rect.origin.x = CGRectGetWidth(vContainer.frame) - CGRectGetWidth(rect) - 15;
    rect.origin.y = (CGRectGetHeight(vContainer.frame) - CGRectGetHeight(rect)) * 0.5;
    btnSelect.frame = rect;
    
    rect.size.width = CGRectGetMinX(btnSelect.frame) - CGRectGetMaxX(btnFace.frame) - 5;
    rect.size.height = CGRectGetHeight(vContainer.frame);
    rect.origin.x = CGRectGetMaxX(btnFace.frame) + 5;
    rect.origin.y = 0;
    lblInfo.frame = rect;
}


-(void)dealloc{
    [vContainer release];
    [lblInfo release];
    [btnFace release];
    [btnSelect release];
    [super dealloc];
}


@end

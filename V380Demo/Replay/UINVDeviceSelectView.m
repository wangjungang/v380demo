//
//  UINVDeviceSelectView.m
//  iCamSee
//
//  Created by macrovideo on 15/3/13.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import "UINVDeviceSelectView.h"
@interface UINVDeviceSelectView ()
@end

@implementation UINVDeviceSelectView
@synthesize lblTitle, btnAction, imgViewBg;

-(id)init{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        lblTitle=[[UILabel alloc] init];
        btnAction=[[UINVGoButton alloc] init];
//        imgViewBg=[[UIImageView alloc] init];
        
        [lblTitle setTextColor:[UIColor lightGrayColor]];
        [lblTitle setFont: [UIFont systemFontOfSize:18]];
        [lblTitle setTextAlignment:NSTextAlignmentRight];
        lblTitle.adjustsFontSizeToFitWidth = YES;
        
        [btnAction.titleLabel setTextColor:[UIColor blackColor]];
        [btnAction.titleLabel setFont: [UIFont systemFontOfSize:18]];
        [btnAction.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    return self;
}

-(void)setTitle:(NSString *)strTitle{
    
    [lblTitle setText:strTitle];
}

-(void)setContent:(NSString *)strContent{
  
    [btnAction setTitle:strContent forState:UIControlStateNormal];
    [btnAction setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnAction setTitleColor:[UIColor colorWithRed:0.247 green:0.467 blue:0.896 alpha:1] forState:UIControlStateHighlighted];
}
 
-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    self.layer.cornerRadius = 5;
    
    CGRect rect = frame;
//    rect.origin.x =0;
//    rect.origin.y =0;
//    [imgViewBg setFrame:rect];
//    [self addSubview:imgViewBg];
//    [imgViewBg setBackgroundColor:[UIColor whiteColor]];
//    [imgViewBg setAlpha:0.5];
    
    rect = lblTitle.frame;
    rect.size.height = 40;
    if (frame.size.height<40) {
        
        rect.size.height = frame.size.height;
    }
    rect.size.width = frame.size.width*0.35;
    if (rect.size.width>160 || rect.size.width<60) {
        if (rect.size.width>160) {
            rect.size.width=160;
        }else{
            rect.size.width=60;
        }
    }
    rect.origin.x = 0;
    rect.origin.y = (frame.size.height-rect.size.height)/2;
    [lblTitle setFrame:rect];
    [self addSubview:lblTitle];
 
    rect = lblTitle.frame;
    rect.origin.x = CGRectGetMaxX(lblTitle.frame) + 20;
    rect.size.width = frame.size.width - rect.origin.x;
    [btnAction setFrame:rect];
    [self addSubview:btnAction];
    
    
}


-(void)dealloc{
//    [imgViewBg release];
    [lblTitle release];
    [btnAction release];
    [super dealloc];
}


@end


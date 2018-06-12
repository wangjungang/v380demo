//
//  PlaybackItemView.m
//  iCamSee
//
//  Created by macrovideo on 15/1/21.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import "UINVPlaybackItemView.h"

@implementation UINVPlaybackItemView

@synthesize lblTitle, btnAction;

- (id)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;

        lblTitle=[[UILabel alloc] init];
        btnAction=[[UIButton alloc]init];
      
        [lblTitle setTextColor:[UIColor lightGrayColor]];
        [lblTitle setFont: [UIFont systemFontOfSize:18]];
        [lblTitle setTextAlignment:NSTextAlignmentRight];
        
        [btnAction.titleLabel setTextColor:[UIColor blackColor]];
        [btnAction.titleLabel setFont: [UIFont systemFontOfSize:18]];
        [btnAction.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        lblTitle.adjustsFontSizeToFitWidth = true;
    }
    
    return self;
}

- (void)setTitle:(NSString *)strTitle {
    
    [lblTitle setText:strTitle];
}

- (void)setContent:(NSString *)strContent {
    
    [btnAction setTitle:strContent forState:UIControlStateNormal];
    [btnAction setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
 
- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    CGRect rect = frame;
    
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

- (void)dealloc {
    [lblTitle release];
    [btnAction release];
    [super dealloc];
}

@end

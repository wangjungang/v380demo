//
//  UINVMiniImageButton.m
//  iCamSee
//
//  Created by macrovideo on 15/2/6.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import "UINVMiniImageButton.h"

@implementation UINVMiniImageButton

-(void)layoutSubviews{
    [super layoutSubviews];
    
    // Center image
    CGRect newFrame = self.frame;
    newFrame.size.height= self.frame.size.height*0.7;
    newFrame.size.width = newFrame.size.height;
    newFrame.origin.x = (self.frame.size.width-newFrame.size.width)/2;
    newFrame.origin.y = 0;
    [self.imageView setFrame:newFrame];
    
    newFrame.size.height = self.frame.size.height - self.imageView.frame.size.height;
    newFrame.origin.y = CGRectGetMaxY(self.imageView.frame) ;
    [self.titleLabel setFrame:newFrame];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleLabel setFont: [UIFont systemFontOfSize:13]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
 
}

@end

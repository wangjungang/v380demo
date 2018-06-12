//
//  UINVGoButton.m
//  iCamSee
//
//  Created by macrovideo on 15/2/13.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import "UINVGoButton.h"

@implementation UINVGoButton

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect newFrame = self.frame;
    newFrame.size.height = newFrame.size.height*0.8;
    newFrame.size.width = newFrame.size.height;
    newFrame.origin.y = (self.frame.size.height-newFrame.size.height)/2;
    newFrame.origin.x = self.frame.size.width-newFrame.size.width-newFrame.origin.y;
    
    [self.imageView setFrame:newFrame];
    
    newFrame = self.frame;
    newFrame.origin.x=0;
    newFrame.size.width =self.imageView.frame.origin.x -newFrame.origin.x;
    newFrame.origin.y = (self.frame.size.height-newFrame.size.height)/2;
    [self.titleLabel setFrame:newFrame];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
 
}

@end

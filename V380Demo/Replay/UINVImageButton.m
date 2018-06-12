//
//  UINVImageButton.m
//  iCamSee
//
//  Created by macrovideo on 15/1/28.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import "UINVImageButton.h"

@implementation UINVImageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
 
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect newFrame = self.frame;
    newFrame.size.height = newFrame.size.height*0.8;
    newFrame.size.width = newFrame.size.width*0.35;
    if (newFrame.size.height>newFrame.size.width) {
        newFrame.size.height=newFrame.size.width;
    }else{
        newFrame.size.width = newFrame.size.height;
    }
    newFrame.origin.x = 0;
    newFrame.origin.y = (self.frame.size.height-newFrame.size.height)/2;
    [self.imageView setFrame:newFrame];
    
    newFrame = self.frame;
    newFrame.origin.x=self.imageView.frame.origin.x + self.imageView.frame.size.width+2;
    newFrame.size.width =self.frame.size.width -newFrame.origin.x;
    newFrame.origin.y = (self.frame.size.height-newFrame.size.height)/2;
    [self.titleLabel setFrame:newFrame];
    
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    /*
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = UITextAlignmentCenter;
     */
}
@end

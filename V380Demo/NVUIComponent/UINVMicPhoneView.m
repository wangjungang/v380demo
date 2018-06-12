//
//  UINVMicPhoneView.m
//  iCamSee
//
//  Created by macrovideo on 15/2/6.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import "UINVMicPhoneView.h"

@implementation UINVMicPhoneView

-(instancetype)init{
    self=[super init];
    if (self) {
        imgFace = [[UIImageView alloc] init];
        lblTitle=[[UILabel alloc] init];
        [lblTitle setTextColor:[UIColor lightGrayColor]];
        
    }
    return self;
    
}
-(void)setTitleColor:(UIColor *)textColor{
    
        [lblTitle setTextColor:textColor];
}
-(void)setText:(NSString *)strText{
    if (lblTitle==nil) {
        lblTitle=[[UILabel alloc] init];
    }
    [lblTitle setText:strText];
}
-(void)setImage:(UIImage *)image{
    if (imgFace==nil) {
        imgFace = [[UIImageView alloc] init];
    }
    [imgFace setImage:image];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect newFrame = frame;
    newFrame.size.height = newFrame.size.height*0.15;
    newFrame.origin.x=(self.frame.size.width-newFrame.size.width)/2;
    newFrame.origin.y = self.frame.size.height-newFrame.size.height;
    [lblTitle setFrame:newFrame];
    lblTitle.textAlignment= UITextAlignmentCenter;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    [lblTitle setFont:[UIFont boldSystemFontOfSize:10]];
//    [lblTitle setTextColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1]];
//    [lblTitle setTextColor:[UIColor lightGrayColor]];
    
    newFrame = self.frame;
    newFrame.size.height = self.frame.size.height - lblTitle.frame.size.height;
    if(newFrame.size.width<newFrame.size.height){
        newFrame.size.height = newFrame.size.width*0.9999999;
    }else{
        newFrame.size.height = newFrame.size.height*0.9999999;
    }
    newFrame.size.width = newFrame.size.height;
    newFrame.origin.x = (self.frame.size.width-newFrame.size.width)/2;
    newFrame.origin.y = (lblTitle.frame.origin.y-newFrame.size.height)/2;
    [imgFace setFrame:newFrame];

    [self addSubview:imgFace];
    [self addSubview:lblTitle];
}
-(void)dealloc{
    [imgFace release];
    [lblTitle release];
    [super dealloc];
}
@end

//
//  UINVMicPhoneView.h
//  iCamSee
//
//  Created by macrovideo on 15/2/6.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINVMicPhoneView : UIView{
    UIImageView *imgFace;
    UILabel *lblTitle;
}

-(void)setText:(NSString *)strText;
-(void)setImage:(UIImage *)image;
-(void)setTitleColor:(UIColor *)textColor;
@end

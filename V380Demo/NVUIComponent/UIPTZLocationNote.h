//
//  UIPTZLocationNote.h
//  iCamSee
//
//  Created by macrovideo on 15/6/10.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPTZLocationNote : UIView{
    UIButton *btnSetting;
    UIButton *btnLocation;
    UILabel *lblID;
    UILabel *lblTitle;
    UIImageView *ivFace;
    
    UIImageView *ivSpliter;
}

-(void)setFace:(UIImage *)image;
-(void)setTitle:(NSString *)strTitle;
-(void)setID:(int)nID;


- (void)setSettingTarget:(id)target action:(SEL)action;
- (void)setLocationTarget:(id)target action:(SEL)action;
@end

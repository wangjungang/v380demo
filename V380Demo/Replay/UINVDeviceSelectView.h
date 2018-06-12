//
//  UINVDeviceSelectView.h
//  iCamSee
//
//  Created by macrovideo on 15/3/13.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINVGoButton.h"

@interface UINVDeviceSelectView : UIView

@property (nonatomic, retain) IBOutlet UILabel *lblTitle; 
@property (nonatomic, retain) IBOutlet UINVGoButton *btnAction;
@property (nonatomic, retain) IBOutlet UIImageView *imgViewBg;

 
-(void)setTitle:(NSString *)strTitle;
-(void)setContent:(NSString *)strContent;
@end

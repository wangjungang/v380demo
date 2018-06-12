//
//  PlayBackDeviceTableViewCell.h
//  iCamSee
//
//  Created by macrovideo on 15/1/21.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayBackDeviceTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIView *vContainer;
@property (nonatomic, retain) IBOutlet UILabel *lblInfo;
@property (nonatomic, retain) IBOutlet UIImageView *btnFace;
@property (nonatomic, retain) IBOutlet UIImageView *btnSelect;
@property (nonatomic, retain) IBOutlet UIImageView *ivCellBg;

-(void)initInterface:(CGRect)frame;
-(void)setLoginInfo:(id)info;
@end

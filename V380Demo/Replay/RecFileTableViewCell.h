//
//  RecFileTableViewCell.h
//  macroSEE
//
//  Created by macrovideo on 14-6-27.
//  Copyright (c) 2014年 cctv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecFileTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIView *vContainer;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblInfo;
@property (retain, nonatomic) IBOutlet UIProgressView *ProgressView;
@property (retain, nonatomic) IBOutlet UIButton *btnDownloadTF;

-(void)initInterface:(CGRect)frame;
@end

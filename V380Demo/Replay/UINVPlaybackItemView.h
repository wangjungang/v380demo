//
//  PlaybackItemView.h
//  iCamSee
//
//  Created by macrovideo on 15/1/21.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINVPlaybackItemView : UIView

@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
 
@property (nonatomic, retain) IBOutlet UIButton *btnAction;

- (void)setTitle:(NSString *)strTitle;

- (void)setContent:(NSString *)strContent;

@end

//
//  UIPTZLocationNote.m
//  iCamSee
//
//  Created by macrovideo on 15/6/10.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import "UIPTZLocationNote.h"

@implementation UIPTZLocationNote

-(void)setTag:(NSInteger)tag{
//    NSLog(@"setTag %i",tag);//add for test
    
    btnSetting.tag=tag;
    btnLocation.tag=tag;
}
-(void)dealloc{
    [btnSetting release];
    [btnLocation release];
    [lblTitle release];
    [ivFace release];
    [ivSpliter release];
    [lblID release];
    [super dealloc];
}
-(instancetype)init{
    self = [super init];
    if (self) {
        btnSetting =[[UIButton alloc] init];
        btnLocation =[[UIButton alloc] init];
        lblTitle =[[UILabel alloc] init];
        ivFace =[[UIImageView alloc] init];
        ivSpliter =[[UIImageView alloc] init];
        lblID=[[UILabel alloc] init];
        [ivSpliter setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
//        [btnSetting setImage:[UIImage imageNamed:@"ptzx_setting_pressed.png"] forState:UIControlStateNormal];
        
        [btnSetting setTitle:NSLocalizedString(@"btnPTZXSet", @"Set") forState:UIControlStateNormal];
//        btnSetting.layer.borderWidth = 1.5;
//        btnSetting.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
//        btnSetting.layer.cornerRadius =2;
//        btnSetting.backgroundColor = [UIColor lightGrayColor];
        [btnSetting setBackgroundImage:[UIImage imageNamed:@"ptzxset_bg"] forState:UIControlStateNormal];
        [btnSetting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [ivFace setImage:[UIImage imageNamed:@"ptzx_bg.png"]];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [lblTitle setHidden:NO];
        [lblTitle setText:NSLocalizedString(@"btnPTZXCall", @"Call")];
       
//        ivFace.backgroundColor = [UIColor clearColor];
//        ivFace.layer.cornerRadius = 5;
//        ivFace.layer.borderWidth = 1.5;
//        ivFace.layer.borderColor = [UIColor colorWithRed:0.234 green:0.476 blue:0.847 alpha:1].CGColor;
        
//        lblTitle.layer.cornerRadius = 5;
//        lblTitle.backgroundColor = [UIColor clearColor];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblID setTextColor:[UIColor greenColor]];
        [lblID setTextAlignment:NSTextAlignmentCenter];
        
    }
    return self;
}

- (void)setSettingTarget:(id)target action:(SEL)action{
    [btnSetting addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setLocationTarget:(id)target action:(SEL)action{

    [btnLocation addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
-(void)setFace:(UIImage *)image{
    if (image) {
        [ivFace setImage:image];
        [lblTitle setHidden:YES];
    }else{
        [ivFace setImage:[UIImage imageNamed:@"ptzx_bg.png"]];
        [lblTitle setHidden:NO];
    }
  
}


-(void)setTitle:(NSString *)strTitle{
//    [lblTitle setText:strTitle];
}

-(void)setID:(int)nID{
    [lblID setText:[NSString stringWithFormat:@"%d", nID]];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect rect = frame;
    rect.size.height =frame.size.height *0.95;
    rect.size.width =rect.size.height*1.5;
    rect.origin.y =(frame.size.height-rect.size.height)/2;
    rect.origin.x =2;
    [ivFace setFrame:rect];
    
    
    rect = ivFace.frame;
    rect.size.width = rect.size.width*0.98;
    rect.size.height = rect.size.height*0.98;
    rect.origin.x =ivFace.frame.origin.x+(ivFace.frame.size.width-rect.size.width)/2;
    rect.origin.y =ivFace.frame.origin.y+(ivFace.frame.size.height-rect.size.height)/2;
    [lblTitle setFrame:rect];
    
    rect = frame;
    rect.size.height =frame.size.height *0.75;
    if (rect.size.height>50) {
        rect.size.height=50;
    }
    rect.size.width =rect.size.height;
    rect.origin.y =(frame.size.height-rect.size.height)/2;
    rect.origin.x =frame.size.width-rect.size.width * 1.5;
    [btnSetting setFrame:rect];
    
   
    
    rect = frame;
    rect.origin.x =0;
    rect.origin.y = 0;
    rect.size.width =btnSetting.frame.origin.x - rect.origin.x;
    [btnLocation setFrame:rect];
    
    rect=frame;
    rect.size.width = frame.size.width;
    rect.size.height = 1;
    rect.origin.x = (frame.size.width-rect.size.width)/2;
    rect.origin.y=frame.size.height - rect.size.height;
    [ivSpliter setFrame:rect];
    
    rect = ivFace.frame;
    rect.size.width =ivFace.frame.size.width/4;
    rect.size.height =ivFace.frame.size.height/4;
    [lblID setFrame:rect];
    
    
    [self addSubview:ivFace];
    [self addSubview:lblTitle];
    [self addSubview:btnSetting];
    [self addSubview:btnLocation];
    [self addSubview:ivSpliter];
    [self addSubview:lblID];
    
}

/*
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect rect = frame;
    rect.size.height =frame.size.height *0.95;
    rect.size.width =rect.size.height;
    rect.origin.y =(frame.size.height-rect.size.height)/2;
    rect.origin.x =2;
    [ivFace setFrame:rect];
    
    rect = frame;
    rect.size.height =frame.size.height *0.9;
    rect.size.width =rect.size.height;
    rect.origin.y =(frame.size.height-rect.size.height)/2;
    rect.origin.x =frame.size.width-rect.size.width;
    [btnSetting setFrame:rect];
    
    rect = ivFace.frame;
    rect.origin.x =ivFace.frame.origin.x+ivFace.frame.size.width;
    rect.size.width =btnSetting.frame.origin.x - rect.origin.x;
    rect.origin.y =(frame.size.height-rect.size.height)/2;
    [lblTitle setFrame:rect];
    
    rect = frame;
    rect.origin.x =0;
    rect.origin.y = 0;
    rect.size.width =btnSetting.frame.origin.x - rect.origin.x;
    [btnLocation setFrame:rect];
    
    rect=frame;
    rect.size.width = frame.size.width*0.95;
    rect.size.height = 1;
    rect.origin.x = (frame.size.width-rect.size.width)/2;
    rect.origin.y=frame.size.height - rect.size.height;
    [ivSpliter setFrame:rect];
    
    [self addSubview:ivFace];
    [self addSubview:lblTitle];
    [self addSubview:btnSetting];
    [self addSubview:btnLocation];
    [self addSubview:ivSpliter];

}
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

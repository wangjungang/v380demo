//
//  RecFileTableViewCell.m
//  macroSEE
//
//  Created by macrovideo on 14-6-27.
//  Copyright (c) 2014年 cctv. All rights reserved.
//

#import "RecFileTableViewCell.h"

@implementation RecFileTableViewCell
@synthesize lblName, lblInfo, vContainer;


-(void)initInterface:(CGRect)frame{
    lblName.adjustsFontSizeToFitWidth=YES;
    CGRect rec =  _btnDownloadTF.frame;
    rec.size.height = frame.size.height *0.6;
    rec.size.width = rec.size.height * 1.5;
    rec.origin.y = (frame.size.height - rec.size.height) * 0.5;
    rec.origin.x = frame.size.width - rec.size.width;
    _btnDownloadTF.frame = rec;
    
    if (frame.size.height<30) {
        [lblInfo setHidden:YES];
        
        CGRect rect=frame;
        rect.size.width = frame.size.width*0.9-_btnDownloadTF.frame.size.width;
        rect.size.height = frame.size.height;
        rect.origin.x = 15;
        [lblName setFrame:rect];
        [self addSubview:lblName];

        
        
    }else{
        [lblInfo setHidden:NO];
        
        CGRect rect=frame;
        rect.size.width = frame.size.width*0.9-_btnDownloadTF.frame.size.width;
        rect.size.height = frame.size.height*0.65;
        rect.origin.x = 15;
        rect.origin.y = 0;
        [lblName setFrame:rect];
        [self addSubview:lblName];
        
        
        rect=lblName.frame;
        rect.size.height = frame.size.height - lblName.frame.size.height;
        rect.origin.y = lblName.frame.origin.y+lblName.frame.size.height;
        [lblInfo setFrame:rect];
        [self addSubview:lblInfo];

        rect.origin.y = CGRectGetMaxY(lblInfo.frame) - 2;
        rect.size.width = frame.size.width - 30;
        _ProgressView.frame = rect;
        [self addSubview:_ProgressView];
        
    }
    [self addSubview:_btnDownloadTF];
}


-(void)dealloc{
    [vContainer release];
    [lblName release];
    [lblInfo release];
    [_btnDownloadTF release];
    [_ProgressView release];
    [super dealloc];
}
@end

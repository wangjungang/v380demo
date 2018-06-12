//
//  StringToSoundMaker.h
//  iCamSee
//
//  Created by macrovideo on 15/3/25.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVOPALSoundPlayer.h"

@interface StringToSoundMaker : NSObject

@property (retain) NVOPALSoundPlayer *soundPlayer;

-(BOOL)PlayStringAsSound:(NSString *)strContent;
-(BOOL)StopPlayStringAsSound;

-(BOOL)Finish;
-(BOOL)PutData:(char *)pData size:(int) nSize;
@end

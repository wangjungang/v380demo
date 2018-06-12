//
//  ZoneInfo.h
//  iCamSee
//
//  Created by macrovideo on 15/12/3.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoneInfo : NSObject
@property (copy) NSString *strTitle;
@property (copy) NSString *strDesc;

-(id)initWithTitle:(NSString *)strT desc:(NSString *)strD;
@end

//
//  AlarmImageResult.h
//  iCamSee
//
//  Created by macrovideo on 16/02/2017.
//  Copyright © 2017 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmImageResult : NSObject
@property (assign) int nResult;
@property (assign) int nPCount;
@property (retain) NSData *imageData;
@property (retain) NSArray *pArray;

@end

//
//  IPConfigInfo.h
//  iCamSee
//
//  Created by macrovideo on 16/3/21.
//  Copyright © 2016年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPConfigInfo : NSObject
@property (assign) int nResult;
@property (assign) BOOL isDisableDHCP;
@property (copy) NSString *strIP;
@property (copy) NSString *strMask;
@property (copy) NSString *strGateway;
@property (copy) NSString *strDNS1;
@property (copy) NSString *strDNS2;
@end

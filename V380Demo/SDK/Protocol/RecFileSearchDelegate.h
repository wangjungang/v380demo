//
//  RecFileSearchDelegate.h
//  iCamSee
//
//  Created by macrovideo on 15/10/23.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RecFileSearchDelegate <NSObject>
-(void)onReceiveFile:(int)nRecvTotalCount size:(int)nFileCount list:(NSArray *)fileList;//搜索录像文件接收函数
@end
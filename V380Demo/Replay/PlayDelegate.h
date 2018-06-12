//
//  PlayProtocol.h
//  macroSEE
//
//  Created by macrovideo on 14-3-7.
//  Copyright (c) 2014年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayDelegate <NSObject>

-(void)PlayDelegateStartPlay:(id)loginResult;

-(void)PlayDelegateStopPlay;

-(void)PlayFileDelegateStartPlay:(id)param index:(int)nIndex ip:(NSString *)strIP port:(int) nPort domain:(NSString *)strDomain ismr:(BOOL)isMR mrserver:(NSString *)strMrServer mrport:(int)nMrPort handle:(long) lHandle;

-(void)PlayFileDelegateStopPlay;

-(void)ShowAlarmMessageList:(id)param flag:(BOOL)flag;
-(void)QuitAlarmMessageList:(id)param;

-(void)ShowDeviceManagerViewIndex:(int) nIndex param:(id)param;
-(void)ShowQRView;

-(void)FinishDeviceManagementResult:(int)nResult param:(id)param;

-(void)ShowDeviceConfig:(id)param;
-(void)FinishShowDeviceConfig;

-(void)hideTabView:(int)nIndex;
-(void)ShowTabView:(int)nIndex;

-(void)ShowAccountConfig:(id)param index:(int)nIndex;

@end

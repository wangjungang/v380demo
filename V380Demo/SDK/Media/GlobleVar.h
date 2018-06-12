//
//  GlobleVar.h
//  iCamSee
//
//  Created by macrovideo on 15/10/13.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCMDataPlayer.h"

@interface GlobleVar : NSObject
+(id)getUsingMRServer;
+(void)setUsingMRServer:(NSString *)strMRServer;
+(unsigned int)getUsingMRPort;
+(void)setUsingMRPort:(unsigned int)nMRPort;

+(unsigned int)getUsingOnlineMRPort;

+(id)getSoundPlayer;
+(void)setSoundPlayer:(id)alSoundPlayer;

+(void)setMRMode:(BOOL)isMRMode;
+(BOOL)isMRMode;

+(void)setZoneIndex:(int)nIndex;
+(int)getZoneIndex;

+(void)saveUsingZoneIndex;
+(BOOL)isUsingZoneChange;


+(id)getUsingPanoMRServer;
+(void)setUsingPanoMRServer:(NSString *)strMRServer;

+(unsigned int)getUsingPanoMRPort;
+(void)setUsingPanoMRPort:(unsigned int)nMRPort;

//add  by lusonbin 20170323
+(void)setNormalIPs:(NSArray*)ipArray;
+(NSArray*)getNormalIPs;

+(void)setPanoIPs:(NSArray*)ipArray;
+(NSArray*)getPanoIPs;

+(BOOL)isTogetDispaIP;
+(void)setIsToGetDispaIP:(BOOL)toget;

+(void)setshowingDeviceList:(NSArray*)serverlist;
+(NSArray *)getShowingDeviceList;

+(void)setLastGetIpTime ;
+(NSDate*)getLastGetIpTime;
+(BOOL)isOverTime;

+(void)setDispaIPusername:(NSString*)user;
+(NSString *)getDispaIPusername;

//end add  by lusonbin 20170323

@end

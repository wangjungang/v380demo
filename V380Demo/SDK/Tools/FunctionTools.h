//
//  FunctionTools.h
//  rtsp
//
//  Created by luo king on 12-3-28.
//  Copyright (c) 2012年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NVDevice.h"

#define ISCHINESE ([[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] hasPrefix:@"zh-"])

@interface FunctionTools : NSObject
+(int)findCodecIDByCodecName:(NSString *)codecName;
+(NSString*)getIpAddressForHost:(NSString*)theHost;
+(BOOL)isWithDot:(NSString *)ip;
+(NSString *)getMRServer:(int )nIndex;
+(unsigned int)getMRPort:(int )nIndex;
+(unsigned int)getMROnlinePort;

+(NSString *)getMRServerDomain;
+(NSString *)getMRServerDomainWithDeviceID:(int)deviceID;//add by lusongbin 20161109

+(NSString *)getMRServerIP:(int)nIndex;
+(NSString *)getMRServerIP:(int)nIndex deviceID:(int)deviceID;//add by lusongbin 20161109

+(int)getRandomNumber:(int)from to:(int)to;
///
+(NSString *)md5:(NSString *)str;

+(BOOL)isFileExit:(NSString *)name;
+(BOOL)isPhoneNumber:(NSString *)number;
+(BOOL)isEmail:(NSString *)email;
+(BOOL)isIP:(NSString *)strIP;
+(BOOL)isLanIP:(NSString *)strIP;
+(BOOL)isNumber:(NSString *)strParam;

+(NSString*) urlEncode:(NSString*) unencodeString;

+(BOOL)isNetworkActive;

+(BOOL)isPiont:(CGPoint) piont inArea:(CGRect)area;//判断点piont 是否落在area内
+(BOOL)isPiont:(CGPoint) piont inSize:(CGSize)size;//判断点piont 是否落在size内
+(void)showAlertTitle:(NSString *)titel withMessage: (NSString *)message;

+(NSString *)getPreviewServer:(int )nIndex;
+(NSString *)getAlarmServer:(int )nIndex;
+(NSString *)getAlarmRecServer:(int )nIndex;
+(unsigned int)getAlarmPort:(int )nIndex;

+(long long)longLongFromDate:(NSDate*)date;//add by luo 20141114

+(BOOL)SaveImage:(UIImage *)image toPath:(NSString *)path;//add by luo 20141120

+(id)decodeLoginInfoFromBytes:(char *)data;


+ (UIImage *) gradientImageWithSize:(CGSize) size
                          locations:(const CGFloat []) locations
                         components:(const CGFloat []) components
                              count:(NSUInteger)count;
+(UIImage *) gradientLine: (CGSize) size;


+(id)getCurrentSSIDInfo;

+ (NSString *)getCurrentWifiSSID;

+(uint)connectToServer:(NSString *)strIP port:(int)nPort;
+(uint)connectToMRServer;
+(uint)connectToMRServerWithdeviceID:(int)deviceID;//add by lusongbin
+(uint)connectToMRServerFormOnlineCheckWithDeviceID:(int)deviceID;

+(long)getLoginHandleFromMR:(int)nDevID domain:(NSString *)strDomain port:(int)nPort usr:(NSString *) strUsername pwd:(NSString *)strPassword;
+(long)getLoginHandle:(int)nDeviceID ip:(NSString *) strIP port:(int)nPort usr:(NSString *) strUsername pwd:(NSString *)strPassword;

+(BOOL)setDomain:(NSString *)strDomain ip:(NSString *)strIP;
 

+(BOOL)isPanoCamera:(int)devID;

+(void)saveUUID:(NSString *)UUID;
/**
 *  读取UUID *
 *
 */
+(NSString *)readUUID;

/**
 *    删除数据
 */
+(void)deleteUUID;


@end

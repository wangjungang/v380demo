//
//  LoginHandle.h
//  NVPlayer
//
//  Created by luo king on 12-9-21.
//  Copyright (c) 2012年 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface LoginHandle : NSObject

@property (assign) int nResult;
@property (assign) long lHandle;
@property (assign) long lTokenSession;//add by luo 20170621

@property (assign) int nPTZXCount;
@property (assign) BOOL bPTZX_PRI;
@property (assign) int nID;
@property (assign) int nDevID;
@property (assign) int nSaveID;
@property (assign) int nServerType;//服务器类型
@property (assign) int nAddType; 
@property (assign) BOOL isMRMode;
@property (copy) NSString *strMRServer;
@property (copy) NSString *strDomain;
@property (assign) int nMRPort;


@property (assign) int nMaxChn;
@property (assign) BOOL bNO_PRI, bCTRL_PRI, bPLAYBACK_PRI, bRECEIVE_PRI, bSpeak_PRI, bAudio_PRI, bPTZ_PRI, bReverse_PRI;

@property (copy) NSString *strName;
@property (copy) NSString *strServer;
@property (assign) int nPort;
@property (copy) NSString *strUsername;
@property (copy) NSString *strPassword;
@property (assign) BOOL isSameLan;
@property (copy) NSString *strIP, *strLanIP;

//add by lusongbin 0714 type
@property(assign) int nDeviceType;
@property(assign) int nCamType;

@property(assign) int nPanoX;
@property(assign) int nPanoY;
@property(assign) int nPanoRad;

//add by lusongbin 20160927
@property(assign) int nVersion;
@property(nonatomic,assign) int DeviceSoftwareUpdateStatu;

@property(assign) int nLightStatus;
@property(assign) int nLightBrightness;

@end

//
//  FileDownloader.h
//  iCamSee
//
//  Created by macrovideo on 16/7/7.
//  Copyright © 2016年 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginHandle.h"
#import "RecFileInfo.h"

#define DOWNLOAD_PROC_DOWNLOADING 10
#define DOWNLOAD_PROC_FINISH 11
#define DOWNLOAD_PROC_CONNECTING 12
#define DOWNLOAD_PROC_CLOSE -10
#define DOWNLOAD_PROC_NET_ERR -11

@protocol RecFileDownloadDelegate <NSObject>
//-(void)onProcessChange:(int)nTotalCount size:(int)nRecv result:(int) nResult;//搜索录像文件接收函数
-(void)onDownloadProcess:(id)downloader flag:(int)nFlag process:(int) nProcess;// 
@end

@interface RecFileDownloader : NSObject
@property (assign) int nTag;
@property (assign) id<RecFileDownloadDelegate> downloadDelegate;

-(BOOL)StartDownLoadRecFile:(NSString *)strSavePath handle:(LoginHandle *)deviceParam rec:(RecFileInfo *)recFile;

-(BOOL)StartDownLoadCloudFile:(NSString *)strSavePath handle:(LoginHandle *)deviceParam rec:(RecFileInfo *)recFile accessToken:(NSString*)accessToken ecsIP:(NSString*)ecsIP ecsPort:(NSString*)escPort nDevID:(int)ndevID nAccountID:(int)nAccountID;

-(BOOL)StopDownLoadRecFile;
 
@end

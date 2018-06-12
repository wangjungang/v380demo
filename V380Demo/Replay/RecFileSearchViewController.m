//
//  RecFileSearchViewController.m
//  macroSEE
//
//  Created by macrovideo on 14-6-24.
//  Copyright (c) 2014年 cctv. All rights reserved.
//

#import "RecFileSearchViewController.h"
#import "DefineVars.h"
#import "PlayBackDeviceTableViewCell.h"
#import "RecFileTableViewCell.h"
#import "RecFileInfo.h"
#import "iToast.h"
#import "UINVPlaybackItemView.h"
#import "AppDelegate.h"
#import "LoginHandle.h"
#import "RecordFileHelper.h"
#import "FilePlaybackViewController.h"
#import "ResultCode.h"
#import "DebugFlag.h"
#import "FunctionTools.h"
#import "ViewFactory.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "PanoPlaybackController.h"
#import "DXAlertView.h"
#import "SVProgressHUD.h"
//云存储
#import "NSString+Formatter.h"
#import "NSDate+Formatter.h"


#define IS_USER_LOGIN ([((AppDelegate *)[UIApplication sharedApplication].delegate) isUserLogin])
#define CLOUD_FILE_SEARCH_VIEW_CONTROLLER_HUD_FILE_NOT_EXIST NSLocalizedString(@"cloudFileSearchViewControllerHudFileNotExist", nil)
#define CLOUD_FILE_SEARCH_VIEW_CONTROLLER_HUD_NETWORK_ERROR  NSLocalizedString(@"cloudFileSearchViewControllerHudNetworkError", nil)


#define PICKER_MODE_DATE 100
#define PICKER_MODE_STARTTIME 101
#define PICKER_MODE_ENDTIME 102

#define DEVICE_CELL_HEIGHT 50
#define REC_CELL_HEIGHT 80
#define DOWNLOAD_PROC_BREAK 1

@interface RecFileSearchViewController (){
    NSInteger tempindex;
    NSTimer *timer;
    int timercount;
    
    
    BOOL isDownload;
//    RecFileDownloader *recFileDownloader;
    NSMutableDictionary *usingDownloaders;
    NSMutableArray *reuseDownloaders;
    NSMutableDictionary *VideoPaths;
    
    NSString *strurl;
    long lHandle;
    int nSearchChn;
    int nSearchType;
    
    short nYear;
    short nMonth;
    short nDay;
    
    short nStartHour;
    short nStartMin;
    short nStartSec;
    
    short nEndHour;
    short nEndMin;
    short nEndSec;
    
    NSMutableArray *serverList;
    int nServerSelectedIndex;
    
    NSMutableArray *recFileList;
    NSCondition *recListLock;
    
    NSInteger nFileSelectedIndex;

    int nDatetimePickerMode;
    
    int nSearchThreadID;
    int nDeviceID;
    
    
    CFAbsoluteTime lHandleGetTime;
    
    UINVPlaybackItemView *pbtnTypeSelection,*pbtnDateSelection, *pbtnTimeSelection, *pbtnTimeEndSelection;
    
    BOOL isDeviceListViewHiden;
    BOOL isTypeSelectViewHiden;
    
    CGFloat fItemHeigh;
    
//    UINVDeviceSelectView *dsvDeviceSelect;
    
    FilePlaybackViewController *filePlaybackViewController;
    PanoPlaybackController *panoplaybackController;
    
    UIButton *searchButton;
//    UIButton *searchCloudFileButton;
    
    // 选择设备正面的可伸缩 view
    UIView *deviceSelectBackgroundView;
    // 录像类型下面的可伸缩 view
    UIView *typeSelectionBackgroundView;
    
    //云存储本地录像选择
    UIView *RecordFileTypeView;
    //云存储
    UIButton *btnSelectCloud;
    //本地录像
    UIButton *btnSelectLocal;
}

@property  (retain) LoginHandle *lLoginHandel;
@property(nonatomic,retain) UIView *MaskView;


// 日期
@property (nonatomic, retain) NSDate *date;
// 开始时间
@property (nonatomic, retain) NSDate *beginTime;
// 结束时间
@property (nonatomic, retain) NSDate *endTime;

@end

@implementation RecFileSearchViewController

@synthesize btnWebHelp;//add by lusongbin 20160219
@synthesize vSearchParamView, imgSearchParamBg, vTopTitleView, imgTopTitleViewBackground, lblTitle;

@synthesize scSearchParamContainer;
@synthesize btnSearchTypeAll, btnSearchTypeAuto, btnSearchTypeAlarm;
@synthesize dsvDeviceSelect;//modify by lusongbin
@synthesize btnSearch, btnCancelDeviceSelect;
@synthesize vDeviceSelectView;
@synthesize vDeviceSelectTopView, ivDeviceSelectTopViewBG, btnDeviceSelectBack,lblDeviceSelectTitle;

@synthesize lblDeviceSelectView, lblRecFileListView;
@synthesize ivDeviceSelectBg, ivRecListTopBackground, vListViewContainer, tbvServerList;
@synthesize  datetimeSelectView, datetimeContainerView, btnTimeSelectOK, btnTimeSelectCancel, datePicker, lblDatetime;
@synthesize vRecFileListView, tbvRecFileListView, btnCloseFileListView, btnShowFileListView, vTopToolView, avLoadingFilesList, vListViewTop,ivListViewTop, ivRecFileListViewBg;
@synthesize vTypeContainer;
@synthesize lLoginHandel;
@synthesize playDelegate;



//add by lusongbin 20170226 云录像搜索
- (void)searchCloudButtonPressed:(id)sender {
    
}

-(void)searchCloudFile{
    
    
}
//end add by lusongbin 20170226 云录像搜索

// add by lusongbin 20160219
- (IBAction)helpClick:(id)sender {

    
}
//end  add by lusongbin 20160219

- (void)sortRecList {
    if (recFileList==nil||[recFileList count]<=0) {
        return;
    }
    
    
    NSArray *sortedArray = [recFileList sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        RecFileInfo * info1=obj1;
        RecFileInfo * info2=obj2;
        
        if (info1.nFileID < info2.nFileID) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        
        if (info1.nFileID > info2.nFileID) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
        
    }];
    [recListLock lock];
    [recFileList removeAllObjects];
    [recFileList setArray:sortedArray];
    [recListLock unlock];
}

- (void)recFileSearchThreadFunc:(NVDevice *)device searchID:(int) nSearchID {

    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];

    int nResult = RESULT_CODE_FAIL_SERVER_CONNECT_FAIL;

    [device retain];
    
    LoginHandle *loginHandel = [RecordFileHelper getRecordOPHandle:device withConnectType:1];

    [device release];
    
    if (loginHandel && [loginHandel nResult]==RESULT_CODE_SUCCESS) {
        
        tbvRecFileListView.hidden = NO;

        [self setLLoginHandel:loginHandel];
        
        nResult = [RecordFileHelper getRecordFiles:loginHandel receiver:self chn:0 type:nSearchType year:nYear month:nMonth day:nDay SH:nStartHour SM:nStartMin SS:nStartSec EH:nEndHour EM:nEndMin ES:nEndSec];

        if (nSearchThreadID==nSearchID) {
            
            if (nResult <= 0) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [avLoadingFilesList stopAnimating];
                    
                    [lblRecFileListView setText:NSLocalizedString(@"lblFileList", @"File list")];

                    iToast *toast = [iToast makeToast: NSLocalizedString(@"strNoFilesFound", @"No file found")];
                    
                    [toast show];
                });
            }
        }
        
    } else {
        
        if (nSearchThreadID==nSearchID) {
            if (lLoginHandel==nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showSearchParamView];
                    [avLoadingFilesList stopAnimating];
                    
                    [lblRecFileListView setText:NSLocalizedString(@"lblFileList", @"File list")];
                    iToast *toast = [iToast makeToast: [NSString stringWithFormat:@"%@", NSLocalizedString(@"noticeCNNFail", @"connect fail")]];
                    
                    [toast show];
                    [self onHideFileListViewClick:nil];

                    
                });

                return;
            }
            NSString *strNotice = nil;
            switch ([lLoginHandel nResult]) {
                case RESULT_CODE_FAIL_USER_NOEXIST:
                    strNotice = [NSString stringWithFormat:@"%@", NSLocalizedString(@"noticeNOUser", @"accont error")];
                    break;
                case RESULT_CODE_FAIL_PWD_ERR:
                    strNotice = [NSString stringWithFormat:@"%@", NSLocalizedString(@"noticePWDErr", @"password error")];
                     break;
                case RESULT_CODE_FAIL_VERIFY_FAIL:
                    strNotice = [NSString stringWithFormat:@"%@", NSLocalizedString(@"noticeNOPRI", @"no priority")];
                     break;
                    
                default:
                    strNotice = [NSString stringWithFormat:@"%@", NSLocalizedString(@"noticeCNNFail", @"connect fail")];
                    break;
                    
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [self showSearchParamView];
                [avLoadingFilesList stopAnimating];
                
                [lblRecFileListView setText:NSLocalizedString(@"lblFileList", @"File list")];
                iToast *toast = [iToast makeToast: strNotice];
                
                [toast show];
                
            });
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
        [avLoadingFilesList stopAnimating];
    });

    if (nSearchThreadID==nSearchID) {

        dispatch_async(dispatch_get_main_queue(), ^{
            
             [self sortRecList];
             [tbvRecFileListView reloadData];
             [avLoadingFilesList stopAnimating];
             
             if (recFileList && [recFileList count] > 0 ) {
                 
                 [lblRecFileListView setText:NSLocalizedString(@"lblFileList", @"File list")];
                 
             } else {
                 
                 [lblRecFileListView setText:NSLocalizedString(@"lblFileList", @"File list")];
                 iToast *toast = [iToast makeToast: NSLocalizedString(@"strNoFilesFound", @"No file found")];
                 
                 [toast show];
                 
                 [self onHideFileListViewClick:nil];
             }
         });
     }

    [pool release];
}

// RecFileSearchDelegate
- (void)onReceiveFile:(int)nRecvTotalCount size:(int)nFileCount list:(NSArray *)fileList {
    [fileList retain];
    if (fileList) {
//         DLog(@"onReceiveFile: %i, %i, %lu", nRecvTotalCount, nFileCount, (unsigned long)[fileList count]);//add for test
        for (int i =0; i<[fileList count]; i++) {
            [recFileList addObject:[fileList objectAtIndex:i]];
        }
        
        [self sortRecList];
        [tbvRecFileListView reloadData];
    }else{
//        DLog(@"onReceiveFile: nil");
    }
    [fileList release];
}
//add by lusongbin 20161122 try
-(LoginHandle*)ReGetHandle{
    NVDevice *device = [[serverList objectAtIndex:nServerSelectedIndex] retain];
    LoginHandle *loginHandel = [RecordFileHelper getRecordOPHandle:device withConnectType:1];//

    if ([loginHandel nResult] == RESULT_CODE_SUCCESS) {
        [filePlaybackViewController ReSetHandle:loginHandel];
        [self setLLoginHandel:loginHandel];
    }
    [device release];
    return loginHandel;
}

-(void)onSearchLocalFile{
    tempindex = NSIntegerMax;
    isDownload = NO;// ADD BY LUSONGBIN 20160818
    
    tbvRecFileListView.hidden = YES;
    
    [avLoadingFilesList startAnimating];
    
    [vRecFileListView bringSubviewToFront:avLoadingFilesList];
    
    [recListLock lock];
    [recFileList removeAllObjects];
    [recListLock unlock];
    
    [self sortRecList];
    [tbvRecFileListView reloadData];
    
    [lblRecFileListView setText:NSLocalizedString(@"lblFileListLoading", @"Loading file list...")];
    
    nSearchThreadID++;
    
    if (nServerSelectedIndex >= 0 && nServerSelectedIndex < [serverList count]) {
        
        NVDevice *info = [[serverList objectAtIndex:nServerSelectedIndex] retain];


        if (info) {
            
            nDeviceID = [info NDevID];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // 处理耗时操作的代码块...
                [self recFileSearchThreadFunc:info searchID:nSearchThreadID];
            });
        }
        
        [info release];
    }
    
    [self showRecFileList];
    
}


- (IBAction)onRecTypeClick:(id)sender {

    if(sender==btnSearchTypeAll) {
        nSearchType = FILE_TYPE_ALL;
    }else if(sender==btnSearchTypeAuto) {
        nSearchType = FILE_TYPE_NORMAL;
    }else if(sender==btnSearchTypeAlarm) {
        nSearchType = FILE_TYPE_ALARM;
    }
    
    isTypeSelectViewHiden = YES;
    isDeviceListViewHiden = YES;
    [self refreshTypeSelectionFrame];
}
#pragma mark - 搜索录像按钮点击
- (void)onSearchClick:(id)sender {
    
    if (btnSelectCloud.selected) {
        [self searchCloudButtonPressed:nil];
    }else{
        [self onSearchLocalFile];
    }
    
}
-(void)onbtnSselectCloudClick{
    
}

- (IBAction)onRecTypeSelectClick:(id)sender {

    btnSelectLocal.selected = YES;
    btnSelectCloud.selected = NO;
    
    isTypeSelectViewHiden = !isTypeSelectViewHiden;
    isDeviceListViewHiden = YES;
    [self refreshTypeSelectionFrame];
}

- (IBAction)onHideDeviceSelectView:(id)sender {
    [vDeviceSelectView removeFromSuperview];
}

// 选择设备按钮点击事件
- (IBAction)onShowDeviceSelectView:(id)sender {

    CGRect backgroundViewFrame = deviceSelectBackgroundView.frame;
    CGRect listViewFrame = tbvServerList.frame;
    CGFloat alpha ;
    if (CGRectGetHeight(backgroundViewFrame) > BUTTON_HEIGHT) {
        
        backgroundViewFrame.size.height = BUTTON_HEIGHT;
        listViewFrame.size.height = CGFLOAT_MIN;

        [dsvDeviceSelect.btnAction setImage:[UIImage imageNamed:@"btn_pb_drop_flag_normal.png"] forState:UIControlStateNormal];
        alpha = 0;
    } else {
        
        backgroundViewFrame.size.height = CGRectGetMaxY(pbtnTimeEndSelection.frame) - CGRectGetMinY(backgroundViewFrame);
        listViewFrame.size.height = CGRectGetHeight(backgroundViewFrame) - BUTTON_HEIGHT;
        
        [dsvDeviceSelect.btnAction setImage:[UIImage imageNamed:@"btn_pb_close_flag_normal.png"] forState:UIControlStateNormal];
        alpha = 0.7;
    }
    
    [vSearchParamView insertSubview:_MaskView belowSubview:deviceSelectBackgroundView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        deviceSelectBackgroundView.frame =  backgroundViewFrame;
        tbvServerList.frame = listViewFrame;
        [_MaskView setAlpha:alpha];
    } completion:^(BOOL finished) {
        if (CGRectGetHeight(backgroundViewFrame) <= BUTTON_HEIGHT) {
            
            [_MaskView removeFromSuperview];
        }
    }];
}

- (IBAction)onDateClick:(id)sender {
    
    [self showDateTimeSelectView:PICKER_MODE_DATE];
}

- (IBAction)onStartTimeClick:(id)sender {
    [self showDateTimeSelectView:PICKER_MODE_STARTTIME];
}

- (IBAction)onEndTimeClick:(id)sender {
    [self showDateTimeSelectView:PICKER_MODE_ENDTIME];
}

- (IBAction)onCancelClick:(id)sender {
   
    if (sender==btnTimeSelectCancel || sender==btnTimeSelectOK){
        
        if (sender==btnTimeSelectOK){
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *comps = [calendar components:unitFlags fromDate:datePicker.date];
 
            [comps retain];
            
            if (nDatetimePickerMode==PICKER_MODE_DATE) {
                
                self.date = datePicker.date;//add by lusongbin 20170206
                
                nYear=[comps year];
                nMonth=[comps month];
                nDay = [comps day];
                
            }else if (nDatetimePickerMode==PICKER_MODE_STARTTIME){
               
                self.beginTime = datePicker.date;
                
                nStartHour = [comps hour];
                nStartMin  = [comps minute];
                nStartSec  = [comps second];
                
                //开始时间不可以大于结束时间
                if (nStartHour>nEndHour) {
                    if (nEndHour==0) {
                        nEndHour=1;
                    }else{
                        nStartHour=nEndHour-1;
                    }
                }else if (nStartHour==nEndHour){
                
                    if (nStartMin>=nEndMin) {
                        if (nEndMin==0) {
                            nEndMin=1;
                        }else{
                            nStartMin=nEndMin-1;
                        }
                    }
                }
                
                
                
            }else if(nDatetimePickerMode==PICKER_MODE_ENDTIME){
               
                self.endTime = datePicker.date;

                nEndHour = [comps hour];
                nEndMin  = [comps minute];
                nEndSec  = [comps second];
                
                //开始时间不可以小于结束时间
                if (nEndHour<nStartHour) {
                    if (nStartHour==23) {
                        nStartHour=22;
                    }else{
                        nEndHour=nStartHour+1;
                    }
                }else if (nEndHour==nStartHour){
                    
                    if (nEndMin<=nStartMin) {
                        if (nStartMin==59) {
                            nStartMin=58;
                        }else{
                            nEndMin=nStartMin+1;
                        }
                    }
                }
 
            }
            
            [self freshDateTimeView];
            
            [calendar release];
            [comps release];
         }
        
        [self hideDateTimeSelectView];
    }
}

- (IBAction)onShowFileListViewClick:(id)sender {

    if (recFileList.count <= 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            iToast *toast = [iToast makeToast:NSLocalizedString(@"RecListIsNull", @"录像列表為空")];
            [toast setToastPosition:kToastPositionCenter];
            [toast setToastDuration:kToastDurationShort];
            [toast show];
        });
        
        return;
    }
    
    [self showRecFileList];
}

- (IBAction)onHideFileListViewClick:(id)sender {
    DLog(@"onHideFileListViewClick");
    
    
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {//x系统版本
        
     
            nSearchThreadID++;
            if ([avLoadingFilesList isAnimating]) {
                [avLoadingFilesList stopAnimating];
                [lblRecFileListView setText:NSLocalizedString(@"lblFileList", @"File list")];
            }
            //add by lusongbin 20161017
            if (playDelegate) {
                [playDelegate ShowTabView:TAB_PLAYBACK_INDEX];
            }
            [vRecFileListView removeFromSuperview];
       
        
    }else{
        
        
            nSearchThreadID++;
            if ([avLoadingFilesList isAnimating]) {
                [avLoadingFilesList stopAnimating];
                [lblRecFileListView setText:NSLocalizedString(@"lblFileList", @"File list")];
            }
            //add by lusongbin 20161017
            if (playDelegate) {
                [playDelegate ShowTabView:TAB_PLAYBACK_INDEX];
            }
            [vRecFileListView removeFromSuperview];
        }
}

- (void)freshDateTimeView {
    
    NSString *strDate = nil;
    
    //at date
    strDate = [NSString stringWithFormat:@"%i", nYear];
    if (nMonth<=9) {
        strDate = [NSString stringWithFormat:@"%@-0%i", strDate, nMonth];
    }else{
        strDate = [NSString stringWithFormat:@"%@-%i", strDate, nMonth];
    }
    
    if (nDay<=9) {
        strDate = [NSString stringWithFormat:@"%@-0%i", strDate, nDay];
    }else{
        strDate = [NSString stringWithFormat:@"%@-%i", strDate, nDay];
    }
    
    [pbtnDateSelection setContent:strDate];
    
    NSString *strFromTime = nil;
    NSString *strToTime = nil;
    //from time
    if (nStartHour<=9) {
        strFromTime = [NSString stringWithFormat:@"0%i", nStartHour];
    }else{
        strFromTime = [NSString stringWithFormat:@"%i", nStartHour];
    }
    
    if (nStartMin<=9) {
        strFromTime = [NSString stringWithFormat:@"%@:0%i", strFromTime, nStartMin];
    }else{
        strFromTime = [NSString stringWithFormat:@"%@:%i", strFromTime, nStartMin];
    }
    
    if (nStartSec<=9) {
        strFromTime = [NSString stringWithFormat:@"%@:0%i", strFromTime, nStartSec];
    }else{
        strFromTime = [NSString stringWithFormat:@"%@:%i", strFromTime, nStartSec];
    }
    
    //to time
    if (nEndHour<=9) {
        strToTime = [NSString stringWithFormat:@"0%i", nEndHour];
    }else{
        strToTime = [NSString stringWithFormat:@"%i", nEndHour];
    }
    
    if (nEndMin<=9) {
        strToTime = [NSString stringWithFormat:@"%@:0%i", strToTime, nEndMin];
    }else{
        strToTime = [NSString stringWithFormat:@"%@:%i", strToTime, nEndMin];
    }
    
    if (nEndSec<=9) {
        strToTime = [NSString stringWithFormat:@"%@:0%i", strToTime, nEndSec];
    }else{
        strToTime = [NSString stringWithFormat:@"%@:%i", strToTime, nEndSec];
    }
    
    
//    [pbtnTimeSelection setContent:[NSString stringWithFormat:@"%@-%@",strFromTime, strToTime]];
    [pbtnTimeSelection setContent:[NSString stringWithFormat:@"%@",strFromTime]];
    [pbtnTimeEndSelection setContent:[NSString stringWithFormat:@"%@", strToTime]];
    

}

// 显示录像文件列表界面
- (void)showRecFileList {
    if (playDelegate) {
        [playDelegate hideTabView:TAB_PLAYBACK_INDEX];
    }
    
    CGRect frame = self.view.frame;
    
    // 录像列表界面
    [vRecFileListView setFrame:frame];
    vRecFileListView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:vRecFileListView];
   
    
    // 导航栏
    frame.size.width = CGRectGetWidth(vRecFileListView.frame);
    frame.size.height = 44;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [vTopToolView setFrame:frame];
    vTopToolView.backgroundColor = DEFAULT_COLOR;
    [vRecFileListView addSubview:vTopToolView];
    
    // 标题
    frame.size.width = CGRectGetWidth(vTopToolView.frame);
    frame.size.height = CGRectGetHeight(vTopToolView.frame);
    frame.origin.x = 0;
    frame.origin.y = 0;
    [lblRecFileListView setFrame:frame];

    // 返回按钮
    frame.size.width = 40;
    frame.size.height = 40;
    frame.origin.x = 5;
    frame.origin.y = 0;
    [btnCloseFileListView setFrame:frame];
    
    // 录像列表
    frame.size.width = CGRectGetWidth(vRecFileListView.frame);
    frame.size.height = CGRectGetHeight(vRecFileListView.frame) - CGRectGetHeight(vTopToolView.frame);
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(vTopToolView.frame);
    [tbvRecFileListView setFrame:frame];
    [vRecFileListView addSubview:tbvRecFileListView];
    
    // 活动指示器
    [avLoadingFilesList removeFromSuperview];
    avLoadingFilesList.center = vRecFileListView.center;
    [vRecFileListView addSubview:avLoadingFilesList];

    
    if (recFileList && [recFileList count] > 0 && [avLoadingFilesList isHidden]) {
        
//        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//            
//            [lblRecFileListView setFont:[UIFont systemFontOfSize: 13]];
//            
//        }else{
//            
//            [lblRecFileListView setFont:[UIFont systemFontOfSize: 18]];
//        }
 
        [lblRecFileListView setText:NSLocalizedString(@"lblFileList", @"File list")];
    }
   
}

- (void)onRecTypeSelectChange {
    

    switch (nSearchType) {
        case FILE_TYPE_ALL:
            [btnSearchTypeAll setImage:[UIImage imageNamed:@"btn_signle_checked.png"] forState:UIControlStateNormal];
            [btnSearchTypeAuto setImage:[UIImage imageNamed:@"btn_signle_uncheck.png"] forState:UIControlStateNormal];
            [btnSearchTypeAlarm setImage:[UIImage imageNamed:@"btn_signle_uncheck.png"] forState:UIControlStateNormal];
            
            [pbtnTypeSelection setContent:NSLocalizedString(@"lblAll", @"All")];
            
            
            break;
        case FILE_TYPE_NORMAL:
            [btnSearchTypeAll setImage:[UIImage imageNamed:@"btn_signle_uncheck.png"] forState:UIControlStateNormal];
            [btnSearchTypeAuto setImage:[UIImage imageNamed:@"btn_signle_checked.png"] forState:UIControlStateNormal];
            [btnSearchTypeAlarm setImage:[UIImage imageNamed:@"btn_signle_uncheck.png"] forState:UIControlStateNormal];
            [pbtnTypeSelection setContent:NSLocalizedString(@"lblAuto", @"Auto")];
           

            break;
        case FILE_TYPE_ALARM:
            [btnSearchTypeAll setImage:[UIImage imageNamed:@"btn_signle_uncheck.png"] forState:UIControlStateNormal];
            [btnSearchTypeAuto setImage:[UIImage imageNamed:@"btn_signle_uncheck.png"] forState:UIControlStateNormal];
            [btnSearchTypeAlarm setImage:[UIImage imageNamed:@"btn_signle_checked.png"] forState:UIControlStateNormal];
            [pbtnTypeSelection setContent:NSLocalizedString(@"lblAlarm", @"Alarm")];
            
            break;
            
        default:
            nSearchType = FILE_TYPE_ALL;
            [btnSearchTypeAll setImage:[UIImage imageNamed:@"btn_signle_checked.png"] forState:UIControlStateNormal];
            [btnSearchTypeAuto setImage:[UIImage imageNamed:@"btn_signle_uncheck.png"] forState:UIControlStateNormal];
            [btnSearchTypeAlarm setImage:[UIImage imageNamed:@"btn_signle_uncheck.png"] forState:UIControlStateNormal];
            [pbtnTypeSelection setContent:NSLocalizedString(@"lblAll", @"All")];
            break;
    }

}

- (void)showSearchParamView {
    [vSearchParamView setFrame:self.view.frame];
    [self.view addSubview: vSearchParamView];
}

- (void)updateServerListData {
    
    nServerSelectedIndex =0;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate retain];
    if (appDelegate) {
        nServerSelectedIndex = [appDelegate _nListViewPosition];
    }
    [appDelegate release];
    
    [serverList removeAllObjects];

    DLog(@"updateServerListData");//add for test
    
    NSMutableArray *array = [NSMutableArray array];
    
    NVDevice *info = [[NVDevice alloc] init];
    
    [info setStrServer:@"192.168.1.1"];
    [info setNPort:8800];
    [info setStrMacAddress:@"ABC"];
    [info setDevID:31019501];    //普通设备
    [info setStrUsername:@"admin"];
    [info setStrPassword:@""];
    [info setNAddType:ADD_TYPE_SEARCH_FROM_LAN];
    [info setNConfigID:1];
    
    NVDevice *info1 = [[NVDevice alloc] init];

    [info1 setStrServer:@"192.168.1.1"];
    [info1 setNPort:8800];
    [info1 setStrMacAddress:@"ABC"];
    [info1 setDevID:23071059];  //全景设备
    [info1 setStrUsername:@"admin"];
    [info1 setStrPassword:@"aaa111"];
    [info1 setNAddType:ADD_TYPE_SEARCH_FROM_LAN];
    [info1 setNConfigID:1];
//    [info1 setIsMRMode:NO];
    


    [array addObject:info];
    [array addObject:info1];
    
    if (array!=nil && [array count]>0) {
        
        [serverList setArray: array];
    }

    
    tbvServerList.delegate = self;
    tbvServerList.dataSource = self;
    [tbvServerList reloadData];
    
    if ((serverList != nil) && ([serverList count] > 0)) {
        
        if ((nServerSelectedIndex < 0) && (nServerSelectedIndex >= [serverList count])){
            
            nServerSelectedIndex=0;
        }
        
        NVDevice *info = [[serverList objectAtIndex:nServerSelectedIndex] retain];
        
        if (info.strName.length > 0) {
            
            [dsvDeviceSelect setContent:info.strName];
            
        } else {
            
            [dsvDeviceSelect setContent:@(info.NDevID).stringValue];
        }
        
        
    
        
        [info release];
        
        searchButton.enabled = YES;
//        searchCloudFileButton.enabled = YES;
        vSearchParamView.userInteractionEnabled = YES;
        
    } else {
        
//        [btnSearch setEnabled:NO];
//        [btnShowFileListView setEnabled:NO];
//        searchCloudFileButton.hidden = YES;
//        btnSelectCloud.enabled = NO;

        searchButton.enabled = NO;
//        searchCloudFileButton.enabled = NO;
        vSearchParamView.userInteractionEnabled = NO;
        [recFileList removeAllObjects];
        [tbvRecFileListView reloadData];
        [lblRecFileListView setText:NSLocalizedString(@"lblFileList", @"File list")];
        
        [dsvDeviceSelect setContent:@""];
    }
}

- (void)showDateTimeSelectView:(int)nMode {
    
    nDatetimePickerMode = nMode;
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    CGRect viewFrame = topVC.view.frame;
    
    datetimeSelectView.frame = viewFrame;
    datetimeSelectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [topVC.view addSubview:datetimeSelectView];
    
    CGRect frame = CGRectZero;
    frame.size.width = CGRectGetWidth(viewFrame) - 40;
    frame.size.height = 257;//iOS 7 date picker最小高度为162 ,标题栏44 取消确认按钮50 高度共 256+1
    datetimeContainerView.frame = frame;
    datetimeContainerView.center = datetimeSelectView.center;
    datetimeContainerView.backgroundColor = [UIColor lightGrayColor];
    
    frame.size.width = CGRectGetWidth(datetimeContainerView.frame);
    frame.size.height = 44;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [lblDatetime setFrame:frame];
    lblDatetime.backgroundColor = DEFAULT_COLOR;
    [datetimeContainerView addSubview:lblDatetime];
    
    frame.size.width = CGRectGetWidth(datetimeContainerView.frame) * 0.5 - 0.25;
    frame.size.height = BUTTON_HEIGHT;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetHeight(datetimeContainerView.frame) - CGRectGetHeight(frame);
    [btnTimeSelectCancel setFrame:frame];
    [btnTimeSelectCancel setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    btnTimeSelectCancel.backgroundColor = [UIColor whiteColor];
    [datetimeContainerView addSubview:btnTimeSelectCancel];
    
    frame.origin.x = CGRectGetMaxX(btnTimeSelectCancel.frame) + 0.5;
    [btnTimeSelectOK setFrame:frame];
    [btnTimeSelectOK setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    btnTimeSelectOK.backgroundColor = [UIColor whiteColor];
    [datetimeContainerView addSubview:btnTimeSelectOK];
    
    frame.size.width = CGRectGetWidth(datetimeContainerView.frame);
    frame.size.height = CGRectGetHeight(datetimeContainerView.frame) - CGRectGetHeight(lblDatetime.frame) - CGRectGetHeight(btnTimeSelectCancel.frame) - 0.5;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(lblDatetime.frame);
    [datePicker setFrame:frame];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datetimeContainerView addSubview:datePicker];
    
    NSString *currentDateString = nil;
    
    if(nDatetimePickerMode==PICKER_MODE_DATE){
        currentDateString = [NSString stringWithFormat:@"%i-%i-%i 00:00:00", nYear, nMonth, nDay];
    }else if (nDatetimePickerMode==PICKER_MODE_STARTTIME) {
        currentDateString = [NSString stringWithFormat:@"%i-%i-%i %i:%i:%i", nYear, nMonth, nDay, nStartHour, nStartMin, nStartSec];
    }else if(nDatetimePickerMode==PICKER_MODE_ENDTIME){
        currentDateString = [NSString stringWithFormat:@"%i-%i-%i %i:%i:%i", nYear, nMonth, nDay, nEndHour, nEndMin, nEndSec];
    }else  {
        return;
    }
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.calendar = [[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian]autorelease];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *toDate = [dateFormater dateFromString:currentDateString];
    [dateFormater setDateStyle:NSDateFormatterFullStyle ];
    [datePicker setDate:toDate];
    
    
    if (nDatetimePickerMode==PICKER_MODE_DATE) {
        
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [dateFormater setDateFormat:@"YYYY-MM-dd"];
        
        [lblDatetime setText:NSLocalizedString(@"lblSelectedDate", nil)];
        
    }else if(nDatetimePickerMode==PICKER_MODE_STARTTIME){
        
        [datePicker setDatePickerMode:UIDatePickerModeTime];
        [dateFormater setDateFormat:@"HH:mm:ss"];
        
        [lblDatetime setText:NSLocalizedString(@"lblStartTime", nil)];
        
    }else if(nDatetimePickerMode==PICKER_MODE_ENDTIME){
        
        [datePicker setDatePickerMode:UIDatePickerModeTime];
        [dateFormater setDateFormat:@"HH:mm:ss"];
        
        [lblDatetime setText:NSLocalizedString(@"lblEndTime", nil)];
    }
    
    [dateFormater release];
}

- (void)hideDateTimeSelectView {
    
    [datetimeSelectView removeFromSuperview];
}

- (IBAction)onDatetimeChange:(id)sender {
    
    if (sender==datePicker) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        formatter.calendar = [[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian]autorelease];
        if ([datePicker datePickerMode]==UIDatePickerModeTime) {
            
            
            //设置时间显示的格式。
            [formatter setDateFormat:@"HH:mm:ss"];
            
//            [lblDatetime setText:[formatter stringFromDate: [datePicker date]]];
            
        }else if ([datePicker datePickerMode]==UIDatePickerModeDate) {
            //设置时间显示的格式。
            [formatter setDateFormat:@"YYYY-MM-dd"];
            
//            [lblDatetime setText:[formatter stringFromDate: [datePicker date]]];
            
        }
        [formatter release];
    }
}

- (void)initInterface {
    
//    UIScrollView *scro = [[UIScrollView alloc]initWithFrame:self.view.frame];
    
    CGRect frame = self.view.frame;
    
    [vSearchParamView setFrame:frame];
    vSearchParamView.backgroundColor = BACKGROUND_COLOR;
    
    [datetimeSelectView setFrame:frame];
    [vDeviceSelectView setFrame:frame];
    
    // 标题栏
    frame.size.width = CGRectGetWidth(vSearchParamView.frame);
    frame.size.height = 44;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [lblTitle setFrame:frame];
    [vTopTitleView setFrame:frame];
    [imgTopTitleViewBackground setFrame:frame];
    [vSearchParamView addSubview:vTopTitleView];
    
        
    frame.size.width = 44;
    frame.size.height = 40;
    frame.origin.x = vTopTitleView.frame.size.width - frame.size.width -15;
    frame.origin.y = (vTopTitleView.frame.size.height - frame.size.height) * 0.5;
    //btnShowFileListView.frame = frame;
   // [vTopTitleView addSubview:btnShowFileListView];
    //inittransform
    pbtnDateSelection.transform = CGAffineTransformIdentity;
    pbtnTimeSelection.transform = CGAffineTransformIdentity;
    pbtnTimeEndSelection.transform = CGAffineTransformIdentity;
    searchButton.transform = CGAffineTransformIdentity;
//    searchCloudFileButton.transform = CGAffineTransformIdentity;//add by lusongbin 20170206

    
    //选择设备按钮箭头
    [dsvDeviceSelect.btnAction setImage:[UIImage imageNamed:@"btn_pb_drop_flag_normal.png"] forState:UIControlStateNormal];
    [pbtnTypeSelection.btnAction setImage:[UIImage imageNamed:@"btn_pb_drop_flag_normal.png"] forState:UIControlStateNormal];

    //遮罩init
    _MaskView.alpha = 0;
    [_MaskView removeFromSuperview];
    // 选择设备按钮可伸缩背景图
    frame.size.width = BUTTON_WIDTH;
    frame.size.height = BUTTON_HEIGHT;
    frame.origin.x = (CGRectGetWidth(vSearchParamView.frame) - BUTTON_WIDTH) / 2;
    frame.origin.y = CGRectGetMaxY(vTopTitleView.frame) + MARGIN;
    deviceSelectBackgroundView.frame = frame;
    [vSearchParamView addSubview:deviceSelectBackgroundView];
    
    // 设备列表
    frame.size.width = BUTTON_WIDTH;
    frame.size.height = 0;
    frame.origin.x = 0;
    frame.origin.y = BUTTON_HEIGHT;
    tbvServerList.frame = frame;
    tbvServerList.backgroundColor = [UIColor clearColor];
    [deviceSelectBackgroundView addSubview:tbvServerList];
    
    // 选择设备按钮
    frame = deviceSelectBackgroundView.frame;
    frame.size.width -= 2;
    frame.size.height -= 2;
    frame.origin.x += 1;
    frame.origin.y += 1;
    [dsvDeviceSelect setFrame:frame];
    dsvDeviceSelect.layer.borderWidth = 0;
    [vSearchParamView addSubview:dsvDeviceSelect];

    // 录像类型按钮可伸缩背景图
    frame.size.width = BUTTON_WIDTH;
    frame.size.height = BUTTON_HEIGHT;
    frame.origin.x = CGRectGetMinX(deviceSelectBackgroundView.frame);
    frame.origin.y = CGRectGetMaxY(deviceSelectBackgroundView.frame) + MARGIN;
    typeSelectionBackgroundView.frame = frame;
    [vSearchParamView addSubview:typeSelectionBackgroundView];

    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] hasPrefix:@"zh-"]) {
        RecordFileTypeView.hidden =YES;
        pbtnTypeSelection.hidden = NO;
        // 录像类型按钮 录像类型选择
        frame.size.width -= 2;
        frame.size.height -= 2;
        frame.origin.x += 1;
        frame.origin.y += 1;
    }else{
        RecordFileTypeView.hidden =NO;
        pbtnTypeSelection.hidden = YES;
    }
    [pbtnTypeSelection setFrame:frame];
    pbtnTypeSelection.layer.borderWidth = 0;
    [vSearchParamView addSubview:pbtnTypeSelection];
    [RecordFileTypeView setFrame:frame];
    [vSearchParamView addSubview:RecordFileTypeView];

    //云存储选择按钮
    frame.size.width = 0;
    frame.size.height = 0;
    frame.origin.x = 0;
    frame.origin.y=0;
    btnSelectCloud.frame = frame;
    //本地录像按钮
    frame = btnSelectCloud.frame;
    frame.origin.x = CGRectGetMaxX(btnSelectCloud.frame);
    btnSelectLocal.frame = frame;
    
    // 日期
    frame.size.width = BUTTON_WIDTH;
    frame.size.height = BUTTON_HEIGHT;
    frame.origin.x = CGRectGetMinX(typeSelectionBackgroundView.frame);
    frame.origin.y = CGRectGetMaxY(dsvDeviceSelect.frame) + MARGIN;
    [pbtnDateSelection setFrame:frame];
    [vSearchParamView addSubview:pbtnDateSelection];
    
    // 开始时间
    frame.size.width = BUTTON_WIDTH;
    frame.size.height = BUTTON_HEIGHT;
    frame.origin.x = CGRectGetMinX(pbtnDateSelection.frame);
    frame.origin.y = CGRectGetMaxY(pbtnDateSelection.frame) + MARGIN;
    [pbtnTimeSelection setFrame:frame];
    [vSearchParamView addSubview:pbtnTimeSelection];
    
    // 结束时间
    frame.size.width = BUTTON_WIDTH;
    frame.size.height = BUTTON_HEIGHT;
    frame.origin.x = CGRectGetMinX(pbtnTimeSelection.frame);
    frame.origin.y = CGRectGetMaxY(pbtnTimeSelection.frame) + MARGIN;
    [pbtnTimeEndSelection setFrame:frame];
    [vSearchParamView addSubview:pbtnTimeEndSelection];
    
    // 搜索按钮
    frame.size.width = BUTTON_WIDTH;
    frame.size.height = BUTTON_HEIGHT;
    frame.origin.x = CGRectGetMinX(pbtnTimeEndSelection.frame);
    frame.origin.y = CGRectGetMaxY(pbtnTimeEndSelection.frame) + MARGIN ;
    [searchButton setFrame:frame];
    searchButton.layer.cornerRadius = CGRectGetHeight(frame) * 0.5;
    [vSearchParamView addSubview:searchButton];
    
    
    // 录像类型弹出框
    frame = pbtnTypeSelection.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [vTypeContainer setFrame:frame];
    vTypeContainer.backgroundColor = [UIColor clearColor];

    CGFloat delta = (CGRectGetWidth(pbtnTypeSelection.frame) - CGRectGetWidth(btnSearchTypeAll.frame) * 3) / 4;
    
    frame = btnSearchTypeAll.frame;
    frame.origin.x = delta;
    frame.origin.y =  (CGRectGetHeight(pbtnTypeSelection.frame) - CGRectGetHeight(frame)) / 2;
    [btnSearchTypeAll setFrame:frame];
    
    frame = btnSearchTypeAuto.frame;
    frame.origin.x = CGRectGetMaxX(btnSearchTypeAll.frame) + delta;
    frame.origin.y = CGRectGetMinY(btnSearchTypeAll.frame);
    [btnSearchTypeAuto setFrame:frame];
    
    frame = btnSearchTypeAlarm.frame;
    frame.origin.x = CGRectGetMaxX(btnSearchTypeAuto.frame) + delta;
    frame.origin.y = CGRectGetMinY(btnSearchTypeAll.frame);
    [btnSearchTypeAlarm setFrame:frame];
    [typeSelectionBackgroundView addSubview:vTypeContainer];
    
    // 将选择设备设为最上面的图层
    [vSearchParamView bringSubviewToFront:deviceSelectBackgroundView];
    [vSearchParamView bringSubviewToFront:dsvDeviceSelect];
    if ([UIScreen mainScreen].bounds.size.height < 568 ) {
        vSearchParamView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(searchButton.frame));
        vSearchParamView.bounces =NO;
        vSearchParamView.showsVerticalScrollIndicator = NO;
        

    }else if([UIScreen mainScreen].bounds.size.height >= 568 ){
    
        
         vSearchParamView.scrollEnabled = NO;
         vSearchParamView.contentSize = self.view.frame.size;
    
    }else{
        
        vSearchParamView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(searchButton.frame));
        vSearchParamView.bounces =NO;
        vSearchParamView.showsVerticalScrollIndicator = NO;
        
    }
    
    btnSelectLocal.selected = YES;
    btnSelectCloud.selected = NO;
    

}

- (void)initSearchParam {
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    nYear = [dateComponent year];
    nMonth = [dateComponent month];
    nDay = [dateComponent day];
    
    [calendar release];
    
    nStartHour = 0;
    nStartMin = 0;
    nStartSec =0;
    
    nEndHour = 23;
    nEndMin = 59;
    nEndSec =59;
    
    nSearchChn=0;
    nSearchType=FILE_TYPE_ALL;
    lHandle = -1;
  
    NSString *strDevice=@"";
 
    [lblTitle setText:NSLocalizedString(@"tabPlayback", @"Playback")];
    
    [dsvDeviceSelect setTitle:NSLocalizedString(@"lblSelectedDevice", @"Selected device:")];
    [dsvDeviceSelect.btnAction setImage:[UIImage imageNamed:@"btn_pb_drop_flag_normal.png"] forState:UIControlStateNormal];
    [dsvDeviceSelect setContent:strDevice];
    
    [lblDeviceSelectTitle setText:NSLocalizedString(@"lblPlsSelectDevice", @"Pls select a device")]; 
//    ddd
    [pbtnTypeSelection setTitle:NSLocalizedString(@"lblRecType", @"Video type: ")];
    [pbtnTypeSelection setContent:NSLocalizedString(@"lblAll", @"All")];
    [pbtnTypeSelection.btnAction setImage:[UIImage imageNamed:@"btn_pb_drop_flag_normal.png"] forState:UIControlStateNormal];
    
    [pbtnDateSelection setTitle:NSLocalizedString(@"lblSelectedDate", @"Selected date: ")];
 
    [pbtnDateSelection.btnAction setImage:[UIImage imageNamed:@"btn_go_normal.png"] forState:UIControlStateNormal];
    
    [pbtnTimeSelection setTitle:NSLocalizedString(@"lblStartTime", @"Start time: ")];
    [pbtnTimeEndSelection setTitle:NSLocalizedString(@"lblEndTime", @"End time: ")];
 
    [pbtnTimeSelection.btnAction setImage:[UIImage imageNamed:@"btn_go_normal.png"] forState:UIControlStateNormal];
    
    [pbtnTimeEndSelection.btnAction setImage:[UIImage imageNamed:@"btn_go_normal.png"] forState:UIControlStateNormal];
    
    [searchButton setTitle: NSLocalizedString(@"btnSearchFile", @"Search File") forState: UIControlStateNormal];
//    [searchCloudFileButton setTitle: @"cloudFile" forState: UIControlStateNormal];

    
    [btnShowFileListView setTitle: NSLocalizedString(@"btnShowFileList", @"File List") forState: UIControlStateNormal];

    [btnSearchTypeAll setTitle: NSLocalizedString(@"lblAll", @"All") forState: UIControlStateNormal];
    [btnSearchTypeAuto setTitle: NSLocalizedString(@"lblAuto", @"Auto") forState: UIControlStateNormal];
    [btnSearchTypeAlarm setTitle: NSLocalizedString(@"lblAlarm", @"Alarm") forState: UIControlStateNormal];
 
    [self freshDateTimeView];
}


//#pragma mark - 录像类型按钮点击事件

- (void)refreshTypeSelectionFrame {
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section {

    if (tableView == tbvServerList) {
        
        if (serverList) {
            
            return serverList.count;
        }
        
    } else if (tableView == tbvRecFileListView) {
        
        if (recFileList) {
        
            return recFileList.count;
        }
    }
   
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == tbvServerList) {
        
        static NSString *cellIdentifier = @"PlayBackDeviceTableViewCell";
        
        PlayBackDeviceTableViewCell *cell = (PlayBackDeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlayBackDeviceTableViewCell" owner:self options:nil];
            
            for (id oneObject in nib) {
                
                if ([oneObject isKindOfClass:[PlayBackDeviceTableViewCell class]]) {
                    
                    cell = (PlayBackDeviceTableViewCell*)oneObject;
                    break;
                }
            }
        }
        
        // 设置 cell 选中状态
        if (serverList && (serverList.count > indexPath.row)) {

            id info = [[serverList objectAtIndex:indexPath.row] retain];
            
            if (indexPath.row == nServerSelectedIndex) {
                
                [info setIsSelect:YES];
                
            } else {
                
                [info setIsSelect:NO];
            }
            
            [cell setLoginInfo:info];
            
            [info release];
            
            cell.tag = indexPath.row;
        }
        
        CGRect rect = cell.frame;
        rect.size.width =  tableView.frame.size.width;
        rect.size.height = DEVICE_CELL_HEIGHT;
        [cell initInterface:rect];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
        
    } else if (tableView == tbvRecFileListView) {
        
        static NSString *recFileTableViewCell = @"RecFileTableViewCell";
        
        RecFileTableViewCell *cell = (RecFileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:recFileTableViewCell];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecFileTableViewCell" owner:self options:nil];
            
            for (id oneObject in nib) {
                
                if ([oneObject isKindOfClass:[RecFileTableViewCell class]]) {
                    
                    cell = (RecFileTableViewCell*)oneObject;
                    break;
                }
            }
        }
        
        if (recFileList && [recFileList count]>indexPath.row) {
            
            RecFileInfo *info = [recFileList objectAtIndex:indexPath.row];
            [info retain];
            [cell.lblInfo setText:[info strFileName]];
            
            double nFileSize = [info nFileSize];
            float nFileTime = [info nFileTimeLen];
            
            NSString *strSize = [NSString stringWithFormat:NSLocalizedString(@"lblFileSize", @"Size: ")];
            if (nFileSize>=1024000) {
                nFileSize = nFileSize/1048576.0;
                
                if (nFileSize>100) {
                    strSize = [NSString stringWithFormat:@"%@ %.0fMB", strSize,nFileSize];
                }else if(nFileSize>1){
                    strSize = [NSString stringWithFormat:@"%@ %.1fMB", strSize,nFileSize];
                }else{
                    
                    strSize = [NSString stringWithFormat:@"%@ %.2fMB", strSize,nFileSize];
                }
                
            }else if (nFileSize>=1024) {
                nFileSize = nFileSize/1024.0;
                
                strSize = [NSString stringWithFormat:@"%@ %.0fKB", strSize,nFileSize];
            }else{
                strSize = [NSString stringWithFormat:@"%@ %.0fB", strSize,nFileSize];
            }
            
            
            
            NSString *strStart = nil;
            
            if ([info nStartHour]>=10) {
                strStart = [NSString stringWithFormat:@"%i", [info nStartHour]];
            }else{
                strStart = [NSString stringWithFormat:@"0%i", [info nStartHour]];
            }
            if ([info nStartMin]>=10) {
                strStart = [NSString stringWithFormat:@"%@:%i", strStart, [info nStartMin]];
            }else{
                strStart = [NSString stringWithFormat:@"%@:0%i", strStart, [info nStartMin]];
            }
            if ([info nStartSec]>=10) {
                strStart = [NSString stringWithFormat:@"%@:%i", strStart, [info nStartSec]];
            }else{
                strStart = [NSString stringWithFormat:@"%@:0%i", strStart, [info nStartSec]];
            }
            
            strStart = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"lblTimeStart", @"Start: "),strStart];
            
            NSString *strTime = [NSString stringWithFormat:NSLocalizedString(@"lblTimeLen", @"Time: ")];
            if (nFileTime>3600) {
                nFileTime=1.0*nFileTime/3600;
                strTime = [NSString stringWithFormat:@"%@ %.0f%@", strTime, nFileTime, NSLocalizedString(@"strHour", @"h")];
            }else if(nFileTime>60){
                nFileTime=1.0*nFileTime/60;
                strTime = [NSString stringWithFormat:@"%@ %.0f%@", strTime, nFileTime, NSLocalizedString(@"strMin", @"m")];
            }else{
                strTime = [NSString stringWithFormat:@"%@ %.0f%@", strTime, nFileTime, NSLocalizedString(@"strSec", @"s")];
            }
            
            [cell.lblName setText:[NSString stringWithFormat:@"%@  %@  %@ ", strStart, strTime, strSize]];
            [info release];
        }
        
        CGRect rect = cell.frame;
        rect.size.width =  tableView.frame.size.width;
        rect.size.height = REC_CELL_HEIGHT;
        [cell initInterface:rect];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == tbvServerList) {
        
        return DEVICE_CELL_HEIGHT;
        
    } else if (tableView == tbvRecFileListView) {
        
        return REC_CELL_HEIGHT;
    }
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (tableView == tbvServerList) {
        
        if (indexPath.row >= 0 && (indexPath.row < serverList.count)) {
            
            nServerSelectedIndex = (int)indexPath.row;
            
            AppDelegate *appDelegate = [(AppDelegate *)[[UIApplication sharedApplication] delegate] retain];
            
            if (appDelegate) {
                
                 [appDelegate set_nListViewPosition:nServerSelectedIndex];
            }
            
            [appDelegate release];
            
            // 设置选择设备按钮上的ID号
            NVDevice *info = [[serverList objectAtIndex:nServerSelectedIndex] retain];
            
            if ([UIScreen mainScreen].bounds.size.height < 568 ) {
                vSearchParamView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(searchButton.frame));
                vSearchParamView.bounces =NO;
                vSearchParamView.showsVerticalScrollIndicator = NO;
                
                
            }else if([UIScreen mainScreen].bounds.size.height >= 568  ){
                
                
                vSearchParamView.scrollEnabled = NO;
                vSearchParamView.contentSize = self.view.frame.size;
                
            }else{
                vSearchParamView.scrollEnabled = YES;
                vSearchParamView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(searchButton.frame));
                vSearchParamView.bounces =NO;
                vSearchParamView.showsVerticalScrollIndicator = NO;
                
            }

            if (info.strName.length > 0) {
                
                [dsvDeviceSelect setContent:info.strName];
                
            } else {
                
                [dsvDeviceSelect setContent:@(info.NDevID).stringValue];
            }
            
            [info release];
        }
        
        // 收回列表
        [self onShowDeviceSelectView:nil];
        
//        isDeviceListViewHiden = YES;
//        isTypeSelectViewHiden = YES;
//
//        [vDeviceSelectView setHidden:YES];
        
    } else if (tableView == tbvRecFileListView) {
        
        
            if (indexPath.row >= 0 && indexPath.row < recFileList.count) {
                
                nFileSelectedIndex = indexPath.row;
                
                UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                UIViewController *topVC = appRootVC;
                while (topVC.presentedViewController) {
                    topVC = topVC.presentedViewController;
                }
                
 
                if (lLoginHandel.nCamType == FISHEYECAMTYPEWALL || lLoginHandel.nCamType == FISHEYECAMTYPETOP) {
                    
                    //全景设备录像回放
                    [panoplaybackController SetPlayList:recFileList handle:lLoginHandel playIndex:(int)nFileSelectedIndex];
                    [topVC presentViewController:panoplaybackController animated:YES completion:^{
                        [panoplaybackController StartPlayInArea:0];
                    }];
//
                }else{
                
                    //普通设备录像回放
                    [filePlaybackViewController SetPlayList:recFileList handle:lLoginHandel playIndex:(int)nFileSelectedIndex];
    
                    [topVC presentViewController:filePlaybackViewController animated:YES completion:^{
    
                        [filePlaybackViewController StartPlayInArea:0];
                    }];
                }
            
            }
      
    }
    
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    // 刷新数据
    [tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    //    if (interfaceOrientation==UIInterfaceOrientationPortrait) {
    //            return YES;
    //    }
    //    [self InitInterface];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    
    return NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initInterface ];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateServerListData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //add by lusongbin 20170206
    self.date = [NSDate date];
    self.beginTime = [self.date beginOfTheDay];
    self.endTime = [self.date endOfTheDay];
    //end add by lusongbin 20170206
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReGetHandle) name:@"CAM_HANDLE_CHANGE" object:nil];

//    datePicker.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    datePicker.calendar = [[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    //add by lusongbin 20160926 iOS8 以下系统picker设置为英文
    if (!([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)) {
        NSArray *languageArray = [NSLocale preferredLanguages];
        NSString *language = [languageArray objectAtIndex:0];
        if (![language isEqualToString:@"zh-Hans"]) {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [datePicker setLocale:locale];
        }
    }
    
    tbvRecFileListView.delegate=self;
    tbvRecFileListView.dataSource=self;
    
    tbvServerList.delegate=self;
    tbvServerList.dataSource=self;

    nServerSelectedIndex=0;
    nFileSelectedIndex=0;
    nSearchThreadID=0;
    nDeviceID=0;
    
    isDeviceListViewHiden=YES;
    isTypeSelectViewHiden=YES;
    
    fItemHeigh=0;
    panoplaybackController = [[PanoPlaybackController alloc]initWithNibName:@"PanoPlaybackController" bundle:nil];
    filePlaybackViewController = [[FilePlaybackViewController alloc] initWithNibName:@"FilePlaybackViewController" bundle:nil];
    
    serverList = [[NSMutableArray alloc] initWithCapacity:20];
    recFileList  = [[NSMutableArray alloc] initWithCapacity:100];
    recListLock=[[NSCondition alloc]init];//add by luo 20140416
    
    // 标题栏
    vTopTitleView.backgroundColor = DEFAULT_COLOR;
    
    //遮罩
    _MaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];//add by lusongbin 20160620
    _MaskView.backgroundColor = [UIColor blackColor];
    
    // 选择设备背景
    deviceSelectBackgroundView = [[UIView alloc] init];
    deviceSelectBackgroundView.backgroundColor = [UIColor whiteColor];
    deviceSelectBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    deviceSelectBackgroundView.layer.borderWidth = 1;
    deviceSelectBackgroundView.layer.cornerRadius = 5;
    
    // 设备列表
    UIView *headerFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
    tbvServerList.tableHeaderView = headerFooterView;
    tbvServerList.tableFooterView = headerFooterView;
    [headerFooterView release];
    
    // 录像类型背景
    typeSelectionBackgroundView = [[UIView alloc] init];
    typeSelectionBackgroundView.backgroundColor = [UIColor whiteColor];
    typeSelectionBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    typeSelectionBackgroundView.layer.borderWidth = 1;
    typeSelectionBackgroundView.layer.cornerRadius = 5;
    
    //录像类型选择,云存储或者本地录像的container ADD BY LUSONGBIN 20170303
    RecordFileTypeView = [[UIView alloc]init];
    RecordFileTypeView.backgroundColor = BACKGROUND_COLOR;
    RecordFileTypeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    RecordFileTypeView.layer.borderWidth = 1;
    RecordFileTypeView.layer.cornerRadius = 5;
    //云存储选择按钮

    
    //END ADD BY LUSONGBIN 20170303

    dsvDeviceSelect = [[UINVDeviceSelectView alloc] init];
    [dsvDeviceSelect.btnAction addTarget:self action:@selector(onShowDeviceSelectView:) forControlEvents:UIControlEventTouchUpInside];
//    111
    pbtnTypeSelection= [[UINVPlaybackItemView alloc] init];
    [pbtnTypeSelection.btnAction addTarget:self action:@selector(onRecTypeSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    pbtnDateSelection= [[UINVPlaybackItemView alloc] init];
    [pbtnDateSelection.btnAction addTarget:self action:@selector(onDateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    pbtnTimeSelection= [[UINVPlaybackItemView alloc] init];
    [pbtnTimeSelection.btnAction addTarget:self action:@selector(onStartTimeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    pbtnTimeEndSelection = [[UINVPlaybackItemView alloc] init];
    [pbtnTimeEndSelection.btnAction addTarget:self action:@selector(onEndTimeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    searchButton = [[ViewFactory mainFactory] solidButtonWithFrame:CGRectZero title:NSLocalizedString(@"btnSearchFile", nil)];
    [searchButton addTarget:self action:@selector(onSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    lHandleGetTime = 0;
    
    [btnTimeSelectOK setTitle:NSLocalizedString(@"btnOK", nil) forState:UIControlStateNormal];
    [btnTimeSelectCancel setTitle:NSLocalizedString(@"btnCancel", nil) forState:UIControlStateNormal];
    
    [self initInterface];
    [self initSearchParam];
    [self showSearchParamView];
    
    CGRect frame = dsvDeviceSelect.frame;
    
    UILabel *lbl1 = [[UILabel alloc]init];
    frame.size.width=BUTTON_WIDTH;
    frame.size.height=30;
    lbl1.text=@"普通设备：31019501";
    frame.origin.x = CGRectGetMinX(pbtnTimeEndSelection.frame);
    frame.origin.y = CGRectGetMaxY(searchButton.frame) + 60 ;
    [lbl1 setFrame:frame];
    [vSearchParamView addSubview:lbl1];
    
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:frame];
    frame.size.width=BUTTON_WIDTH;
    frame.size.height=30;
    lbl2.text=@"全景设备：25000106";
    frame.origin.x = CGRectGetMinX(lbl1.frame);
    frame.origin.y = CGRectGetMaxY(lbl1.frame) + 10 ;
    [lbl2 setFrame:frame];
    [vSearchParamView addSubview:lbl2];
    
    UIButton *btnBack = [[UIButton alloc]init];
    frame.size.width=44;
    frame.size.height=40;
    frame.origin.x = 10;
    frame.origin.y = (vTopTitleView.frame.size.height - frame.size.height) * 0.5;
    [btnBack setFrame:frame];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"btnBackNormal.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [vTopTitleView addSubview:btnBack];


}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CAM_HANDLE_CHANGE" object:nil];// add by lusongbin 20161122
    
    [searchButton removeObserver:[ViewFactory mainFactory] forKeyPath:@"enabled"];
//    [searchCloudFileButton removeObserver:[ViewFactory mainFactory] forKeyPath:@"enabled"];

    
    [RecordFileTypeView release];
    //云存储
    [btnSelectCloud release];
    //本地录像
    [btnSelectLocal release];

    

    [filePlaybackViewController release];
    [lLoginHandel release];
    [dsvDeviceSelect release];
    [pbtnTypeSelection release];
    [pbtnDateSelection release];
    [pbtnTimeSelection release];
    [pbtnTimeEndSelection release];
    
    [scSearchParamContainer release];
    
    [imgSearchParamBg release];
    [vTopTitleView release];
    [imgTopTitleViewBackground release];
    [lblTitle release];
    
    [deviceSelectBackgroundView release];
    [typeSelectionBackgroundView release];
    
    
    [vTypeContainer release];
    
    [vListViewTop release];
    [ivListViewTop release];
    [ivRecListTopBackground release];
    [avLoadingFilesList release];
    [vTopToolView release];
    [btnShowFileListView release];
    [vRecFileListView release];
    [tbvRecFileListView release];
    [btnCloseFileListView release];
    
    [recListLock release];
    
    [lblDatetime release];
    [datetimeSelectView release];
    [datetimeContainerView release];
    [btnTimeSelectOK release];
    [btnTimeSelectCancel release];
    [datePicker release];
    
    [lblRecFileListView release];
    
    [lblDeviceSelectView release];
    [ivDeviceSelectBg release];
    [vListViewContainer release];
    [tbvServerList release];
    
    [vSearchParamView release];
    [vDeviceSelectView release];
 
    [ivRecFileListViewBg release];
    
    [vDeviceSelectTopView release];
    [ivDeviceSelectTopViewBG release];
    [btnDeviceSelectBack release];
    [lblDeviceSelectTitle release];
    
    [btnCancelDeviceSelect release];
    [serverList release];
    [recFileList release];
    [super dealloc];
}

- (void)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidUnload {
    
//    [self setWebActivity:nil];
    [super viewDidUnload];
}

@end

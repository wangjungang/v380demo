//
//  RecFileSearchViewController.h
//  macroSEE
//
//  Created by macrovideo on 14-6-24.
//  Copyright (c) 2014年 cctv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayDelegate.h"
#import "UINVDeviceSelectView.h"
#import "UINVImageButton.h"
#import "RecFileSearchDelegate.h"

@class NVDevice;

@interface RecFileSearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RecFileSearchDelegate>
    

/**
 *吸引修改设备
 */
//

// add by lusongbin 20160219
@property (retain, nonatomic) IBOutlet UIButton *btnWebHelp;
//
 
@property (assign) id<PlayDelegate> playDelegate;
@property  (assign)int nSaveDeviceID;
@property  (copy)NSString *strSaveUsername;
@property  (copy)NSString *strSavePassword;
//top title view
@property (nonatomic, retain) IBOutlet UIScrollView *vSearchParamView;
@property (nonatomic, retain) IBOutlet UIImageView *imgSearchParamBg;

@property (nonatomic, retain) IBOutlet UIView *vTopTitleView;
@property (nonatomic, retain) IBOutlet UIImageView *imgTopTitleViewBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;

@property (nonatomic, retain) UINVDeviceSelectView *dsvDeviceSelect;
@property (nonatomic, retain) IBOutlet UIImageView *ivDeviceContainerViewBg;

@property (nonatomic, retain) IBOutlet UIView  *vTypeContainer;

@property (nonatomic, retain) IBOutlet UINVImageButton *btnSearchTypeAll, *btnSearchTypeAuto, *btnSearchTypeAlarm;

@property (nonatomic, retain) IBOutlet UIButton *btnSearch;

@property (nonatomic, retain) IBOutlet UIButton *btnCancelDeviceSelect;

@property (nonatomic, retain) IBOutlet UIView  *vDeviceSelectView;
@property (nonatomic, retain) IBOutlet UIView  *vDeviceSelectTopView;
@property (nonatomic, retain) IBOutlet UIImageView  *ivDeviceSelectTopViewBG;
@property (nonatomic, retain) IBOutlet UIButton *btnDeviceSelectBack;
@property (nonatomic, retain) IBOutlet UILabel *lblDeviceSelectTitle;

@property (nonatomic, retain) IBOutlet UILabel *lblDeviceSelectView, *lblRecFileListView;

@property (nonatomic, retain) IBOutlet UIImageView *ivDeviceSelectBg, *ivRecListTopBackground, *ivListViewTop;
@property (nonatomic, retain) IBOutlet UIView *vListViewContainer, *vListViewTop;
@property (nonatomic, retain) IBOutlet UITableView *tbvServerList;

@property (nonatomic, retain) IBOutlet UIView *datetimeSelectView, *datetimeContainerView;
@property (nonatomic, retain) IBOutlet UIButton *btnTimeSelectOK, *btnTimeSelectCancel;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UILabel *lblDatetime;

@property (nonatomic, retain) IBOutlet UIView *vRecFileListView, *vTopToolView;
@property (nonatomic, retain) IBOutlet UIImageView *ivRecFileListViewBg;
@property (nonatomic, retain) IBOutlet UITableView *tbvRecFileListView;
@property (nonatomic, retain) IBOutlet UIButton *btnCloseFileListView, *btnShowFileListView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * avLoadingFilesList;
@property (nonatomic, retain) IBOutlet UIScrollView *scSearchParamContainer;

- (IBAction)onSearchClick:(id)sender;
- (IBAction)onRecTypeClick:(id)sender;
- (IBAction)onShowDeviceSelectView:(id)sender;
- (IBAction)onHideDeviceSelectView:(id)sender;

- (IBAction)onRecTypeSelectClick:(id)sender;
- (IBAction)onDateClick:(id)sender;
- (IBAction)onStartTimeClick:(id)sender;
- (IBAction)onEndTimeClick:(id)sender;

- (IBAction)onCancelClick:(id)sender;
- (IBAction)onShowFileListViewClick:(id)sender;
- (IBAction)onHideFileListViewClick:(id)sender;

- (IBAction)onDatetimeChange:(id)sender;//时间选择窗口中时间控件值改变事件

- (void)onRecTypeSelectChange;
- (void)initSearchParam;

- (void)showSearchParamView;
- (void)showDateTimeSelectView:(int) nMode;
- (void)hideDateTimeSelectView;

- (void)updateServerListData;

- (void)initInterface;

- (void)freshDateTimeView;

- (void)showRecFileList;

- (void)sortRecList;

- (void)recFileSearchThreadFunc:(NVDevice *)device searchID:(int) nSearchID;
 
@end

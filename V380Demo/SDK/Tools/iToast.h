//
//  iToast.h
//  iToastDemo
//  
//  Created by amao on 12/12/11.
//  Copyright (c) 2011 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    kToastPositionTop,
    kToastPositionCenter,
    kToastPositionBottom,
} ToastPosition;

typedef enum 
{
    kToastDurationShort = 1000,
    kToastDurationNormal= 3000,
    kToastDurationLong  =10000,
} ToastDuration;

@interface iToast : NSObject
{
    ToastPosition   toastPosition;
    ToastDuration   toastDuration;
    NSString        *toastText;
    UIView          *view;
}

@property (assign,nonatomic)    ToastPosition toastPosition;
@property (assign,nonatomic)    ToastDuration toastDuration;
@property (retain,nonatomic)    NSString      *toastText;


- (id)initWithText: (NSString *)text;
- (void)show;

+ (iToast *)makeToast: (NSString *)text;


- (void)hideToast: (id)sender;
- (void)onHideToast: (NSTimer *)timer;
- (void)onRemoveToast: (NSTimer *)timer;
- (void)doHideToast;

@end

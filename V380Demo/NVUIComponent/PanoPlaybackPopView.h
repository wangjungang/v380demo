//
//  PanoPlaybackPopView.h
//  camtypePopView
//
//  Created by 视宏 on 16/11/1.
//  Copyright © 2016年 视宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanoPlaybackPopView : UIScrollView

/** 便利初始方法, type 为吊装(2)或壁装(1) */
+ (instancetype)panoModeViewWithType:(NSInteger)fixType;

/** 设置模式标签点击事件 */
- (void)addTarget:(id)target action:(SEL)action;

/** 选择标签, 改变标签选中状态 */
- (void)selecteItemAtIndex:(NSInteger)index;

-(void)setFixType:(NSInteger)fixType;
@end

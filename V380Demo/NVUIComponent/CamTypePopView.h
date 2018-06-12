//
//  CamTypePopView.h
//  camtypePopView
//
//  Created by 视宏 on 16/10/11.
//  Copyright © 2016年 视宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CamTypePopView : UIScrollView

+ (instancetype)camtypePopview;

/** 设置模式标签点击事件 */
- (void)addTarget:(id)target action:(SEL)action;

/** 选择标签, 改变标签选中状态 */
- (void)selecteItemAtIndex:(NSInteger)index;

@end

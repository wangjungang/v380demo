//
//  CamTypePopView.m
//  camtypePopView
//
//  Created by 视宏 on 16/10/11.
//  Copyright © 2016年 视宏. All rights reserved.
//

#import "CamTypePopView.h"
static const NSInteger kNumberOfModesOfType0 = 5; // 吊装 5 种
static const NSInteger kNumberOfModesOfType1 = 2; // 壁装 2 种 0 1

static const CGFloat kItemWidth  = 40.0; // 标签宽度
static const CGFloat kItemHeight = 40.0; // 标签高度

@interface CamTypePopView()

@property (nonatomic, strong) NSMutableDictionary *modes;
@property (nonatomic, assign) NSInteger fixType;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation CamTypePopView

- (NSMutableDictionary *)modes {
    
    if (_modes == nil) {
        
        _modes = [NSMutableDictionary dictionary];
    }
    
    return _modes;
}

+ (instancetype)camtypePopview{
    
    CamTypePopView *view = [[self alloc] init];
    
    NSInteger numberOfModes = 2;
    view.contentSize = CGSizeMake(kItemWidth, kItemHeight * numberOfModes);
    [view selecteItemAtIndex:0];
    
    return view;
}

//-(void)setFixType:(NSInteger)fixType
//{
//    if (_fixType != fixType) {
//        _fixType = fixType;
//    }
//    [self setNeedsDisplay];
//    
//}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        self.layer.cornerRadius = 5.0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
        for (NSInteger i = 1; i <3; i++) {
            //1 2
            UIButton *mode = [self buttonWithTitle:@(i).stringValue tag:i];
            self.modes[@(i)] = mode;
            [self addSubview:mode];
            
        }
    }
    
    return self;
}

- (UIButton *)buttonWithTitle:(NSString *)title tag:(NSInteger)tag {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"camtype_%ld_normal", tag]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"camtype_%ld_selected", tag]] forState:UIControlStateSelected];
    
    button.tag = tag;
    
    return button;
}

- (void)layoutSubviews {
    
    __block CGRect frame;
    frame.size.width = kItemWidth;
    frame.size.height = kItemHeight;
    frame.origin.y = (CGRectGetHeight(self.frame) - kItemHeight) * 0.5;
    
    CGFloat width = CGRectGetWidth(self.frame) / 2;
    CGFloat margin = (width - kItemWidth) / 2;
    
    __block NSInteger index = 0;
    
    [self.modes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSInteger tag = [obj tag];
            frame.origin.x = index * width + margin;
            [obj setFrame:frame];
            
            index++;
//            NSLog(@"tag-------%ld",(long)tag);
    }];
}

- (void)addTarget:(id)target action:(SEL)action {
    
    [self.modes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [obj addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)selecteItemAtIndex:(NSInteger)index {
    
    [self.modes[@(self.currentIndex)] setSelected:NO];
    [self.modes[@(index)] setSelected:YES];
    self.currentIndex = index;
}


@end



/**
 
 全景模式控件
 
 */

#import "PanoModeView.h"

// mode0 原始图
// mode1 视角图
// mode2 2个视角图+1个360经纬图
// mode3 桶形图
// mode4 水平经纬图
// mode5 垂直经纬图
// mode6 上下180度经纬图
// mode7 4分割视角图
// mode8 1个原图+3个视角图
// mode9 1个原图+5个视角图


static const NSInteger kNumberOfModesOfType1 = 3; // 壁装 2 种 0 1
static const NSInteger kNumberOfModesOfType2 = 6; // 吊装 5 种

static const CGFloat kItemWidth  = 40.0; // 标签宽度
static const CGFloat kItemHeight = 40.0; // 标签高度

@interface PanoModeView ()

@property (nonatomic, strong) NSMutableDictionary *modes;
@property (nonatomic, assign) NSInteger fixType;
@property (nonatomic, assign) NSInteger currentIndex;


@end

@implementation PanoModeView

- (NSMutableDictionary *)modes {
    
    if (_modes == nil) {
        
        _modes = [NSMutableDictionary dictionary];
    }
    
    return _modes;
}


+ (instancetype)panoModeViewWithType:(NSInteger)fixType {
    
    PanoModeView *view = [[self alloc] init];
    
    view.fixType = fixType;
    NSInteger numberOfModes = ((fixType == 2) ? kNumberOfModesOfType2 : kNumberOfModesOfType1);
    view.contentSize = CGSizeMake(kItemWidth, kItemHeight * numberOfModes);
    [view selecteItemAtIndex:0];
    
    return view;
}



-(void)setFixType:(NSInteger)fixType
{
    if (_fixType != fixType) {
        _fixType = fixType;
    }
    [self setNeedsDisplay];
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        self.layer.cornerRadius = 5.0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
        for (NSInteger i = 0; i < 14; i++) {
            // 0 4 3 6 7 11 12
            if ((i == 2) || (i == 1) || (i == 5) || (i == 8)|| (i == 9)|| (i == 10)|| (i == 12))  {
                
                continue;
            }
            
            UIButton *mode = [self buttonWithTitle:@(i).stringValue tag:i];
            
            self.modes[@(i)] = mode;
            
            [self addSubview:mode];
            
        }
    }
    
    return self;
}

- (UIButton *)buttonWithTitle:(NSString *)title tag:(NSInteger)tag {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"fisheye_%ld_normal", tag]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"fisheye_%ld_selected", tag]] forState:UIControlStateSelected];
    
    button.tag = tag;
    
    return button;
}

- (void)layoutSubviews {
    
    
    if (CGRectGetWidth(self.bounds) < CGRectGetHeight(self.bounds)) {//横屏
        
        CGRect frame;
        frame.size.width = kItemWidth;
        frame.size.height = kItemHeight;
        frame.origin.x = (CGRectGetWidth(self.frame) - kItemHeight) * 0.5;
        
        CGFloat height = CGRectGetHeight(self.frame) / ((self.fixType == 2) ? kNumberOfModesOfType2 : kNumberOfModesOfType1);
        CGFloat margin = (height - kItemWidth) / 2;
        if(self.fixType == 1){
        
            frame.origin.y = 0 * height + margin;
            [self.modes[@(0)] setFrame:frame];
            
            frame.origin.y = 1 * height + margin;
            [self.modes[@(4)] setFrame:frame];
            
            frame.origin.y = 2 * height + margin;
            [self.modes[@(13)] setFrame:frame];
    
        }else if (self.fixType == 2){
            
            
            frame.origin.y = 0 * height + margin;
            [self.modes[@(0)] setFrame:frame];
            
            frame.origin.y = 1 * height + margin;
            [self.modes[@(3)] setFrame:frame];
            
            frame.origin.y = 2 * height + margin;
            [self.modes[@(11)] setFrame:frame];
            
            frame.origin.y = 3 * height + margin;
            [self.modes[@(7)] setFrame:frame];
            
            frame.origin.y = 4 * height + margin;
            [self.modes[@(6)] setFrame:frame];
            
            frame.origin.y = 5 * height + margin;
            [self.modes[@(13)] setFrame:frame];
            
        }
    }else{
    
    CGRect frame;
    frame.size.width = kItemWidth;
    frame.size.height = kItemHeight;
    frame.origin.y = (CGRectGetHeight(self.frame) - kItemHeight) * 0.5;

    CGFloat width = CGRectGetWidth(self.frame) / ((self.fixType == 2) ? kNumberOfModesOfType2 : kNumberOfModesOfType1);
    CGFloat margin = (width - kItemWidth) / 2;

    if(self.fixType == 1){
      
            frame.origin.x = 0 * width + margin;
            [self.modes[@(0)] setFrame:frame];
            
            frame.origin.x = 1 * width + margin;
            [self.modes[@(4)] setFrame:frame];
            
            frame.origin.x = 2 * width + margin;
            [self.modes[@(13)] setFrame:frame];
        
    }else if (self.fixType == 2){
        // 0  3 6 7 11 13
        
        
            frame.origin.x = 0 * width + margin;
            [self.modes[@(0)] setFrame:frame];
            
            frame.origin.x = 1 * width + margin;
            [self.modes[@(3)] setFrame:frame];
            
            frame.origin.x = 2 * width + margin;
            [self.modes[@(11)] setFrame:frame];
            
            frame.origin.x = 3 * width + margin;
            [self.modes[@(7)] setFrame:frame];
            
            frame.origin.x = 4 * width + margin;
            [self.modes[@(6)] setFrame:frame];

            frame.origin.x = 5 * width + margin;
            [self.modes[@(13)] setFrame:frame];
    }
    
    }
    
    if (self.fixType == 1) {
        //0 4 13
        //0 3 6
        [self.modes[@(3)] setHidden:YES];
        [self.modes[@(11)] setHidden:YES];
        [self.modes[@(4)] setHidden:NO];

    }else{
        
        [self.modes[@(3)] setHidden:NO];
        [self.modes[@(11)] setHidden:NO];
        [self.modes[@(4)] setHidden:YES];
    }
    
}

- (void)addTarget:(id)target action:(SEL)action {
    
    [self.modes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        [obj addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }];
}
//-(void)setIsReverse:(BOOL)isRever{
//    _isRe = &isRever;
//}
- (void)selecteItemAtIndex:(NSInteger)index {
    
    if(index == 13){
        if(self.isRe)
        {
            [self.modes[@(index)] setSelected:YES];

        }else{
            [self.modes[@(index)] setSelected:NO];

        }
        
    }else{
    
    [self.modes[@(self.currentIndex)] setSelected:NO];
    [self.modes[@(index)] setSelected:YES];
    self.currentIndex = index;
    }
}

@end

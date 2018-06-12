

#import "ViewFactory.h"

@implementation ViewFactory

#pragma mark - Singleton

static ViewFactory *mainFactory = nil;

+ (instancetype)mainFactory {
    
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mainFactory = [super allocWithZone:zone];
    });
    
    return mainFactory;
}

#pragma mark - UITextField

// 用户名
- (UITextField *)usernameTextFieldWithFrame:(CGRect)frame icon:(UIImage *)icon placeholder:(NSString *)placeholder {
    
    UITextField *textField = [self textFieldWithFrame:frame icon:icon placeholder:placeholder];
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    return textField;
}

// 手机号
- (UITextField *)mobileTextFieldWithFrame:(CGRect)frame icon:(UIImage *)icon placeholder:(NSString *)placeholder {
    
    UITextField *textField = [self textFieldWithFrame:frame icon:icon placeholder:placeholder];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    return textField;
}

// 邮箱
- (UITextField *)emailTextFieldWithFrame:(CGRect)frame icon:(UIImage *)icon placeholder:(NSString *)placeholder {
    
    UITextField *textField = [self textFieldWithFrame:frame icon:icon placeholder:placeholder];
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    
    return textField;
}

// 密码
- (UITextField *)passwordTextFieldWithFrame:(CGRect)frame icon:(UIImage *)icon placeholder:(NSString *)placeholder {
    
    UITextField *textField = [self textFieldWithFrame:frame icon:icon placeholder:placeholder];
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.secureTextEntry = YES;

    CGFloat boxHeight = CGRectGetHeight(frame);
    CGFloat switchY = (boxHeight - 31 * 0.6) * 0.5;
    CGFloat rightViewWidth = boxHeight * 0.5 + 51 * 0.6;

    UISwitch *s = [self defaultSwitch];
    s.transform = CGAffineTransformMakeScale(0.6, 0.6);
    s.frame = CGRectMake(0, switchY, 0, 0);
    [s addTarget:self action:@selector(switchPasswordMode:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightViewWidth, boxHeight)];
    [rightView addSubview:s];
    
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;

    return textField;
}

- (void)switchPasswordMode:(UISwitch *)sender {
    
    id obj = sender.superview;
    
    while (![obj isKindOfClass:[UITextField class]]) {

        obj = [obj superview];
    }
    
    [obj becomeFirstResponder];
    [obj setSecureTextEntry:!sender.isOn];
}

- (UITextField *)textFieldWithFrame:(CGRect)frame icon:(UIImage *)icon placeholder:(NSString *)placeholder {

    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    
    textField.backgroundColor = [UIColor whiteColor];
    
    textField.layer.cornerRadius = 2.0;
    textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    textField.layer.borderWidth = 1;
    
    CGFloat leftViewHeight = CGRectGetHeight(frame) * 0.4;
    CGFloat leftViewWidth = CGRectGetHeight(frame) * 0.5 + leftViewHeight + 5;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftViewWidth, leftViewHeight)];
    CALayer *layer = [CALayer layer];
    layer.contents = (__bridge id _Nullable)(icon.CGImage);
    layer.frame = CGRectMake(CGRectGetHeight(frame) * 0.5, 0, leftViewHeight, leftViewHeight);
    layer.contentsGravity = kCAGravityResizeAspect;
    [leftView.layer addSublayer:layer];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.placeholder = placeholder;
    
    textField.tintColor = [UIColor lightGrayColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return textField;
}

// 验证码
- (UITextField *)validCodeTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    
    textField.backgroundColor = [UIColor whiteColor];
    
    textField.layer.cornerRadius = 2;
    textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    textField.layer.borderWidth = 1;

    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.placeholder = placeholder;
    
    textField.tintColor = [UIColor lightGrayColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    textField.keyboardType = UIKeyboardTypeNumberPad;

    return textField;
}

#pragma mark - UIButton

// 实心按钮
- (UIButton *)solidButtonWithFrame:(CGRect)frame title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    button.backgroundColor = DEFAULT_COLOR;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.3] forState:UIControlStateHighlighted];
    
    button.layer.cornerRadius = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * 0.5;
    
    [button addObserver:self forKeyPath:@"enabled" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    return button;
}

// 镂空按钮
- (UIButton *)hollowButtonWithFrame:(CGRect)frame title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    [button setTitleColor:[DEFAULT_COLOR colorWithAlphaComponent:0.5]forState:UIControlStateHighlighted];
    
    button.layer.cornerRadius = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * 0.5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = DEFAULT_COLOR.CGColor;
    
    [button addObserver:self forKeyPath:@"enabled" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];

    return button;
}

// 重新发送验证码按钮
- (UIButton *)resendButtonWithFrame:(CGRect)frame title:(NSString *)title {
 
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    button.backgroundColor = DEFAULT_COLOR;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.3] forState:UIControlStateHighlighted];

    button.layer.cornerRadius = 2;

    [button addObserver:self forKeyPath:@"enabled" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];

    return button;
}

#pragma mark - UISwitch

// Switch
- (UISwitch *)defaultSwitch {
    
    UISwitch *s = [[UISwitch alloc] init];
    
    s.onTintColor = DEFAULT_COLOR;

    return s;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"enabled"]) {
        
        BOOL old = [[change valueForKey:NSKeyValueChangeOldKey] boolValue];
        BOOL new = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        
        if (old != new) {
            
            [object setBackgroundColor:(new ? DEFAULT_COLOR : [UIColor lightGrayColor])];
        }
    }
}

@end



#import <UIKit/UIKit.h>

#define DEFAULT_COLOR       [UIColor colorWithRed:0/255.0 green:129/255.0 blue:226/255.0 alpha:1.0]
#define BACKGROUND_COLOR    [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]

#define BUTTON_WIDTH        (CGSizeMake(MIN([[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height), MAX([[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height)).width - MARGIN * 2)

#define BUTTON_HEIGHT       50.0
#define MARGIN              20.0
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define RELOADALBUM      @"reloadAlbum"

@interface ViewFactory : NSObject

+ (instancetype)mainFactory;

/** 用户名输入框 */
- (UITextField *)usernameTextFieldWithFrame:(CGRect)frame icon:(UIImage *)icon placeholder:(NSString *)placeholder;

/** 手机号输入框 */
- (UITextField *)mobileTextFieldWithFrame:(CGRect)frame icon:(UIImage *)icon placeholder:(NSString *)placeholder;

/** 邮箱输入框 */
- (UITextField *)emailTextFieldWithFrame:(CGRect)frame icon:(UIImage *)icon placeholder:(NSString *)placeholder;

/** 密码输入框 */
- (UITextField *)passwordTextFieldWithFrame:(CGRect)frame icon:(UIImage *)icon placeholder:(NSString *)placeholder;

/** 验证码输入框 */
- (UITextField *)validCodeTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

/** 
 实心按钮，默认添加了 "enabled" 的键值观察，务必在适当时机移除观察
 [buttonObject removeObserver:[ViewFactory mainFactory] forKeyPath:@"enabled"];
 */
- (UIButton *)solidButtonWithFrame:(CGRect)frame title:(NSString *)title;

/**
 镂空按钮，默认添加了 "enabled" 的键值观察，务必在适当时机移除观察
 [buttonObject removeObserver:[ViewFactory mainFactory] forKeyPath:@"enabled"];
 */
- (UIButton *)hollowButtonWithFrame:(CGRect)frame title:(NSString *)title;

/**
 重新发送验证码按钮，默认添加了 "enabled" 的键值观察，务必在适当时机移除观察
 [buttonObject removeObserver:[ViewFactory mainFactory] forKeyPath:@"enabled"];
 */
- (UIButton *)resendButtonWithFrame:(CGRect)frame title:(NSString *)title;

/** 开关（默认颜色为App主颜色） */
- (UISwitch *)defaultSwitch;

@end

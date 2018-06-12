

/**
 
 字符串处理
 
 */

#import <Foundation/Foundation.h>

@interface NSString (Formatter)

/** 转为 MD5 字符串 */
- (NSString *)MD5String;

/** 清除字符串中所有空格 */
- (NSString *)noneSpaceString;

/** 手机号3-4-4样式 */
- (NSString *)mobileStyleString;

/** 是否为有效手机号 */
- (BOOL)isMobileString;

/** 是否为有效验证码 */
- (BOOL)isValidCodeString;

/** 秒数转换为时长字符串 */
+ (instancetype)stringWithDuration:(int)duration;

/** 字节数转为字符串 */
+ (instancetype)stringWithBytes:(int)bytes;

/** AES 字符串 */
- (NSString *)AESEncryptWithKey:(NSString *)key;

/** 解密 AES 字符串 */
- (NSString *)AESDecryptWithKey:(NSString *)key;

/** 数据生成十六进制字符串 */
+ (instancetype)hexStringFromData:(NSData *)data;

/** 十六进制字符串转为数据 */
- (NSData *)hexStringData;

/** 编码 base64 字符串 */
- (NSString *)base64Encode;

/** 解码 base64 字符串 */
- (NSString *)base64Decode;

@end

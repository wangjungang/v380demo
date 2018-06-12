

/**
 
 字符串处理
 
 */

#import "NSString+Formatter.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Formatter)

// 转为 MD5 字符串
- (NSString *)MD5String {
    
    // 存放 MD5字符串 的数组
    unsigned char MD5[CC_MD5_DIGEST_LENGTH];
    
    // MD5
    CC_MD5(self.UTF8String, (unsigned int)self.length, MD5);
    
    // 转成 NSString
    NSMutableString *MD5String = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [MD5String appendFormat:@"%02x", MD5[i]];
    }
    
    return [MD5String copy];
}

// 清除字符串中所有空格
- (NSString *)noneSpaceString {
    
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

// 手机号3-4-4样式
- (NSString *)mobileStyleString {
    
    if (self.length == 0) {
        
        return nil;
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:[self noneSpaceString]];
    
    if (mutableString.length > 3) {
        
        [mutableString insertString:@" " atIndex:3];
    }
    
    if (mutableString.length > 8) {
        
        [mutableString insertString:@" " atIndex:8];
    }
    
    return [mutableString copy];
}

// 是否为有效手机号
- (BOOL)isMobileString {
    
    // 11位数字且符合中国大陆手机号段
    NSString *regex = @"^1(3[0-9]|4[57]|5[0-35-9]|7[06-8]|8[0-9])\\d{8}$";
    
    NSPredicate *checker = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [checker evaluateWithObject:self];
}

// 是否为有效验证码
- (BOOL)isValidCodeString {
    
    // 6个字符全部为数字
    NSString *regex = @"^\\d{6}$";
    
    NSPredicate *checker = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [checker evaluateWithObject:self];
}

// 秒数转换为时长字符串
+ (instancetype)stringWithDuration:(int)duration {
    
    static const int kSecondsPerMinute = 60;
    static const int kSecondsPerHour = 3600;
    
    int hour = duration / kSecondsPerHour;
    int min = duration % kSecondsPerHour / kSecondsPerMinute;
    int sec = duration % kSecondsPerMinute;
    
    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hour, min, sec];
}

// 字节数转为字符串
+ (instancetype)stringWithBytes:(int)bytes {
    
    static const int kBytesPerKB = 1024;
    static const int kBytesPerMB = 1048576;
    
    int MB = bytes / kBytesPerMB;
    int KB = bytes % kBytesPerMB / kBytesPerKB;
    
    NSString *string;
    
    if (MB > 0) {
        
        string = [NSString stringWithFormat:@"%d M", MB];
        
    } else if (KB > 0) {
        
        string = [NSString stringWithFormat:@"%d K", KB];
        
    } else {
        
        string = @"1 K";
    }
    
    return string;
}

// AES字符串
- (NSString *)AESEncryptWithKey:(NSString *)key {
    
    char dataOut[32];
    
    size_t dataOutMoved = 0;
    
    CCCryptorStatus status = CCCrypt(kCCEncrypt,
                                     kCCAlgorithmAES,
                                     kCCOptionPKCS7Padding | kCCOptionECBMode,
                                     key.UTF8String,
                                     key.length,
                                     key.UTF8String,
                                     self.UTF8String,
                                     self.length,
                                     dataOut,
                                     32,
                                     &dataOutMoved);
    
    if (status != kCCSuccess) {
        
        return nil;
    }
    
    NSData *data = [NSData dataWithBytes:dataOut length:dataOutMoved];
    
    return [NSString hexStringFromData:data];
}

// 解密 AES 字符串
- (NSString *)AESDecryptWithKey:(NSString *)key {
    
    NSData *data = [self hexStringData];
    
    char dataOut[32];
    
    size_t dataOutMoved = 0;
    
    CCCryptorStatus status = CCCrypt(kCCDecrypt,
                                     kCCAlgorithmAES,
                                     kCCOptionPKCS7Padding | kCCOptionECBMode,
                                     key.UTF8String,
                                     kCCKeySizeAES128,
                                     key.UTF8String,
                                     data.bytes,
                                     data.length,
                                     dataOut,
                                     32,
                                     &dataOutMoved);
    
    if (status != kCCSuccess) {
        
        return nil;
    }
    
    return [[NSString alloc] initWithBytes:dataOut length:dataOutMoved encoding:NSUTF8StringEncoding];
}

// 数据生成十六进制字符串
+ (instancetype)hexStringFromData:(NSData *)data {
    
    if (data.length < 1) {
        
        return @"";
    }
    
    NSMutableString *string = [NSMutableString string];
    
    [data enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        
        for (int i = 0; i < byteRange.length; i++) {
            
            [string appendFormat:@"%02x", ((unsigned char *)bytes)[i]];
        }
    }];
    
    return string;
}

// 十六进制字符串转为数据
- (NSData *)hexStringData {
    
    if (self.length < 1) {
        
        return nil;
    }
    
    NSMutableData *data = [NSMutableData data];
    
    for (int i = 0; i < self.length; i += 2) {
        
        NSString *subString = [self substringWithRange:NSMakeRange(i, 2)];
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:subString];
        
        unsigned int i;
        
        [scanner scanHexInt:&i];
        
        [data appendBytes:&i length:1];
    }
    
    return data;
}

// 编码 base64 字符串
- (NSString *)base64Encode {

    if (self.length == 0) {

        return @"";
    }

    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

// 解码 base64 字符串
- (NSString *)base64Decode {

    if (self.length == 0) {

        return @"";
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

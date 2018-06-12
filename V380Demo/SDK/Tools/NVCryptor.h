//
//  NVCryptor.h
//  iCamSee
//
//  Created by macrovideo on 05/07/2017.
//  Copyright © 2017 macrovideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NVCryptor : NSObject
+(NSString *)Encode:(NSString *) strClearText;
+(NSString *)Decode:(NSString *) strCryptText;

+(NSString *)Base64Decode:(NSString *) strCryptText;
+(NSString *)Base64Encode:(NSString *) strClearText;
@end

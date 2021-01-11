//
//  HPEncryptionHelper.h
//  EncryptionPro
//
//  Created by Heping on 7/8/16.
//  Copyright © 2016 BONC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <Security/Security.h>

typedef NS_ENUM(NSUInteger, AESKeySizeOption) {
    kAESKeySizeOption128=kCCKeySizeAES128,
    kAESKeySizeOption192=kCCKeySizeAES192,
    kAESKeySizeOption256=kCCKeySizeAES256,
};

typedef NS_ENUM(NSUInteger, DESAlgorithOption) {
    kDESAlgorithOptionOnce,
    kDESAlgorithOptionTriple
};

@interface HPEncryptionHelper : NSObject
//MD5
+(NSString*)md5EncryptData:(NSData*)data;
+(NSString*)md5EncryptString:(NSString*)message;

//SHA1
+(NSString*)sha1EncryptData:(NSData*)data;
+(NSString*)sha1EncryptString:(NSString*)message;

//AES
+(NSData*)aesEncryptData:(NSData*)data withKey:(NSData*)keyData keySizeOption:(AESKeySizeOption)keySizeOption;
+(NSData*)aesDecryptData:(NSData*)data withKey:(NSData*)keyData keySizeOption:(AESKeySizeOption)keySizeOption;
+(NSString*)aesEncryptString:(NSString*)message withKey:(NSString*)keyString keySizeOption:(AESKeySizeOption)keySizeOption;
+(NSString*)aesDecryptSting:(NSString*)message withKey:(NSString*)keyString keySizeOption:(AESKeySizeOption)keySizeOption;

//DES
+(NSData*)desEncryptData:(NSData*)data withKey:(NSData*)keyData algorithOption:(DESAlgorithOption)option;
+(NSData*)desDecryptData:(NSData*)data withKey:(NSData*)keyData algorithOption:(DESAlgorithOption)option;
+(NSString*)desEncryptString:(NSString*)message withKey:(NSString*)keyString algorithOption:(DESAlgorithOption)option;
+(NSString*)desDecryptString:(NSString*)message withKey:(NSString*)keyString algorithOption:(DESAlgorithOption)option;

//RSA
+(SecKeyRef)publicSecKeyCreateFromData:(NSData*)derFileData;
+(SecKeyRef)privateSecKeyCreateFromData:(NSData*)p12FileData  passWord:(NSString*)p12pwd;
+(SecKeyRef)publicSecKeyCreateFromDerFilePath:(NSString*)keyStorePath;
+(SecKeyRef)privateSecKeyCreateFromP12FilePath:(NSString*)keyStorePath  passWord:(NSString*)p12pwd;
+(NSData*)rsaEncryptData:(NSData*)data withKey:(SecKeyRef)key;
+(NSData*)rsaDecryptData:(NSData*)data withKey:(SecKeyRef)key;
+(NSString*)rsaEncryptString:(NSString*)message withKey:(SecKeyRef)key;
+(NSString*)rsaDecryptSting:(NSString*)message withKey:(SecKeyRef)key;
@end

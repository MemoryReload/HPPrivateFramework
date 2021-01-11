//
//  HPEncryptionHelper.m
//  EncryptionPro
//
//  Created by Heping on 7/8/16.
//  Copyright © 2016 BONC. All rights reserved.
//

#import "HPEncryptionHelper.h"
#import <HPPrivateFramework/HPGTMBase64.h>

@implementation HPEncryptionHelper

#pragma mark -  MD5
//MD5
+(NSString*)md5EncryptData:(NSData*)data
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (unsigned int)data.length, result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    return hash;
}

+(NSString*)md5EncryptString:(NSString*)message
{
    NSData* stringData=[message dataUsingEncoding:NSUTF8StringEncoding];
    NSString* result=[self md5EncryptData:stringData];
    return result;
}

#pragma mark -  SHA1
//SHA1
+(NSString*)sha1EncryptData:(NSData*)data
{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    base64 = [HPGTMBase64 encodeData:base64];
    
    NSString * result = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return result;
}

+(NSString*)sha1EncryptString:(NSString*)message
{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSString* result=[self sha1EncryptData:data];
    return result;
}

#pragma mark -  AES
//AES
+(NSData*)aesEncryptData:(NSData*)data withKey:(NSData*)keyData keySizeOption:(AESKeySizeOption)keySizeOption
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[keySizeOption]; // room for key data
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    [keyData getBytes:keyPtr length:keySizeOption];// fetch key data
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);//room for encrypted data
    size_t numBytesEncrypted = 0;//encrypted data length
    
    CCCryptorStatus cryptStatus =CCCrypt(kCCEncrypt,kCCAlgorithmAES , kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, keySizeOption, NULL, data.bytes, data.length, buffer, bufferSize, &numBytesEncrypted);
    
    NSData* result;
    if (cryptStatus == kCCSuccess) {
        //make a new NSData object and copy buffer to it
        result=[NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    
    return result;
}

+(NSData*)aesDecryptData:(NSData*)data withKey:(NSData*)keyData keySizeOption:(AESKeySizeOption)keySizeOption
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[keySizeOption]; // room for key data
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    [keyData getBytes:keyPtr length:keySizeOption];// fetch key data
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);//room for encrypted data
    size_t numBytesEncrypted = 0;//encrypted data length
    
    CCCryptorStatus cryptStatus =CCCrypt(kCCDecrypt,kCCAlgorithmAES , kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, keySizeOption, NULL, data.bytes, data.length, buffer, bufferSize, &numBytesEncrypted);
    
    NSData* result;
    if (cryptStatus == kCCSuccess) {
        //make a new NSData object and copy buffer to it
        result=[NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    
    return result;
}

+(NSString*)aesEncryptString:(NSString*)message withKey:(NSString*)keyString keySizeOption:(AESKeySizeOption)keySizeOption
{
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData=[message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* outputData=[self aesEncryptData:messageData withKey:keyData keySizeOption:keySizeOption];
    outputData=[HPGTMBase64 encodeData:outputData];//Base64encoding
    
    NSString* result=[[NSString alloc]initWithBytes:outputData.bytes length:outputData.length encoding:NSUTF8StringEncoding];
    return result;
}

+(NSString*)aesDecryptSting:(NSString*)message withKey:(NSString*)keyString keySizeOption:(AESKeySizeOption)keySizeOption
{
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* messageData=[message dataUsingEncoding:NSUTF8StringEncoding];
    
    messageData=[HPGTMBase64 decodeData:messageData];//Base64decoding
    NSData* decryptedData=[self aesDecryptData:messageData withKey:keyData keySizeOption:keySizeOption];
    NSString* result=[[NSString alloc] initWithBytes:decryptedData.bytes length:decryptedData.length encoding:NSUTF8StringEncoding];
    return result;
}

#pragma mark -  DES
// DES
+(NSData*)desEncryptData:(NSData*)data withKey:(NSData*)keyData algorithOption:(DESAlgorithOption)option;
{
    size_t keyLen= option==kDESAlgorithOptionOnce?kCCKeySizeDES:kCCKeySize3DES;
    size_t blockSize= option==kDESAlgorithOptionOnce?kCCBlockSizeDES:kCCBlockSize3DES;
    CCAlgorithm algorithm= option==kDESAlgorithOptionOnce?kCCAlgorithmDES:kCCAlgorithm3DES;
    
    char key[keyLen];
    bzero(key, keyLen);
    [keyData getBytes:key length:keyLen];
    
    /*According to the documentation, the output data length is no more than its own length plus the block size*/
    size_t bufferSize=data.length+blockSize;
    void* buffer=malloc(bufferSize);
    size_t encrytedLen=0;
    
    CCCryptorStatus encryptStatus=CCCrypt(kCCEncrypt, algorithm, kCCOptionPKCS7Padding | kCCOptionECBMode, key, keyLen, NULL, data.bytes, data.length, buffer, bufferSize, &encrytedLen);
    
    NSData* resultData;
    if (encryptStatus==kCCSuccess) {
        resultData=[NSData dataWithBytes:buffer length:encrytedLen];
    }
    free(buffer);//free the buffer;
    
    return resultData;
}

+(NSData*)desDecryptData:(NSData*)data withKey:(NSData*)keyData algorithOption:(DESAlgorithOption)option
{
    size_t keyLen= option==kDESAlgorithOptionOnce?kCCKeySizeDES:kCCKeySize3DES;
    size_t blockSize= option==kDESAlgorithOptionOnce?kCCBlockSizeDES:kCCBlockSize3DES;
    CCAlgorithm algorithm= option==kDESAlgorithOptionOnce?kCCAlgorithmDES:kCCAlgorithm3DES;
    
    char key[keyLen];
    bzero(key, keyLen);
    [keyData getBytes:key length:keyLen];
    
    /*According to the documentation, the output data length is no more than its own length plus the block size*/
    size_t bufferSize=data.length+blockSize;
    void* buffer=malloc(bufferSize);
    size_t encrytedLen=0;
    
    CCCryptorStatus encryptStatus=CCCrypt(kCCDecrypt, algorithm, kCCOptionPKCS7Padding | kCCOptionECBMode, key, keyLen, NULL, data.bytes, data.length, buffer, bufferSize, &encrytedLen);
    
    NSData* resultData;
    if (encryptStatus==kCCSuccess) {
        resultData=[NSData dataWithBytes:buffer length:encrytedLen];
    }
    
    free(buffer);//free the buffer;
    
    return resultData;
}

+(NSString*)desEncryptString:(NSString*)message withKey:(NSString*)keyString algorithOption:(DESAlgorithOption)option
{
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData=[message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* outputData=[self desEncryptData:messageData withKey:keyData algorithOption:option];
    outputData=[HPGTMBase64 encodeData:outputData];//Base64encoding
    
    NSString* result=[[NSString alloc]initWithBytes:outputData.bytes length:outputData.length encoding:NSUTF8StringEncoding];
    return result;
}

+(NSString*)desDecryptString:(NSString*)message withKey:(NSString*)keyString algorithOption:(DESAlgorithOption)option
{
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* messageData=[message dataUsingEncoding:NSUTF8StringEncoding];
    
    messageData=[HPGTMBase64 decodeData:messageData];//Base64decoding
    NSData* decryptedData=[self desDecryptData:messageData withKey:keyData algorithOption:option];
    NSString* result=[[NSString alloc] initWithBytes:decryptedData.bytes length:decryptedData.length encoding:NSUTF8StringEncoding];
    return result;
}

#pragma mark -  RSA
//RSA

+(SecKeyRef)publicSecKeyCreateFromData:(NSData*)derFileData
{
    SecCertificateRef certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)derFileData);
    if (certificate == nil) {
        NSLog(@"Can not read certificate from PublicKeyStoreFile");
        return nil;
    }
    
    SecTrustRef trust;
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0) {
        NSLog(@"SecTrustCreateWithCertificates fail. Error Code: %d", (int)returnCode);
        return nil;
    }
    
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0) {
        NSLog(@"SecTrustEvaluate fail. Error Code: %d", (int)returnCode);
        return nil;
    }
    
    SecKeyRef publicKey = SecTrustCopyPublicKey(trust);
    if (publicKey == nil) {
        NSLog(@"SecTrustCopyPublicKey fail");
        return nil;
    }
    
    CFRelease(certificate);
    CFRelease(policy);
    CFRelease(trust);
    
    return publicKey;
}

+(SecKeyRef)privateSecKeyCreateFromData:(NSData*)p12FileData  passWord:(NSString*)p12pwd
{
    //put in the pwd
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: p12pwd forKey:(__bridge id)kSecImportExportPassphrase];
    //get the private key
    SecKeyRef privateKeyRef = NULL;
    CFArrayRef items;
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12FileData, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
            NSLog(@"Can not find ItemIdentity from Content");
        }
    }
    else{
        NSLog(@"Can not read Contents from PrviateKeyStoreFile");
    }
    CFRelease(items);
    
    return privateKeyRef;
}

+(SecKeyRef)publicSecKeyCreateFromDerFilePath:(NSString*)keyStorePath
{
    if (!keyStorePath | ![[NSFileManager defaultManager] fileExistsAtPath:keyStorePath isDirectory:nil]) {
        NSLog(@"Can not find PublicKeyStoreFile");
        return nil;
    }
    
    NSData *publicKeyFileContent = [NSData dataWithContentsOfFile:keyStorePath];
    if (publicKeyFileContent == nil) {
        NSLog(@"Can not read PublicKeyStoreFile");
        return nil;
    }
    
    return [self publicSecKeyCreateFromData:publicKeyFileContent];
}

+(SecKeyRef)privateSecKeyCreateFromP12FilePath:(NSString*)keyStorePath  passWord:(NSString*)p12pwd
{
    if (!keyStorePath | ![[NSFileManager defaultManager] fileExistsAtPath:keyStorePath isDirectory:nil]) {
        NSLog(@"Can not find PrviateKeyStoreFile");
        return nil;
    }
    
    NSData *privateKeyFileContent = [NSData dataWithContentsOfFile:keyStorePath];
    if (privateKeyFileContent == nil) {
        NSLog(@"Can not read PrviateKeyStoreFile");
        return nil;
    }
    
    return [self privateSecKeyCreateFromData:privateKeyFileContent passWord:p12pwd];
}

+(NSData*)rsaEncryptData:(NSData*)data withKey:(SecKeyRef)key
{
    //caculate the number of data blocks
    NSData *plainTextBytes = data;
    //according to the documentation, if kSecPaddingPKCS1 is used, plain text max length must be less than, or equal to SecKeyGetBlockSize(key) - 11.
    size_t blockSize = SecKeyGetBlockSize(key) - 11;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    //prepare cipherBuffer.
    uint8_t *cipherBuffer = malloc(SecKeyGetBlockSize(key) * sizeof(uint8_t));
    
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    
    for (int i=0; i<blockCount; i++) {
        
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        memset((void *)cipherBuffer, 0*0, SecKeyGetBlockSize(key));
        size_t cipherBufferSize = SecKeyGetBlockSize(key);
        
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        
        if (status == noErr){
            NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
            
        }else{
            
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    
    return [NSData dataWithData:encryptedData];
}

+(NSData*)rsaDecryptData:(NSData*)data withKey:(SecKeyRef)key
{
    NSData *plainTextBytes = data;
    size_t blockSize = SecKeyGetBlockSize(key);
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    
    NSMutableData *decryptedData = [NSMutableData dataWithCapacity:0];
    
    uint8_t *decryptedBuffer = malloc(SecKeyGetBlockSize(key) * sizeof(uint8_t));
    
    for (int i=0; i<blockCount; i++) {
        
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
        size_t decryptedBufferSize=SecKeyGetBlockSize(key);
        memset((void *)decryptedBuffer, 0*0, decryptedBufferSize);
        
        
        OSStatus status = SecKeyDecrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        decryptedBuffer,
                                        &decryptedBufferSize);
        
        if (status == noErr){
            NSData *decryptedBytes = [NSData dataWithBytes:(const void *)decryptedBuffer length:decryptedBufferSize];
            [decryptedData appendData:decryptedBytes];
        }else{
            if (decryptedBuffer) {
                free(decryptedBuffer);
            }
            return nil;
        }
    }
    if (decryptedBuffer) free(decryptedBuffer);
    
    return [NSData dataWithData:decryptedData];
}

+(NSString*)rsaEncryptString:(NSString*)message withKey:(SecKeyRef)key
{
    NSData* data=[message dataUsingEncoding:NSUTF8StringEncoding];
    NSData* resultData=[self rsaEncryptData:data withKey:key];
    resultData=[HPGTMBase64 encodeData:resultData];
    return [[NSString alloc]initWithBytes:resultData.bytes length:resultData.length encoding:NSUTF8StringEncoding];
}

+(NSString*)rsaDecryptSting:(NSString*)message withKey:(SecKeyRef)key
{
    NSData* data=[message dataUsingEncoding:NSUTF8StringEncoding];
    data=[HPGTMBase64 decodeData:data];
    NSData* resultData=[self rsaDecryptData:data withKey:key];
    return [[NSString alloc]initWithBytes:resultData.bytes length:resultData.length encoding:NSUTF8StringEncoding];
}
@end

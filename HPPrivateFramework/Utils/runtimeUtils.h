//
//  runtimeUtils.h
//  HPPrivateFramework
//
//  Created by HePing on 2021/3/21.
//

#ifndef runtimeUtils_h
#define runtimeUtils_h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

void swizzleMethod(Class aClass, SEL originalSel, SEL swizzledSel, BOOL instanceMethod);

#endif /* runtimeUtils_h */

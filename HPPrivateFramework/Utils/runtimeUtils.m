//
//  runtimeUtils.c
//  HPPrivateFramework
//
//  Created by HePing on 2021/3/21.
//

#include "runtimeUtils.h"

void swizzleMethod(Class aClass, SEL originalSel, SEL swizzledSel, BOOL instanceMethod)
{
    Class cls = nil;
    Method originalMethod = nil;
    Method swizzledMethod = nil;
    
    if (instanceMethod) {
        cls = aClass;
        originalMethod = class_getInstanceMethod(cls, originalSel);
        swizzledMethod = class_getInstanceMethod(cls, swizzledSel);
    }else{
        cls = object_getClass(aClass);
        originalMethod = class_getClassMethod(cls, originalSel);
        swizzledMethod = class_getClassMethod(cls, swizzledSel);
    }
    
    if (!originalMethod || !swizzledMethod) {
        @throw [[NSException alloc]initWithName:@"MethodSwizzlingError" reason:@"Specified method not found!" userInfo:nil];
    }
    
    /*
     * Since the class may inherited implementation from its superClass (class_getInstanceMethod search both class method
     * list and its superClass method list), to prevent damage of the superClass, we try to add the originalSel on the
     * class with IMP of swizzledMethod. If original method is inherited, this will succeed, or else failed.
     */
    BOOL addMethod = class_addMethod(cls, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (addMethod) {
         /*
         * If inherited from superClass, we've added the originalSel on the class with IMP of swizzledMethod ahead, so
         * what we need to do here is just replacing swizzledSel with IMP of originalMethod.
         */
        class_replaceMethod(cls, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else{
        //If not inherited from superClass, simply exchange IMP.
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

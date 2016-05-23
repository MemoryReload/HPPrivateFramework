//
//  UIButton+EventHandlerBlock.m
//  BNCExampleProj
//
//  Created by Heping on 5/12/16.
//  Copyright © 2016 BONC. All rights reserved.
//

#import "UIControl+EventHandlerBlock.h"
#import <objc/runtime.h>

#pragma mark - event selector name table
static  const NSString* kEventTouchDown=@"eventTouchDownHandler";
static  const NSString* kEventTouchDownRepeat=@"eventTouchDownRepeatHandler";
static  const NSString* kEventTouchDragInside=@"eventTouchDragInsideHandler";
static  const NSString* kEventTouchDragOutside=@"eventTouchDragOutsideHandler";
static  const NSString* kEventTouchDragEnter=@"eventTouchDragEnterHandler";
static  const NSString* kEventTouchDragExit=@"eventTouchDragExitHandler";
static  const NSString* kEventTouchUpInside=@"eventTouchUpInsideHandler";
static  const NSString* kEventTouchUpOutside=@"eventTouchUpOutsideHandler";
static  const NSString* kEventTouchCancel=@"eventTouchCancelHandler";
static  const NSString* kEventValueChanged=@"eventValueChangedHandler";
static  const NSString* kEventPrimaryActionTriggered=@"eventPrimaryActionTriggeredHandler";
static  const NSString* kEventEditingDidBegin=@"eventEditingDidBeginHandler";
static  const NSString* kEventEditingChanged=@"eventEditingChangedHandler";
static  const NSString* kEventEditingDidEnd=@"eventEditingDidEndHandler";
static  const NSString* kEventEditingDidEndOnExit=@"eventEditingDidEndOnExitHandler";
static  const NSString* kEventAllTouchEvents=@"eventAllTouchEventsHandler";
static  const NSString* kEventAllEditingEvents=@"eventAllEditingEventsHandler";
static  const NSString* kEventApplicationReserved=@"eventApplicationReservedHandler";
static  const NSString* kEventSystemReserved=@"eventSystemReservedHandler";
static  const NSString* kEventAllEvents=@"eventAllEventsHandler";

@implementation UIControl(EventHandlerBlock)

-(void)setEventHandler:(EventHandlerBlock)block  withControlEvent:(UIControlEvents)event
{
    NSString* key=[UIControl getHandlerAssociationKeyWithEvent:event];
    if (!key) {
        return ;
    }
    objc_setAssociatedObject(self, (__bridge const void *)(key), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    SEL selector=[UIControl getSelectorAssociationKeyWithEvent:event];
    [self addTarget:self action:selector forControlEvents:event];
}

#pragma mark - tools method
+(NSString*)getHandlerAssociationKeyWithEvent:(UIControlEvents)event
{
   const NSString* associationKey;
    switch (event) {
        case UIControlEventTouchDown:
            associationKey=kEventTouchDown;
            break;
        case UIControlEventTouchDownRepeat:
            associationKey=kEventTouchDownRepeat;
            break;
        case UIControlEventTouchDragInside:
            associationKey=kEventTouchDragInside;
            break;
        case UIControlEventTouchDragOutside:
            associationKey=kEventTouchDragOutside;
            break;
        case UIControlEventTouchDragEnter:
            associationKey=kEventTouchDragEnter;
            break;
        case UIControlEventTouchDragExit:
            associationKey=kEventTouchDragExit;
            break;
        case UIControlEventTouchUpInside:
            associationKey=kEventTouchUpInside;
            break;
        case UIControlEventTouchUpOutside:
            associationKey=kEventTouchUpOutside;
            break;
        case UIControlEventTouchCancel:
            associationKey=kEventTouchCancel;
            break;
        case UIControlEventValueChanged:
            associationKey=kEventValueChanged;
            break;
        case UIControlEventPrimaryActionTriggered:
            associationKey=kEventPrimaryActionTriggered;
            break;
        case UIControlEventEditingDidBegin:
            associationKey=kEventEditingDidBegin;
            break;
        case UIControlEventEditingChanged:
            associationKey=kEventEditingChanged;
            break;
        case UIControlEventEditingDidEnd:
            associationKey=kEventEditingDidEnd;
            break;
        case UIControlEventEditingDidEndOnExit:
            associationKey=kEventEditingDidEndOnExit;
            break;
        case UIControlEventAllTouchEvents:
            associationKey=kEventAllTouchEvents;
            break;
        case UIControlEventAllEditingEvents:
            associationKey=kEventAllEditingEvents;
            break;
        case UIControlEventApplicationReserved:
            associationKey=kEventApplicationReserved;
            break;
        case UIControlEventSystemReserved:
            associationKey=kEventSystemReserved;
            break;
        case UIControlEventAllEvents:
            associationKey=kEventAllEvents;
            break;
        default:
            break;
    }
    return (NSString*)associationKey;
}

+(SEL)getSelectorAssociationKeyWithEvent:(UIControlEvents)event
{
    NSString* selectorName=[UIControl getHandlerAssociationKeyWithEvent:event];
    const char* name=[selectorName cStringUsingEncoding:NSUTF8StringEncoding];
    return sel_registerName(name);
}

#pragma mark - event handler
-(void)eventTouchDownHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventTouchDown));
    block();
}

-(void)eventTouchDragInsideHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventTouchDragInside));
    block();
}

-(void)eventTouchDragOutsideHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventTouchDragOutside));
    block();
}

-(void)eventTouchDragEnterHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventTouchDragEnter));
    block();
}

-(void)eventTouchDragExitHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventTouchDragExit));
    block();
}

-(void)eventTouchUpInsideHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventTouchUpInside));
    block();
}

-(void)eventTouchUpOutsideHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventTouchUpOutside));
    block();
}

-(void)eventTouchCancelHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventTouchCancel));
    block();
}

-(void)eventValueChangedHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventValueChanged));
    block();
}

-(void)eventPrimaryActionTriggeredHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventPrimaryActionTriggered));
    block();
}

-(void)eventEditingDidBeginHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventEditingDidBegin));
    block();
}

-(void)eventEditingChangedHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventEditingChanged));
    block();
}

-(void)eventEditingDidEndHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventEditingDidEnd));
    block();
}

-(void)eventEditingDidEndOnExitHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventEditingDidEndOnExit));
    block();
}

-(void)eventAllTouchEventsHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventAllTouchEvents));
    block();
}

-(void)eventAllEditingEventsHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventAllEditingEvents));
    block();
}

-(void)eventApplicationReservedHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventApplicationReserved));
    block();
}

-(void)eventSystemReservedHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventSystemReserved));
    block();
}

-(void)eventAllEventsHandler
{
    EventHandlerBlock block=objc_getAssociatedObject(self, (__bridge const void *)(kEventAllEvents));
    block();
}
@end

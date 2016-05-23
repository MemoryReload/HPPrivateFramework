//
//  CAAnimation+CustomedTimingAnimation.m
//  CustomEasingFunction
//
//  Created by Heping on 15/12/30.
//  Copyright © 2015年 BONC. All rights reserved.
//

#import "CAAnimation+CustomedTimingAnimation.h"
#import "CACustomedTimingAddtions.h"

#if !defined(CACustomedframeCountPerSecond)
// The larger this number, the smoother the animation
#define CACustomedframeCountPerSecond 60
#endif

// Linear interpolation (no easing)
const CACustomedTimingFuction CACustomedTimingFuctionLinear=&LinearInterpolation;

// Quadratic easing; p^2
const CACustomedTimingFuction CACustomedTimingFuctionQuadraticEaseIn=&QuadraticEaseIn;
const CACustomedTimingFuction CACustomedTimingFuctionQuadraticEaseOut=&QuadraticEaseOut;
const CACustomedTimingFuction CACustomedTimingFuctionQuadraticEaseInOut=&QuadraticEaseInOut;

// Cubic easing; p^3
const CACustomedTimingFuction CACustomedTimingFuctionCubicEaseIn=&CubicEaseIn;
const CACustomedTimingFuction CACustomedTimingFuctionCubicEaseOut=&CubicEaseOut;
const CACustomedTimingFuction CACustomedTimingFuctionCubicEaseInOut=CubicEaseInOut;

// Quartic easing; p^4
const CACustomedTimingFuction CACustomedTimingFuctionQuarticEaseIn=&QuarticEaseIn;
const CACustomedTimingFuction CACustomedTimingFuctionQuarticEaseOut=&QuarticEaseOut;
const CACustomedTimingFuction CACustomedTimingFuctionQuarticEaseInOut=&QuarticEaseInOut;

// Quintic easing; p^5
const CACustomedTimingFuction CACustomedTimingFuctionQuinticEaseIn=&QuinticEaseIn;
const CACustomedTimingFuction CACustomedTimingFuctionQuinticEaseOut=&QuinticEaseOut;
const CACustomedTimingFuction CACustomedTimingFuctionQuinticEaseInOut=&QuinticEaseInOut;

// Sine wave easing; sin(p * PI/2)
const CACustomedTimingFuction CACustomedTimingFuctionSineEaseIn=&SineEaseIn;
const CACustomedTimingFuction CACustomedTimingFuctionSineEaseOut=&SineEaseOut;
const CACustomedTimingFuction CACustomedTimingFuctionSineEaseInOut=&SineEaseInOut;

// Circular easing; sqrt(1 - p^2)
const CACustomedTimingFuction CACustomedTimingFuctionCircularEaseIn=&CircularEaseIn;
const CACustomedTimingFuction CACustomedTimingFuctionCircularEaseOut=&CircularEaseOut;
const CACustomedTimingFuction CACustomedTimingFuctionCircularEaseInOut=&CircularEaseInOut;

// Exponential easing, base 2
const CACustomedTimingFuction CACustomedTimingFuctionExponentialEaseIn=&ExponentialEaseIn;
const CACustomedTimingFuction CACustomedTimingFuctionExponentialEaseOut=&ExponentialEaseOut;
const CACustomedTimingFuction CACustomedTimingFuctionExponentialEaseInOut=&ExponentialEaseInOut;

// Exponentially-damped sine wave easing
const CACustomedTimingFuction CACustomedTimingFuctionElasticEaseIn=&ElasticEaseIn;
const CACustomedTimingFuction CACustomedTimingFuctionElasticEaseOut=&ElasticEaseOut;
const CACustomedTimingFuction CACustomedTimingFuctionElasticEaseInOut=&ElasticEaseInOut;

// Overshooting cubic easing;
const CACustomedTimingFuction CACustomedTimingFuctionBackEaseIn=&BackEaseIn;
const CACustomedTimingFuction CACustomedTimingFuctionBackEaseOut=&BackEaseOut;
const CACustomedTimingFuction CACustomedTimingFuctionBackEaseInOut=&BackEaseInOut;

// Exponentially-decaying bounce easing
const CACustomedTimingFuction CACustomedTimingFuctionBounceEaseIn=&BounceEaseIn;
const CACustomedTimingFuction CACustomedTimingFuctionBounceEaseOut=&BounceEaseOut;
const CACustomedTimingFuction CACustomedTimingFuctionBounceEaseInOut=&BounceEaseInOut;

#pragma mark - Tool Functions

//颜色空间转换
void CGColorGetRGBComponents(CGFloat* components, CGColorRef color) {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, color);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 4; component++) {
        if (component==3) components[component]=resultingPixel[component];
        else components[component] = resultingPixel[component] / 255.0f;
    }
}

//单值插值计算（初值末值）
float interpolate(float from,float to ,float time)
{
    return (to-from)*time+from;
}

//单值插值算法（初值差值）
float interpolateWithDeta(float from,float deta,float time)
{
    return deta*time+from;
}

//复合值插值计算
id interpolateValue(id fromValue,id toValue,float time)
{
    //dealing with numbers
    if ([fromValue isKindOfClass:[NSNumber class]]) {
        return [NSNumber numberWithFloat:interpolate([fromValue floatValue], [toValue floatValue], time)];
    }
    
    //dealing with structs
    if ([fromValue isKindOfClass:[NSValue class]]) {
        const char*  type=[fromValue objCType];
        if (strcmp(@encode(CGPoint),type)==0) {
            //dealing with CGPoint
            CGPoint fromPoint=[fromValue CGPointValue];
            CGPoint toPoint=[toValue CGPointValue];
            
            float interpolateX=interpolate(fromPoint.x, toPoint.x, time);
            float interpolateY=interpolate(fromPoint.y, toPoint.y, time);
            CGPoint interpolatePoint=CGPointMake(interpolateX, interpolateY);
            return  [NSValue valueWithCGPoint:interpolatePoint];
        }
        else if (strcmp(@encode(CGSize),type)==0)
        {
            //dealing with CGSize
            CGSize fromSize=[fromValue CGSizeValue];
            CGSize toSize=[toValue CGSizeValue];
            
            float interpolateWidth=interpolate(fromSize.width, toSize.width, time);
            float interpolateHeight=interpolate(fromSize.height, toSize.height, time);
            CGSize interpolateSize=CGSizeMake(interpolateWidth, interpolateHeight);
            return [NSValue valueWithCGSize:interpolateSize];
        }
        else if (strcmp(@encode(CGRect), type)==0){
            CGRect fromRect=[fromValue CGRectValue];
            CGRect toRect=[toValue CGRectValue];
            CGFloat interpolateX=interpolate(fromRect.origin.x, toRect.origin.x, time);
            CGFloat interpolateY=interpolate(fromRect.origin.y, toRect.origin.y, time);
            CGFloat interpolateWidth=interpolate(fromRect.size.width, toRect.size.width, time);
            CGFloat interpolateHeight=interpolate(fromRect.size.height, toRect.size.height, time);
            CGRect interpolateRect=CGRectMake(interpolateX, interpolateY, interpolateWidth, interpolateHeight);
            return [NSValue valueWithCGRect:interpolateRect];
        }
        else if (strcmp(@encode(CGAffineTransform), type)==0)
        {
            //dealing with CGAffineTransform
            CGAffineTransform fromTransform=[fromValue CGAffineTransformValue];
            CGAffineTransform toTransform=[toValue CGAffineTransformValue];
            
            //translation
            CGPoint fromTranslation = CGPointMake(fromTransform.tx, fromTransform.ty);
            CGPoint toTranslation = CGPointMake(toTransform.tx, toTransform.ty);
            
            //scale
            CGFloat fromScale = hypot(fromTransform.a, fromTransform.c);
            CGFloat toScale = hypot(toTransform.a, toTransform.c);
            
            //rotation
            CGFloat fromRotation = atan2(fromTransform.c, fromTransform.a);
            CGFloat toRotation = atan2(toTransform.c, toTransform.a);
            // detaRotation special handling
            CGFloat deltaRotation = toRotation - fromRotation;
            if (deltaRotation < -M_PI)
                deltaRotation += (2 * M_PI);
            else if (deltaRotation > M_PI)
                deltaRotation -= (2 * M_PI);
            CGFloat interpolateRotation=interpolateWithDeta(fromScale, deltaRotation, time);
            
            CGFloat interpolateTranslationX=interpolate(fromTranslation.x, toTranslation.x, time);
            CGFloat interpolateTranslationY=interpolate(fromTranslation.y, toTranslation.y, time);
            CGFloat interpolateScale=interpolate(fromScale, toScale, time);
            
            CGAffineTransform interpolateAffineTransform = CGAffineTransformMake(interpolateScale * cos(interpolateRotation), -interpolateScale * sin(interpolateRotation),interpolateScale * sin(interpolateRotation), interpolateScale * cos(interpolateRotation),interpolateTranslationX, interpolateTranslationY);
            
            CATransform3D interpolateTransform = CATransform3DMakeAffineTransform(interpolateAffineTransform);
            return [NSValue valueWithCATransform3D:interpolateTransform];
        }
    }
    else if ((__bridge CGColorRef)fromValue&&(__bridge CGColorRef)toValue)
    {
        //dealing with CGColor
        CGColorRef fromColor=(__bridge CGColorRef)fromValue;
        CGColorRef toColor=(__bridge CGColorRef)toValue;
        
        //Color must be RGBA
        CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
        size_t componentsNum=4;
        CGFloat fromColorComponents[componentsNum];
        CGFloat toColorComponents[componentsNum];
        CGFloat interpolateComponents[componentsNum];
        //get original colors components
        CGColorGetRGBComponents(fromColorComponents, fromColor);
        CGColorGetRGBComponents(toColorComponents, toColor);
        //caculate interpolate components
        for (NSInteger i=0; i<componentsNum; i++) {
            interpolateComponents[i]=interpolate(fromColorComponents[i],toColorComponents[i] , time);
        }
        CGColorRef interpolateColor=CGColorCreate(colorSpace, interpolateComponents);
        return (__bridge_transfer id)interpolateColor;
    }
    return (time<0.5)?fromValue:toValue;
}

#pragma mark - CAAnimation
@implementation CAAnimation(CustomedTimingAnimation)

+(CAAnimation*)animationWithKeyPath:(NSString*)keyPath  fromValue:(id)fromValue   toValue:(id)toValue customedTimingFuction:(CACustomedTimingFuction)timingFuction  duration:(CFTimeInterval)duration
{
    //create key frames array
    NSInteger frameNums=round(duration*CACustomedframeCountPerSecond);
    NSMutableArray* framesArray=[[NSMutableArray alloc] init];
    for (NSInteger i=0; i<frameNums; i++) {
        CGFloat time=1.0f/(frameNums-1)*i;
        if (!timingFuction) {
            timingFuction=CACustomedTimingFuctionLinear;
        }
        time=timingFuction(time);
        NSValue* value=interpolateValue(fromValue, toValue, time);
        [framesArray addObject:value];
    }
    
    //create animation
    CAKeyframeAnimation* keyFrameAnimation=[CAKeyframeAnimation animationWithKeyPath:keyPath];
    keyFrameAnimation.values=framesArray;
    keyFrameAnimation.duration=duration;
    return keyFrameAnimation;
}
@end
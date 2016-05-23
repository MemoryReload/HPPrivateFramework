//
//  CAAnimation+CustomedTimingAnimation.h
//  CustomEasingFunction
//
//  Created by Heping on 15/12/30.
//  Copyright © 2015年 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef CGFloat (*CACustomedTimingFuction)(CGFloat);

// Linear interpolation (no easing)
extern const CACustomedTimingFuction CACustomedTimingFuctionLinear;
// Quadratic easing; p^2
extern const CACustomedTimingFuction CACustomedTimingFuctionQuadraticEaseIn;
extern const CACustomedTimingFuction CACustomedTimingFuctionQuadraticEaseOut;
extern const CACustomedTimingFuction CACustomedTimingFuctionQuadraticEaseInOut;
// Cubic easing; p^3
extern const CACustomedTimingFuction CACustomedTimingFuctionCubicEaseIn;
extern const CACustomedTimingFuction CACustomedTimingFuctionCubicEaseOut;
extern const CACustomedTimingFuction CACustomedTimingFuctionCubicEaseInOut;
// Quartic easing; p^4
extern const CACustomedTimingFuction CACustomedTimingFuctionQuarticEaseIn;
extern const CACustomedTimingFuction CACustomedTimingFuctionQuarticEaseOut;
extern const CACustomedTimingFuction CACustomedTimingFuctionQuarticEaseInOut;
// Quintic easing; p^5
extern const CACustomedTimingFuction CACustomedTimingFuctionQuinticEaseIn;
extern const CACustomedTimingFuction CACustomedTimingFuctionQuinticEaseOut;
extern const CACustomedTimingFuction CACustomedTimingFuctionQuinticEaseInOut;
// Sine wave easing; sin(p * PI/2)
extern const CACustomedTimingFuction CACustomedTimingFuctionSineEaseIn;
extern const CACustomedTimingFuction CACustomedTimingFuctionSineEaseOut;
extern const CACustomedTimingFuction CACustomedTimingFuctionSineEaseInOut;
// Circular easing; sqrt(1 - p^2)
extern const CACustomedTimingFuction CACustomedTimingFuctionCircularEaseIn;
extern const CACustomedTimingFuction CACustomedTimingFuctionCircularEaseOut;
extern const CACustomedTimingFuction CACustomedTimingFuctionCircularEaseInOut;
// Exponential easing, base 2
extern const CACustomedTimingFuction CACustomedTimingFuctionExponentialEaseIn;
extern const CACustomedTimingFuction CACustomedTimingFuctionExponentialEaseOut;
extern const CACustomedTimingFuction CACustomedTimingFuctionExponentialEaseInOut;
// Exponentially-damped sine wave easing
extern const CACustomedTimingFuction CACustomedTimingFuctionElasticEaseIn;
extern const CACustomedTimingFuction CACustomedTimingFuctionElasticEaseOut;
extern const CACustomedTimingFuction CACustomedTimingFuctionElasticEaseInOut;
// Overshooting cubic easing;
extern const CACustomedTimingFuction CACustomedTimingFuctionBackEaseIn;
extern const CACustomedTimingFuction CACustomedTimingFuctionBackEaseOut;
extern const CACustomedTimingFuction CACustomedTimingFuctionBackEaseInOut;
// Exponentially-decaying bounce easing
extern const CACustomedTimingFuction CACustomedTimingFuctionBounceEaseIn;
extern const CACustomedTimingFuction CACustomedTimingFuctionBounceEaseOut;
extern const CACustomedTimingFuction CACustomedTimingFuctionBounceEaseInOut;

@interface CAAnimation (CustomedTimingAnimation)
+(CAAnimation*)animationWithKeyPath:(NSString*)keyPath  fromValue:(id)fromValue   toValue:(id)toValue customedTimingFuction:(CACustomedTimingFuction)timingFuction duration:(CFTimeInterval) duration;
@end

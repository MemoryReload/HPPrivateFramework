//
//  CAAnimation+CustomedTimingAnimation.h
//  CustomEasingFunction
//
//  Created by Heping on 15/12/30.
//  Copyright © 2015年 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CACustomedTimingAddtions.h"

typedef CustomedTimingFuction CACustomedTimingFuction;

@interface CAAnimation (CustomedTimingAnimation)
+(CAAnimation*)animationWithKeyPath:(NSString*)keyPath  fromValue:(id)fromValue   toValue:(id)toValue customedTimingFuction:(CACustomedTimingFuction)timingFuction duration:(CFTimeInterval) duration;
@end


// Linear interpolation (no easing)
extern const CACustomedTimingFuction kCACustomedTimingFuctionLinear;

// Quadratic easing; p^2
extern const CACustomedTimingFuction kCACustomedTimingFuctionQuadraticEaseIn;
extern const CACustomedTimingFuction kCACustomedTimingFuctionQuadraticEaseOut;
extern const CACustomedTimingFuction kCACustomedTimingFuctionQuadraticEaseInOut;

// Cubic easing; p^3
extern const CACustomedTimingFuction kCACustomedTimingFuctionCubicEaseIn;
extern const CACustomedTimingFuction kCACustomedTimingFuctionCubicEaseOut;
extern const CACustomedTimingFuction kCACustomedTimingFuctionCubicEaseInOut;

// Quartic easing; p^4
extern const CACustomedTimingFuction kCACustomedTimingFuctionQuarticEaseIn;
extern const CACustomedTimingFuction kCACustomedTimingFuctionQuarticEaseOut;
extern const CACustomedTimingFuction kCACustomedTimingFuctionQuarticEaseInOut;

// Quintic easing; p^5
extern const CACustomedTimingFuction kCACustomedTimingFuctionQuinticEaseIn;
extern const CACustomedTimingFuction kCACustomedTimingFuctionQuinticEaseOut;
extern const CACustomedTimingFuction kCACustomedTimingFuctionQuinticEaseInOut;

// Sine wave easing; sin(p * PI/2)
extern const CACustomedTimingFuction kCACustomedTimingFuctionSineEaseIn;
extern const CACustomedTimingFuction kCACustomedTimingFuctionSineEaseOut;
extern const CACustomedTimingFuction kCACustomedTimingFuctionSineEaseInOut;

// Circular easing; sqrt(1 - p^2)
extern const CACustomedTimingFuction kCACustomedTimingFuctionCircularEaseIn;
extern const CACustomedTimingFuction kCACustomedTimingFuctionCircularEaseOut;
extern const CACustomedTimingFuction kCACustomedTimingFuctionCircularEaseInOut;

// Exponential easing, base 2
extern const CACustomedTimingFuction kCACustomedTimingFuctionExponentialEaseIn;
extern const CACustomedTimingFuction kCACustomedTimingFuctionExponentialEaseOut;
extern const CACustomedTimingFuction kCACustomedTimingFuctionExponentialEaseInOut;

// Exponentially-damped sine wave easing
extern const CACustomedTimingFuction kCACustomedTimingFuctionElasticEaseIn;
extern const CACustomedTimingFuction kCACustomedTimingFuctionElasticEaseOut;
extern const CACustomedTimingFuction kCACustomedTimingFuctionElasticEaseInOut;

// Overshooting cubic easing;
extern const CACustomedTimingFuction kCACustomedTimingFuctionBackEaseIn;
extern const CACustomedTimingFuction kCACustomedTimingFuctionBackEaseOut;
extern const CACustomedTimingFuction kCACustomedTimingFuctionBackEaseInOut;

// Exponentially-decaying bounce easing
extern const CACustomedTimingFuction kCACustomedTimingFuctionBounceEaseIn;
extern const CACustomedTimingFuction kCACustomedTimingFuctionBounceEaseOut;
extern const CACustomedTimingFuction kCACustomedTimingFuctionBounceEaseInOut;

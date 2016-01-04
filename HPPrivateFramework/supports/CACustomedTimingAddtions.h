//
//  CACustomedTimingAddtions.h
//  CustomEasingFunction
//
//  Created by Heping on 15/12/31.
//  Copyright © 2015年 BONC. All rights reserved.
//

#ifndef CACustomedTimingAddtions_h
#define CACustomedTimingAddtions_h

#include <stdio.h>

#if defined(__LP64__) && !defined(CA_EASING_USE_DBL_PRECIS)
#define CA_EASING_USE_DBL_PRECIS
#endif

#ifdef CA_EASING_USE_DBL_PRECIS
#define CACFloat double
#else
#define CACFloat float
#endif

#if defined __cplusplus
extern "C" {
#endif
    
    typedef CACFloat (*CustomedTimingFuction)(CACFloat);
    
    // Linear interpolation (no easing)
    CACFloat LinearInterpolation(CACFloat p);
    
    // Quadratic easing; p^2
    CACFloat QuadraticEaseIn(CACFloat p);
    CACFloat QuadraticEaseOut(CACFloat p);
    CACFloat QuadraticEaseInOut(CACFloat p);
    
    // Cubic easing; p^3
    CACFloat CubicEaseIn(CACFloat p);
    CACFloat CubicEaseOut(CACFloat p);
    CACFloat CubicEaseInOut(CACFloat p);
    
    // Quartic easing; p^4
    CACFloat QuarticEaseIn(CACFloat p);
    CACFloat QuarticEaseOut(CACFloat p);
    CACFloat QuarticEaseInOut(CACFloat p);
    
    // Quintic easing; p^5
    CACFloat QuinticEaseIn(CACFloat p);
    CACFloat QuinticEaseOut(CACFloat p);
    CACFloat QuinticEaseInOut(CACFloat p);
    
    // Sine wave easing; sin(p * PI/2)
    CACFloat SineEaseIn(CACFloat p);
    CACFloat SineEaseOut(CACFloat p);
    CACFloat SineEaseInOut(CACFloat p);
    
    // Circular easing; sqrt(1 - p^2)
    CACFloat CircularEaseIn(CACFloat p);
    CACFloat CircularEaseOut(CACFloat p);
    CACFloat CircularEaseInOut(CACFloat p);
    
    // Exponential easing, base 2
    CACFloat ExponentialEaseIn(CACFloat p);
    CACFloat ExponentialEaseOut(CACFloat p);
    CACFloat ExponentialEaseInOut(CACFloat p);
    
    // Exponentially-damped sine wave easing
    CACFloat ElasticEaseIn(CACFloat p);
    CACFloat ElasticEaseOut(CACFloat p);
    CACFloat ElasticEaseInOut(CACFloat p);
    
    // Overshooting cubic easing;
    CACFloat BackEaseIn(CACFloat p);
    CACFloat BackEaseOut(CACFloat p);
    CACFloat BackEaseInOut(CACFloat p);
    
    // Exponentially-decaying bounce easing
    CACFloat BounceEaseIn(CACFloat p);
    CACFloat BounceEaseOut(CACFloat p);
    CACFloat BounceEaseInOut(CACFloat p);
    
#ifdef __cplusplus
}
#endif

#endif /* CACustomedTimingAddtions_h */

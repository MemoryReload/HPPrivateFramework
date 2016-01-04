//
//  CACustomedTimingAddtions.c
//  CustomEasingFunction
//
//  Created by Heping on 15/12/31.
//  Copyright © 2015年 BONC. All rights reserved.
//

#include "CACustomedTimingAddtions.h"
#include <math.h>

// Modeled after the line y = x
CACFloat LinearInterpolation(CACFloat p)
{
    return p;
}

// Modeled after the parabola y = x^2
CACFloat QuadraticEaseIn(CACFloat p)
{
    return p * p;
}

// Modeled after the parabola y = -x^2 + 2x
CACFloat QuadraticEaseOut(CACFloat p)
{
    return -(p * (p - 2));
}

// Modeled after the piecewise quadratic
// y = (1/2)((2x)^2)             ; [0, 0.5)
// y = -(1/2)((2x-1)*(2x-3) - 1) ; [0.5, 1]
CACFloat QuadraticEaseInOut(CACFloat p)
{
    if(p < 0.5)
    {
        return 2 * p * p;
    }
    else
    {
        return (-2 * p * p) + (4 * p) - 1;
    }
}

// Modeled after the cubic y = x^3
CACFloat CubicEaseIn(CACFloat p)
{
    return p * p * p;
}

// Modeled after the cubic y = (x - 1)^3 + 1
CACFloat CubicEaseOut(CACFloat p)
{
    CACFloat f = (p - 1);
    return f * f * f + 1;
}

// Modeled after the piecewise cubic
// y = (1/2)((2x)^3)       ; [0, 0.5)
// y = (1/2)((2x-2)^3 + 2) ; [0.5, 1]
CACFloat CubicEaseInOut(CACFloat p)
{
    if(p < 0.5)
    {
        return 4 * p * p * p;
    }
    else
    {
        CACFloat f = ((2 * p) - 2);
        return 0.5 * f * f * f + 1;
    }
}

// Modeled after the quartic x^4
CACFloat QuarticEaseIn(CACFloat p)
{
    return p * p * p * p;
}

// Modeled after the quartic y = 1 - (x - 1)^4
CACFloat QuarticEaseOut(CACFloat p)
{
    CACFloat f = (p - 1);
    return f * f * f * (1 - p) + 1;
}

// Modeled after the piecewise quartic
// y = (1/2)((2x)^4)        ; [0, 0.5)
// y = -(1/2)((2x-2)^4 - 2) ; [0.5, 1]
CACFloat QuarticEaseInOut(CACFloat p)
{
    if(p < 0.5)
    {
        return 8 * p * p * p * p;
    }
    else
    {
        CACFloat f = (p - 1);
        return -8 * f * f * f * f + 1;
    }
}

// Modeled after the quintic y = x^5
CACFloat QuinticEaseIn(CACFloat p)
{
    return p * p * p * p * p;
}

// Modeled after the quintic y = (x - 1)^5 + 1
CACFloat QuinticEaseOut(CACFloat p)
{
    CACFloat f = (p - 1);
    return f * f * f * f * f + 1;
}

// Modeled after the piecewise quintic
// y = (1/2)((2x)^5)       ; [0, 0.5)
// y = (1/2)((2x-2)^5 + 2) ; [0.5, 1]
CACFloat QuinticEaseInOut(CACFloat p)
{
    if(p < 0.5)
    {
        return 16 * p * p * p * p * p;
    }
    else
    {
        CACFloat f = ((2 * p) - 2);
        return  0.5 * f * f * f * f * f + 1;
    }
}

// Modeled after quarter-cycle of sine wave
CACFloat SineEaseIn(CACFloat p)
{
    return sin((p - 1) * M_PI_2) + 1;
}

// Modeled after quarter-cycle of sine wave (different phase)
CACFloat SineEaseOut(CACFloat p)
{
    return sin(p * M_PI_2);
}

// Modeled after half sine wave
CACFloat SineEaseInOut(CACFloat p)
{
    return 0.5 * (1 - cos(p * M_PI));
}

// Modeled after shifted quadrant IV of unit circle
CACFloat CircularEaseIn(CACFloat p)
{
    return 1 - sqrt(1 - (p * p));
}

// Modeled after shifted quadrant II of unit circle
CACFloat CircularEaseOut(CACFloat p)
{
    return sqrt((2 - p) * p);
}

// Modeled after the piecewise circular function
// y = (1/2)(1 - sqrt(1 - 4x^2))           ; [0, 0.5)
// y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) ; [0.5, 1]
CACFloat CircularEaseInOut(CACFloat p)
{
    if(p < 0.5)
    {
        return 0.5 * (1 - sqrt(1 - 4 * (p * p)));
    }
    else
    {
        return 0.5 * (sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1);
    }
}

// Modeled after the exponential function y = 2^(10(x - 1))
CACFloat ExponentialEaseIn(CACFloat p)
{
    return (p == 0.0) ? p : pow(2, 10 * (p - 1));
}

// Modeled after the exponential function y = -2^(-10x) + 1
CACFloat ExponentialEaseOut(CACFloat p)
{
    return (p == 1.0) ? p : 1 - pow(2, -10 * p);
}

// Modeled after the piecewise exponential
// y = (1/2)2^(10(2x - 1))         ; [0,0.5)
// y = -(1/2)*2^(-10(2x - 1))) + 1 ; [0.5,1]
CACFloat ExponentialEaseInOut(CACFloat p)
{
    if(p == 0.0 || p == 1.0) return p;
    
    if(p < 0.5)
    {
        return 0.5 * pow(2, (20 * p) - 10);
    }
    else
    {
        return -0.5 * pow(2, (-20 * p) + 10) + 1;
    }
}

// Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
CACFloat ElasticEaseIn(CACFloat p)
{
    return sin(13 * M_PI_2 * p) * pow(2, 10 * (p - 1));
}

// Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
CACFloat ElasticEaseOut(CACFloat p)
{
    return sin(-13 * M_PI_2 * (p + 1)) * pow(2, -10 * p) + 1;
}

// Modeled after the piecewise exponentially-damped sine wave:
// y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      ; [0,0.5)
// y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) ; [0.5, 1]
CACFloat ElasticEaseInOut(CACFloat p)
{
    if(p < 0.5)
    {
        return 0.5 * sin(13 * M_PI_2 * (2 * p)) * pow(2, 10 * ((2 * p) - 1));
    }
    else
    {
        return 0.5 * (sin(-13 * M_PI_2 * ((2 * p - 1) + 1)) * pow(2, -10 * (2 * p - 1)) + 2);
    }
}

// Modeled after the overshooting cubic y = x^3-x*sin(x*pi)
CACFloat BackEaseIn(CACFloat p)
{
    return p * p * p - p * sin(p * M_PI);
}

// Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
CACFloat BackEaseOut(CACFloat p)
{
    CACFloat f = (1 - p);
    return 1 - (f * f * f - f * sin(f * M_PI));
}

// Modeled after the piecewise overshooting cubic function:
// y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))           ; [0, 0.5)
// y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1) ; [0.5, 1]
CACFloat BackEaseInOut(CACFloat p)
{
    if(p < 0.5)
    {
        CACFloat f = 2 * p;
        return 0.5 * (f * f * f - f * sin(f * M_PI));
    }
    else
    {
        CACFloat f = (1 - (2*p - 1));
        return 0.5 * (1 - (f * f * f - f * sin(f * M_PI))) + 0.5;
    }
}

CACFloat BounceEaseIn(CACFloat p)
{
    return 1 - BounceEaseOut(1 - p);
}

CACFloat BounceEaseOut(CACFloat p)
{
    if(p < 4/11.0)
    {
        return (121 * p * p)/16.0;
    }
    else if(p < 8/11.0)
    {
        return (363/40.0 * p * p) - (99/10.0 * p) + 17/5.0;
    }
    else if(p < 9/10.0)
    {
        return (4356/361.0 * p * p) - (35442/1805.0 * p) + 16061/1805.0;
    }
    else
    {
        return (54/5.0 * p * p) - (513/25.0 * p) + 268/25.0;
    }
}

CACFloat BounceEaseInOut(CACFloat p)
{
    if(p < 0.5)
    {
        return 0.5 * BounceEaseIn(p*2);
    }
    else
    {
        return 0.5 * BounceEaseOut(p * 2 - 1) + 0.5;
    }
}





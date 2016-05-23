//
//  UIButton+EventHandlerBlock.h
//  BNCExampleProj
//
//  Created by Heping on 5/12/16.
//  Copyright © 2016 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EventHandlerBlock) (void);

@interface UIControl (EventHandlerBlock)
-(void)setEventHandler:(EventHandlerBlock)block  withControlEvent:(UIControlEvents)event;
@end

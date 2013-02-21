//
//  TimerManager.h
//  Golf
//
//  Created by  lynn on 12/15/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerManager : NSObject

+(void)timer:(id)viewController timeInterval:(float)timeInterval timeSinceNow:(float)timeSinceNow selector:(SEL)selector;
+(void)timer:(id)viewController timeInterval:(float)timeInterval timeSinceNow:(float)timeSinceNow selector:(SEL)selector repeats:(BOOL)isRepeat;

@end

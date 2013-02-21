//
//  TimerManager.m
//  Golf
//
//  Created by  lynn on 12/15/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import "TimerManager.h"

@implementation TimerManager

+(void)timer:(id)viewController timeInterval:(float)timeInterval timeSinceNow:(float)timeSinceNow selector:(SEL)selector
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                      target:viewController
                                                    selector:selector
                                                    userInfo:nil
                                                     repeats:NO];
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:timeSinceNow];
    [timer setFireDate:fireDate];
}

+(void)timer:(id)viewController timeInterval:(float)timeInterval timeSinceNow:(float)timeSinceNow selector:(SEL)selector repeats:(BOOL)isRepeat
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                      target:viewController
                                                    selector:selector
                                                    userInfo:nil
                                                     repeats:isRepeat];
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:timeSinceNow];
    [timer setFireDate:fireDate];
}


@end

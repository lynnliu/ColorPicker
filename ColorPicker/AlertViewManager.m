//
//  AlertViewManager.m
//  Golf
//
//  Created by  lynn on 12/14/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import "AlertViewManager.h"
#import "TimerManager.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "WCAlertView.h"

@interface AlertViewManager ()
{
    UIView *alertBackView;
}

@end

@implementation AlertViewManager

+(void)alertViewShow:(id)viewController cancel:(NSString *)cancelTitle confirm:(NSString *)confirmTitle msg:(NSString *)msg
{
    [WCAlertView setDefaultStyle:WCAlertViewStyleWhite];
    if ([msg isKindOfClass:[NSNull class]]) msg = nil;
    
    WCAlertView *alert = [[WCAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:viewController
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:confirmTitle, nil];
    alert.style = WCAlertViewStyleWhiteHatched;
    [alert show];
}

-(void)alertNewView:(id)viewController msg:(NSString *)msg
{
    alertBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1000)];
    alertBackView.backgroundColor = [UIColor clearColor];

    UIImageView *backImage = [[UIImageView alloc] initWithFrame:alertBackView.frame];
    backImage.image = [UIImage imageNamed:@"Search_Background.png"];
    backImage.alpha = 0.3;
    [alertBackView addSubview:backImage];
    
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.backgroundColor = [UIColor lightGrayColor];
    msgLabel.layer.cornerRadius = 10;
    msgLabel.layer.shadowOffset = CGSizeMake(1, 1);
    msgLabel.layer.shadowRadius = 2;
    msgLabel.layer.shadowOpacity = 1;
    msgLabel.layer.shadowColor = [UIColor grayColor].CGColor;
    
    CGSize labelSize = [msg sizeWithFont:[UIFont boldSystemFontOfSize:17.0f]
                       constrainedToSize:CGSizeMake(220, 1000)
                           lineBreakMode:UILineBreakModeCharacterWrap];
    int height = 100;
    if (labelSize.height > height) height = labelSize.height;
    msgLabel.frame = CGRectMake(50, 160, 220, height);
    msgLabel.text = [NSString stringWithFormat:@"  %@",msg];
    msgLabel.font = [UIFont boldSystemFontOfSize:17];
    msgLabel.textColor = [UIColor blackColor];
    msgLabel.textAlignment = UITextAlignmentCenter;
    msgLabel.numberOfLines = 100;// 不可少Label属性之一
    msgLabel.lineBreakMode = UILineBreakModeCharacterWrap;// 不可少Label属性之二
    [alertBackView addSubview:msgLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(253, 147, 30, 30)];
    [button addTarget:self action:@selector(dismissNewView:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[self closeButtonImage] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    [alertBackView addSubview:button];
    
    [TimerManager timer:self timeInterval:0 timeSinceNow:3 selector:@selector(dismissNewView:)];
    
    if([(UIViewController *)viewController parentViewController])
        [[[[(UIViewController *)viewController parentViewController] view] superview] addSubview:alertBackView];
    else
        [[(UIViewController *)viewController view] addSubview:alertBackView];
}

- (UIImage *)closeButtonImage{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0);
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor *topGradient = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:0.9];
    UIColor *bottomGradient = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:0.9];
    
    //// Gradient Declarations
    NSArray *gradientColors = @[(id)topGradient.CGColor,
    (id)bottomGradient.CGColor];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = 3;
    CGColorRef shadow2 = [UIColor blackColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(0, 1);
    CGFloat shadow2BlurRadius = 0;
    
    
    //// Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 3, 24, 24)];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(16, 3), CGPointMake(16, 27), 0);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    [[UIColor whiteColor] setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    CGContextRestoreGState(context);
    
    //// Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(18.83, 15)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(16, 17.83)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(13.17, 15)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(16, 12.17)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)dismissNewView:(id)sender
{
    if([sender isKindOfClass:[UIButton class]]){
        [alertBackView removeFromSuperview];
    }else{
        UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
        [UIView animateWithDuration:0.6 delay:0 options:options animations:^{
            alertBackView.alpha = 0;
        } completion:^(BOOL finished){
            [alertBackView removeFromSuperview];
        }];
    }
}

@end

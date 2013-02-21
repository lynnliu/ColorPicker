//
//  PickedImageVIew.m
//  ColorPicker
//
//  Created by  lynn on 2/19/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "PickedImageVIew.h"
#import <QuartzCore/QuartzCore.h>

@implementation PickedImageVIew

-(void)setSendImage:(UIImage *)sendImage
{
    if (_sendImage != sendImage){
        self.image = sendImage;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self setUserInteractionEnabled:YES];
    
    return self;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    UIColor *color = [self fetchColor:point.x and:point.y];
    NSLog(@"%@",color);
    [self.delegate getColor:color];
}

- (UIColor *)fetchColor:(int)x and:(int)y {
    NSLog(@"x=%d",x);
    NSLog(@"y=%d",y);
    
    CGImageRef imageRef = [self.image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    double r = rawData[byteIndex];
    double g = rawData[byteIndex + 1];
    double b = rawData[byteIndex + 2];
    double a = rawData[byteIndex + 3];
    NSLog(@"r=%f",r);
    NSLog(@"g=%f",g);
    NSLog(@"b=%f",b);
    NSLog(@"a=%f",a);
    UIColor *color = [[UIColor alloc] initWithRed:r/255 green:g/255 blue:b/255 alpha:a/255];
    
    free(rawData);
    return color;
}

@end

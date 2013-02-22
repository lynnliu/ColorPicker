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

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.delegate getColor:[self fetchColor:point.x and:point.y]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    [self.delegate getColor:[self fetchColor:point.x and:point.y]];
}

- (NSArray *)fetchColor:(int)x and:(int)y {
    
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
    
    // Now your rawData contains the image data in the RGBA pixel format.
    int byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    float r = rawData[byteIndex];
    float g = rawData[byteIndex + 1];
    float b = rawData[byteIndex + 2];
    float a = rawData[byteIndex + 3];
    free(rawData);
    
    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:r],[NSNumber numberWithFloat:g],[NSNumber numberWithFloat:b],[NSNumber numberWithFloat:a], nil];
    return array;
}

@end

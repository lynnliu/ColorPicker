//
//  PickedImageVIew.m
//  ColorPicker
//
//  Created by  lynn on 2/19/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "PickedImageVIew.h"
#import <QuartzCore/QuartzCore.h>

@interface PickedImageVIew ()
{
    UIImageView *magnifier;
    UIImageView *magnifierImage;
    NSData *imageData;
    CGPoint point;
    NSUInteger width;
    NSUInteger height;
}

@end

@implementation PickedImageVIew

-(void)setSendImage:(UIImage *)sendImage
{
    if (_sendImage != sendImage){
        self.image = sendImage;
        width = CGImageGetWidth([self.image CGImage]);
        height = CGImageGetHeight([self.image CGImage]);
        imageData = [NSData dataWithData:[self getImageData:sendImage]];
    }
}

-(NSData *)getImageData:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    
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
    
    NSData *imageNSData = [NSData dataWithBytes:rawData length:height * width * 4];
    free(rawData);
    
    return imageNSData;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //开启图片放大镜
    point = [[touches anyObject] locationInView:self];

    if (point.y < self.frame.size.height && point.x < 320){
        [self addMagnifier:point.x and:point.y];
        [self.delegate getColor:[self fetchColor:point.x and:point.y]];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    point = [[touches anyObject] locationInView:self];
    
    if (point.y < self.frame.size.height && point.x < 320){
        [self moveMagnifier:point.x and:point.y];
        [self.delegate getColor:[self fetchColor:point.x and:point.y]];
        [self magnifierImageView:point.x and:point.y];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //关闭图片放大镜
    [self removeMagnifier];
}

- (NSArray *)fetchColor:(int)x and:(int)y{
    Byte *bytes = (Byte *)[imageData bytes];
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    
    //一定要进行像素比点的比例，图像是压缩在固定尺寸的点上的，点的坐标要转换成像素才能取得准确的数据。
    float pixelToPoint = width / 320;
    int byteIndex = (bytesPerRow * y * pixelToPoint) + x * pixelToPoint * bytesPerPixel;
    float r = 0;
    float g = 0;
    float b = 0;
    float a = 0;
    // Now your bytes contains the image data in the RGBA pixel format.
    if (byteIndex < [imageData length]){
        r = bytes[byteIndex];
        g = bytes[byteIndex + 1];
        b = bytes[byteIndex + 2];
        a = bytes[byteIndex + 3];   
    }
    
    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:r],[NSNumber numberWithFloat:g],[NSNumber numberWithFloat:b],[NSNumber numberWithFloat:a], nil];
    return array;
}

-(void)addMagnifier:(int)x and:(int)y
{
    magnifier = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magnifier.png"]];
    magnifier.frame =  CGRectMake(x - 38, y - 65, 60, 70);
    
    magnifierImage = [[UIImageView alloc] initWithImage:[self magnifierImageView:x and:y]];
    magnifierImage.frame = CGRectMake(5, 5, 50, 50);
    [[magnifierImage layer] setCornerRadius:20];
    [[magnifierImage layer] setShadowOffset:CGSizeMake(1, 1)];
    [[magnifierImage layer] setShadowRadius:6];
    [[magnifierImage layer] setShadowOpacity:1];
    [[magnifierImage layer] setShadowColor:[UIColor grayColor].CGColor];
    [magnifier addSubview:magnifierImage];

    [[self superview] addSubview:magnifier];
}

-(void)moveMagnifier:(int)x and:(int)y
{
    magnifier.frame = CGRectMake(x - 38, y - 65, 60, 70);
    magnifierImage.image = [self magnifierImageView:x and:y];
}

-(void)removeMagnifier
{
    [magnifier removeFromSuperview];
}

-(UIImage *)magnifierImageView:(int)x and:(int)y
{
    CGImageRef img = CGImageCreateWithImageInRect(self.image.CGImage, CGRectMake(x, y, 5, 5));
    UIImage *newimage = [UIImage imageWithCGImage:img];
    return newimage;
}

@end

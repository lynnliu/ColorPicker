//
//  ImageOperate.m
//  ColorPicker
//
//  Created by  lynn on 2/23/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ImageOperate.h"

@implementation ImageOperate

+(NSData *)getImageData:(UIImage *)image height:(NSUInteger)height width:(NSUInteger)width
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

+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    //此处首先指定了图片存取路径（默认写到应用程序沙盒 中）
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //并给文件起个文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:aPath];
    
    //此处的方法是将图片写到Documents文件中 如果写入成功会弹出一个警告框,提示图片保存成功
    BOOL result = [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically:YES];
    
    return result;
}

//从本地获取图片
+ (UIImage*)GetImageFromLocal:(NSString*)imgPath {
    //拿到应用程序沙盒里面的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //读取存在沙盒里面的文件图片
    NSString *imageFullPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imgPath];
    //因为拿到的是个路径 把它加载成一个data对象
    NSData *data=[NSData dataWithContentsOfFile:imageFullPath];
    //直接把该 图片读出来
    UIImage *img=[UIImage imageWithData:data];
    return img;
}
@end

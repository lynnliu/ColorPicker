//
//  ImageOperate.h
//  ColorPicker
//
//  Created by  lynn on 2/23/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageOperate : NSObject

+(NSData *)getImageData:(UIImage *)image height:(NSUInteger)height width:(NSUInteger)width;

+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;
+ (UIImage*)GetImageFromLocal:(NSString*)imgPath ;
@end

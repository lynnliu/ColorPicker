//
//  PickedImageVIew.h
//  ColorPicker
//
//  Created by  lynn on 2/19/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickedImageVIew;

@protocol PickedImageVIewDelegate;

@interface PickedImageVIew : UIImageView

@property (nonatomic,strong) UIImage *sendImage;
@property (nonatomic,strong) id <PickedImageVIewDelegate> delegate;

@end

@protocol PickedImageVIewDelegate <NSObject>

-(void)getColor:(UIColor *)color;

@end
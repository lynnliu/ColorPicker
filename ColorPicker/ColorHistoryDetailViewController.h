//
//  ColorHistoryDetailViewController.h
//  ColorPicker
//
//  Created by  lynn on 3/6/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerBaseViewController.h"

@interface ColorHistoryDetailViewController : ColorPickerBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *colorDetail;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *colorName;
@property (nonatomic,strong) UIColor *textColor;

@end

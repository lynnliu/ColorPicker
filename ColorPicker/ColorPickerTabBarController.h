//
//  ColorPickerTabBarController.h
//  ColorPicker
//
//  Created by  lynn on 2/26/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLComposeViewController;

@interface ColorPickerTabBarController : UITabBarController
{
    SLComposeViewController *slComposerSheet;
}
@property (nonatomic) NSString *sharingText;
@property (nonatomic) UIImage *sharingImage;
@end

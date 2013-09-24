//
//  ColorPickerAppDelegate.h
//  ColorPicker
//
//  Created by  lynn on 2/18/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "ColorPickerTabBarController.h"
#import "DMSplashAdController.h"

@interface ColorPickerAppDelegate : UIResponder <UIApplicationDelegate,DMSplashAdControllerDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

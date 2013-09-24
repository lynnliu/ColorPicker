//
//  ColorPickerBaseViewController.h
//  ColorPicker
//
//  Created by  lynn on 2/18/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#define AdKey @"56OJzXIIuNaulQzdc5"
#define ITUNESURL @"https://itunes.apple.com/us/app/color-picker-for-developer/id608956277?ls=1&mt=8"

#define WXAppID @"wx2a062d4628d88879"
#define WXAppKey @"8ce6b0aeff1396c98028e8d59a95ae12"

#import <UIKit/UIKit.h>

@class SLComposeViewController;

@interface ColorPickerBaseViewController : UIViewController
{
    SLComposeViewController *slComposerSheet;
}
@end

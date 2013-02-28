//
//  ColorPickerRootViewController.h
//  ColorPicker
//
//  Created by  lynn on 2/28/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerRootViewControllerDelegate <NSObject>
-(void)sendReqWebChat:(BOOL)reqType txt:(NSString *)msg;
@end

@interface ColorPickerRootViewController : UINavigationController

@property (nonatomic,strong) id <ColorPickerRootViewControllerDelegate> rootViewDelegate;

@end

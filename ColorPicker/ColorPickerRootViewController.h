//
//  ColorPickerRootViewController.h
//  ColorPicker
//
//  Created by  lynn on 2/28/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerRootViewControllerDelegate <NSObject>
@optional
- (void) sendAppContent:(BOOL)reqType;
- (void) sendNewsContent:(BOOL)reqType image:(UIImage *)image descript:(NSString *)descript;
@end

@interface ColorPickerRootViewController : UINavigationController

@property (nonatomic,strong) id <ColorPickerRootViewControllerDelegate> rootViewDelegate;

@end

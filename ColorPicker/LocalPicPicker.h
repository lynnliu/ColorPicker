//
//  LocalPicPicker.h
//  ColorPicker
//
//  Created by  lynn on 2/18/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalPicPicker : NSObject

+(void)localPicPicker:(id)viewController pickerSource:(UIImagePickerControllerSourceType)pickerSource;

+(void)picProcesser:(UIImagePickerController *)picker viewController:(id)viewController mediaInfo:(NSDictionary *)info;

@end

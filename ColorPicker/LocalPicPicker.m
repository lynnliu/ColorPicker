//
//  LocalPicPicker.m
//  ColorPicker
//
//  Created by  lynn on 2/18/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "LocalPicPicker.h"
#import "AlertViewManager.h"
#import "ImageChopperViewController.h"

@interface LocalPicPicker ()

@end

@implementation LocalPicPicker

+(void)localPicPicker:(id)viewController pickerSource:(UIImagePickerControllerSourceType)pickerSource imageButton:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = viewController;
    picker.sourceType = pickerSource;
    picker.allowsEditing = YES;
    [viewController presentModalViewController:picker animated:YES];
}

+(void)picProcesser:(UIImagePickerController *)picker viewController:(id)viewController mediaInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    ImageChopperViewController *imageChopper = [[ImageChopperViewController alloc] init];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ImageChopper" bundle:nil];
    imageChopper = story.instantiateInitialViewController;
    imageChopper.choosedImageInfo = info;
    [[(UIViewController *)viewController navigationController] pushViewController:imageChopper animated:YES];
}

@end

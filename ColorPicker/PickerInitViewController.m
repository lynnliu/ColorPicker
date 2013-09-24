//
//  PickerInitViewController.m
//  ColorPicker
//
//  Created by  lynn on 2/18/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "PickerInitViewController.h"
#import "LocalPicPicker.h"
#import "ImageChopperViewController.h"
#import "InfColorPickerController.h"

@interface PickerInitViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,InfColorPickerControllerDelegate>
{
    UIPopoverController *popoverController;
}
@end

@implementation PickerInitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseLocalPic:(UIButton *)sender
{
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)  [LocalPicPicker localPicPicker:self pickerSource:UIImagePickerControllerSourceTypePhotoLibrary imageButton:sender];
    else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;

        popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
        [popoverController setPopoverContentSize:CGSizeMake(480,320) animated:YES];//大小
        [popoverController presentPopoverFromRect:CGRectMake(sender.center.x,sender.center.y,10,10)//弹出位置
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionDown//弹出方向
                                         animated:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [popoverController dismissPopoverAnimated:YES];
	
    [LocalPicPicker picProcesser:picker viewController:self mediaInfo:info];
}

- (IBAction)cameraPhoto:(UIButton *)sender
{
    [LocalPicPicker localPicPicker:self pickerSource:UIImagePickerControllerSourceTypeCamera imageButton:sender];
}

- (IBAction)showColors:(id)sender
{
    InfColorPickerController* picker = [ InfColorPickerController colorPickerViewController ];
    picker.delegate = self;
    picker.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:picker animated:YES];
}
@end

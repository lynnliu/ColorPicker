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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseLocalPic:(UIButton *)sender
{
    [LocalPicPicker localPicPicker:self pickerSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [LocalPicPicker picProcesser:picker viewController:self mediaInfo:info];
}

- (IBAction)cameraPhoto:(UIButton *)sender
{
    [LocalPicPicker localPicPicker:self pickerSource:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)showColors:(id)sender
{
    InfColorPickerController* picker = [ InfColorPickerController colorPickerViewController ];
    
//    picker.sourceColor = self.color;
    picker.delegate = self;
    [self.navigationController pushViewController:picker animated:YES];
//    [ picker presentModallyOverViewController: self ];
//
//    AllColorsViewController *chtvc = [[AllColorsViewController alloc] init];
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"AllColorsViewController" bundle:nil];
//    chtvc = story.instantiateInitialViewController;
//    [self.navigationController pushViewController:chtvc animated:YES];
}
@end

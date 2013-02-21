//
//  ImageChopperViewController.m
//  ColorPicker
//
//  Created by  lynn on 2/18/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ImageChopperViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PickedImageVIew.h"

@interface ImageChopperViewController ()<UIGestureRecognizerDelegate,PickedImageVIewDelegate>
{
    UIView *colorPatone;
}
@property (strong, nonatomic) UIImageView *choosedImageView;
@end

@implementation ImageChopperViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    for (id gesture in  [self.view gestureRecognizers])
        [self.view removeGestureRecognizer:gesture];
    
    UIImage *image = [self.choosedImageInfo objectForKey:@"UIImagePickerControllerEditedImage"];
    PickedImageVIew *pickedImageView = [[PickedImageVIew alloc] initWithFrame:CGRectMake(0, 0, 320, 320 * image.size.height / image.size.width)];
    pickedImageView.sendImage = image;
    pickedImageView.delegate = self;
    [self.view addSubview:pickedImageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(220, 320, 100, self.view.frame.size.height - 320)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveTheColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    colorPatone = [[UIView alloc] initWithFrame:CGRectMake(0, 320, 220, self.view.frame.size.height - 320)];
    colorPatone.backgroundColor = [UIColor blackColor];
    [self.view addSubview:colorPatone];
}

-(void)getColor:(UIColor *)color
{
    colorPatone.backgroundColor = color;
}

-(void)saveTheColor:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    self.choosedImageView = nil;
    [super viewDidUnload];
}
@end

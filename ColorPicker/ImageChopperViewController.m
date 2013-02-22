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
    UILabel *red;
    UILabel *green;
    UILabel *blue;
    UILabel *alpha;
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
    
    [self patoneCanvas];
    [self saveButton];
}

-(void)patoneCanvas
{
    colorPatone = [[UIView alloc] initWithFrame:CGRectMake(0, 320, 320, self.view.frame.size.height - 320)];
    colorPatone.backgroundColor = [UIColor whiteColor];
    
    red = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    red.textColor = [UIColor lightGrayColor];
    red.backgroundColor = [UIColor clearColor];
    red.font = [UIFont systemFontOfSize:14];
    red.shadowColor = [UIColor darkTextColor];
    [red setShadowOffset:CGSizeMake(0, .3)];
    [colorPatone addSubview:red];
    
    green = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 80, 20)];
    green.textColor = [UIColor lightGrayColor];
    green.backgroundColor = [UIColor clearColor];
    green.font = [UIFont systemFontOfSize:14];
    green.shadowColor = [UIColor darkTextColor];
    [green setShadowOffset:CGSizeMake(0, .3)];
    [colorPatone addSubview:green];
    
    blue = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 80, 20)];
    blue.textColor = [UIColor lightGrayColor];
    blue.backgroundColor = [UIColor clearColor];
    blue.font = [UIFont systemFontOfSize:14];
    blue.shadowColor = [UIColor darkTextColor];
    [blue setShadowOffset:CGSizeMake(0, .3)];
    [colorPatone addSubview:blue];
    
    alpha = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 80, 20)];
    alpha.textColor = [UIColor lightGrayColor];
    alpha.backgroundColor = [UIColor clearColor];
    alpha.font = [UIFont systemFontOfSize:14];
    alpha.shadowColor = [UIColor darkTextColor];
    [alpha setShadowOffset:CGSizeMake(0, .3)];
    [colorPatone addSubview:alpha];
    
    [self.view addSubview:colorPatone];
}

-(void)saveButton
{
    UIView *button = [[UIView alloc] initWithFrame:CGRectMake(220, 320, 100, self.view.frame.size.height - 320)];
    button.backgroundColor = [UIColor blackColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(13, 30, 80, 35)];
    title.text = @"保  存";
    title.textAlignment = UITextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [UIColor lightGrayColor];
    [button addSubview:title];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveTheColor:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [button addGestureRecognizer:tap];
    
    [self.view addSubview:button];
}

-(void)getColor:(NSArray *)colorArray
{
    UIColor *color = [[UIColor alloc] initWithRed:[[colorArray objectAtIndex:0] floatValue] / 255.0f
                                            green:[[colorArray objectAtIndex:1] floatValue] / 255.0f
                                             blue:[[colorArray objectAtIndex:2] floatValue] /255.0f
                                            alpha:[[colorArray objectAtIndex:3] floatValue] /255.0f];
    
    colorPatone.backgroundColor = color;
    red.text = [NSString stringWithFormat:@"red     : %.0f",[[colorArray objectAtIndex:0] floatValue]];
    green.text = [NSString stringWithFormat:@"green : %.0f",[[colorArray objectAtIndex:1] floatValue]];
    blue.text = [NSString stringWithFormat:@"blue   : %.0f",[[colorArray objectAtIndex:2] floatValue]];
    alpha.text = [NSString stringWithFormat:@"alpha : %.0f",[[colorArray objectAtIndex:3] floatValue]];
}

-(void)saveTheColor:(id)sender
{
    NSLog(@"save");
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

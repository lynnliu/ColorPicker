//
//  ColorPickerBaseViewController.m
//  ColorPicker
//
//  Created by  lynn on 2/18/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ColorPickerBaseViewController.h"
#import "ShareSendViewController.h"
#import "LINEActivity.h"
#import "DMActivityInstagram.h"
#import <Social/Social.h>

@interface ColorPickerBaseViewController () <UIGestureRecognizerDelegate>
{
    UIPopoverController *popoverController;
}
@property (nonatomic) NSString *sharingText;
@property (nonatomic) UIImage *sharingImage;
@end

@implementation ColorPickerBaseViewController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightConfirm:)];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBackward:)];
    swipe.delegate = self;
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipe];
    self.sharingText = @"推荐一个应用：屏幕取色，可以轻松取得看到图片上的颜色，挺有趣的! https://itunes.apple.com/us/app/color-picker-for-developer/id608956277?ls=1&mt=8";
    self.sharingImage = [UIImage imageNamed:@"Icon@2x.png"];
}

-(void)goBackward:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightConfirm:(id)sender
{
    if([SLComposeViewController class] != nil){
        
        NSURL *shareURL = [NSURL URLWithString:@"http://weibo.com/u/2048718212?wvr=5&"];
        NSArray *activityItems = @[self.sharingImage,self.sharingText, shareURL];
        
        DMActivityInstagram *instagramActivity = [[DMActivityInstagram alloc] init];
        instagramActivity.presentFromButton = (UIBarButtonItem *)sender;
        
        NSArray *applicationActivities = @[[[LINEActivity alloc] init],instagramActivity];
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                          applicationActivities:applicationActivities];
        
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
            [self presentViewController:activityController animated:YES completion:nil];
        else{
            popoverController = [[UIPopoverController alloc] initWithContentViewController:activityController];
            [popoverController setPopoverContentSize:CGSizeMake(400,460) animated:YES];//大小
            [popoverController presentPopoverFromRect:CGRectMake(1000,0,10,10)//弹出位置
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionUp//弹出方向
                                             animated:YES];
        }
        
    }
    else{
        [self shareToTencent];
    }
}

-(void)shareToTencent
{
    ShareSendViewController *ssvc = [[ShareSendViewController alloc] init];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ShareSend" bundle:nil];
    ssvc = story.instantiateInitialViewController;
    ssvc.txt = self.sharingText;
    [self presentModalViewController:ssvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

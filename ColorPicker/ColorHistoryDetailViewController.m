//
//  ColorHistoryDetailViewController.m
//  ColorPicker
//
//  Created by  lynn on 3/6/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ColorHistoryDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ShareSendViewController.h"
#import <Social/Social.h>
#import <ACCOUNTS/ACAccount.h>
#import "LINEActivity.h"
#import "DMActivityInstagram.h"
#import "WeiXinActivity.h"

@interface ColorHistoryDetailViewController ()
{
    UIPopoverController *popoverController;
}

@property (nonatomic,strong) NSString *shareText;
@end

@implementation ColorHistoryDetailViewController

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
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"])
        self.title = @"细节";
    else
        self.title = @"Detail";

    self.view.backgroundColor = self.color;
    self.colorDetail.text = self.colorName;
    self.colorDetail.textColor = self.textColor;
    self.imageView.image = self.image;
    [[self.imageView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[self.imageView layer] setShadowRadius:2];
    [[self.imageView layer] setShadowOpacity:1];
    [[self.imageView layer] setShadowColor:[UIColor grayColor].CGColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
}

-(void)share:(id)sender
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]){
        self.shareText = [NSString stringWithFormat:@"推荐一个应用：屏幕取色，可以轻松取得看到图片上的颜色，挺有趣的! %@",ITUNESURL];
    }else if ([currentLanguage isEqualToString:@"ja"]){
        self.shareText = [NSString stringWithFormat:@"推奨する:%@",ITUNESURL];
    }else{
        self.shareText = [NSString stringWithFormat:@"I found this app is fun:%@",ITUNESURL];
    }
    
    if([SLComposeViewController class] != nil){
        
        NSArray *activityItems = @[self.image,self.shareText];
        DMActivityInstagram *instagramActivity = [[DMActivityInstagram alloc] init];
        instagramActivity.presentFromButton = (UIBarButtonItem *)sender;
        
        NSArray *applicationActivities = @[[[LINEActivity alloc] init],instagramActivity,[[WeiXinActivity alloc] init]];
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
        
    }else
        [self shareToTencent];

}

-(void)shareToTencent
{
    ShareSendViewController *ssvc = [[ShareSendViewController alloc] init];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ShareSend" bundle:nil];
    ssvc = story.instantiateInitialViewController;
    ssvc.txt = self.shareText;
    [self presentModalViewController:ssvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setColorDetail:nil];
    [super viewDidUnload];
}
@end

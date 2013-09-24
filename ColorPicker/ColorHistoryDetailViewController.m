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
#import "ColorPickerTabBarController.h"

@interface ColorHistoryDetailViewController () <UIActionSheetDelegate>
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkWechatShare:) name:@"wechat share" object:nil];
}

-(void)checkWechatShare:(NSNotification *)notification
{
    if ([[notification.userInfo valueForKey:@"Wechat"] isEqualToString:@"OK"]){
        NSString *title = @"";
        NSString *cancel = @"";
        NSString *button1 = @"";
        NSString *button2 = @"";
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]){
            title = @"微信分享";
            cancel = @"取消";
            button1 = @"分享到朋友圈";
            button2 =@"分享到会话";
        }else if ([currentLanguage isEqualToString:@"ja"]){
            title = @"WeChat 分かち合う";
            cancel = @"キャンセル";
            button1 = @"友達の輪";
            button2 =@"会話";
        }else{
            title = @"WeChat Share";
            cancel = @"Cancel";
            button1 = @"To Circle";
            button2 =@"To Conversation";
        }
        
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:title
                                                            delegate:self
                                                   cancelButtonTitle:cancel
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:button1,button2, nil];
        [action showInView:self.view];

    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self sendReqWebChat:1];
            break;
        case 1:
            [self sendReqWebChat:0];
            break;
        default:
            break;
    }
}

-(void)sendReqWebChat:(BOOL)reqType
{
    NSString *descript = @"";
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"])
        descript = @"这张图片怎么样？知道它的颜色构成吗？用这个软件试试吧!";
    else
        descript = @"Do you like this picture？User this app to try！";

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

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setColorDetail:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechat share" object:nil];
}
@end

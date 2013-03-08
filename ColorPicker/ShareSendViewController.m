//
//  ShareSendViewController.m
//  Golf
//
//  Created by Lynn Liu on 6/27/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import "ShareSendViewController.h"
#import "UserTokenFileOperate.h"
#import "OauthViewController.h"
#import "AlertViewManager.h"
#import <QuartzCore/QuartzCore.h>
#import "TimerManager.h"
#import "WXApi.h"
#import "ColorPickerRootViewController.h"

@interface ShareSendViewController () <UIActionSheetDelegate,WXApiDelegate,UIAlertViewDelegate>
{
    UserOauthData *oauth;
    BOOL isBond_TC;
}
@property (weak, nonatomic) IBOutlet UIButton *tc;
@property (weak, nonatomic) IBOutlet UIButton *wechat;
@property (nonatomic) BOOL tcStatus;

@property (weak, nonatomic) IBOutlet UITextView *sendTextView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigation;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

@end

@implementation ShareSendViewController
@synthesize sendTextView = _sendTextView;
@synthesize navigation = _navigation;
@synthesize tc = _tc;

-(void)setTcStatus:(BOOL)tcStatus{
    _tcStatus = tcStatus;
    if (tcStatus) [self.tc setImage:[UIImage imageNamed:@"TCweiboicon32.png"] forState:UIControlStateNormal];
    else [self.tc setImage:[UIImage imageNamed:@"Tc32_Black.png"] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    oauth = [[UserOauthData alloc] init];
    oauth = [UserTokenFileOperate read];
    
    if (oauth.userBond_TC.length != 0)isBond_TC = (BOOL)oauth.userBond_TC;
    else isBond_TC = NO;
    
    if (isBond_TC && self.tcStatus) [self.tc setImage:[UIImage imageNamed:@"TCweiboicon32.png"] forState:UIControlStateNormal];
    else [self.tc setImage:[UIImage imageNamed:@"Tc32_Black.png"] forState:UIControlStateNormal];
    
    self.sendTextView.layer.cornerRadius = 6;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.sendTextView.frame = CGRectMake(50, 100, 920, 250);
        self.sendTextView.font = [UIFont systemFontOfSize:25.];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]){
        self.sendTextView.text = self.txt;
        self.navigationTitle.title = @"分享";
    }else if ([currentLanguage isEqualToString:@"ja"]){
        self.sendTextView.text = [NSString stringWithFormat:@"推奨する:%@",ITUNESURL];
        self.navigationTitle.title = @"分かち合う";
    }else{
        self.sendTextView.text = [NSString stringWithFormat:@"I found this app is fun:%@",ITUNESURL];
        self.navigationTitle.title = @"Share";
    }
    
    self.tcStatus = YES;
}

//微博认证
- (IBAction)tcAuth:(UIButton *)sender
{
    if (self.tcStatus && isBond_TC) self.tcStatus = NO;
    else{
        self.tcStatus = YES;
        if (!isBond_TC) [self sendOauthTC];
    }
}

- (IBAction)leftConfirm:(UIBarButtonItem *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

//微博分享
- (IBAction)rightConfirm:(UIBarButtonItem *)sender {
    [self.sendTextView resignFirstResponder];
    
    NSString *feedback = [NSString string];
    if (isBond_TC && self.tcStatus) feedback = [self sendRequestTC];
    
    if(!(isBond_TC && self.tcStatus)){
        AlertViewManager *alert = [[AlertViewManager alloc] init];
        [alert alertNewView:self msg:@"请先点击微博认证"];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSArray *)sender
{
    if ([segue.identifier isEqualToString:@"oauth 2.0"]){
        [segue.destinationViewController setUrl:[sender objectAtIndex:0]];
        [segue.destinationViewController setSegueString:[sender objectAtIndex:1]];
    }
}

-(void)sendOauthTC
{
    NSString *url = OAUTH_URL_TC;
    url = [url stringByAppendingFormat:@"?client_id=%@",APP_KEY_TC];
    url = [url stringByAppendingString:@"&response_type=token"];
    url = [url stringByAppendingFormat:@"&redirect_uri=%@",TC_Redirect_URL];
    NSArray *senderObj = [NSArray arrayWithObjects:url,@"TC", nil];
    [self performSegueWithIdentifier:@"oauth 2.0" sender:senderObj];
}

-(NSString *)sendRequestTC
{
    float sum = 0.0;  
    for(int i=0;i<[self.sendTextView.text length];i++) {  
        NSString *character = [self.sendTextView.text substringWithRange:NSMakeRange(i, 1)];  
        if([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)  
            sum++;
        else sum += 0.5;  
    }  
    
    if (sum <= 140 && sum > 0){
        NSString *msg = self.sendTextView.text;
        NSString *token = oauth.userToken_TC;
        NSString *openID = oauth.UID_TC;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.frame = CGRectMake(160, 160, indicator.frame.size.width, indicator.frame.size.height);
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [indicator startAnimating];
        [self.view addSubview:indicator];

        dispatch_queue_t tcShare = dispatch_queue_create("share tc weibo", NULL);
        dispatch_async(tcShare, ^{
            NSDictionary *error = [UserTokenFileOperate sendTextInfo_TC:msg token:token openid:openID];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *result = [UserTokenFileOperate errorParse_TC:error];
                AlertViewManager *alert = [[AlertViewManager alloc] init];
                [alert alertNewView:self msg:result];
                if ([result isEqualToString:FEEDBACK_SUCCESS])
                    [TimerManager timer:self timeInterval:0 timeSinceNow:2 selector:@selector(dismissSelf)];
                
                [indicator stopAnimating];
            });
        });
    }else if(sum >140)
        [AlertViewManager alertViewShow:nil cancel:@"OK" confirm:nil msg:@"对不起, 字数大于140, 超过了微博的限制"];
    else
        [AlertViewManager alertViewShow:nil cancel:@"OK" confirm:nil msg:@"对不起, 请不要发送空内容"];

    return nil;
}

-(void)dismissSelf
{
    [self dismissModalViewControllerAnimated:YES];
}


//微信分享
- (IBAction)weiXinShare:(UIButton *)sender
{
    if (![WXApi isWXAppInstalled]){
        NSString *title = @"";
        NSString *cancel = @"";
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]){
            title = @"没有安装微信，要去下载吗？";
            cancel = @"取消";
        }else if ([currentLanguage isEqualToString:@"ja"]){
            title = @"WeChat インストールされていません, これをダウンロードしよう";
            cancel = @"キャンセル";
        }else{
            title = @"WeChat is not installed, would you like to download?";
            cancel = @"Cancel";
        }
        [AlertViewManager alertViewShow:self cancel:cancel confirm:@"OK" msg:title];
    }
    else{
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://itunes.apple.com/us/app/wechat/id414478124?mt=8"]];
            break;
            
        default:
            break;
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
    [[(ColorPickerRootViewController *)self.presentingViewController rootViewDelegate] sendAppContent:reqType];
}

- (void)viewDidUnload {
    [self setTc:nil];
    [self setNavigationTitle:nil];
    [self setWechat:nil];
    [super viewDidUnload];
}
@end

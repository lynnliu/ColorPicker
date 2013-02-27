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

@interface ShareSendViewController ()
{
    UserOauthData *oauth;
    BOOL isBond_Sina;
    BOOL isBond_TC;
}
@property (weak, nonatomic) IBOutlet UIButton *sina;
@property (weak, nonatomic) IBOutlet UIButton *tc;
@property (nonatomic) BOOL sinaStatus;
@property (nonatomic) BOOL tcStatus;

@property (weak, nonatomic) IBOutlet UITextView *sendTextView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

@end

@implementation ShareSendViewController
@synthesize sendTextView = _sendTextView;
@synthesize navigation = _navigation;
@synthesize sina = _sina;
@synthesize tc = _tc;

-(void)setSinaStatus:(BOOL)sinaStatus{
    _sinaStatus = sinaStatus;
    if (sinaStatus) [self.sina setImage:[UIImage imageNamed:@"weibo64.png"] forState:UIControlStateNormal];
    else [self.sina setImage:[UIImage imageNamed:@"weibo64_Black.png"] forState:UIControlStateNormal];
}

-(void)setTcStatus:(BOOL)tcStatus{
    _tcStatus = tcStatus;
    if (tcStatus) [self.tc setImage:[UIImage imageNamed:@"TCweiboicon32.png"] forState:UIControlStateNormal];
    else [self.tc setImage:[UIImage imageNamed:@"Tc32_Black.png"] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    oauth = [[UserOauthData alloc] init];
    oauth = [UserTokenFileOperate read];
    
    if (oauth.userBond_Sina.length != 0) isBond_Sina = (BOOL)oauth.userBond_Sina;
    else isBond_Sina = NO;
    
    if (oauth.userBond_TC.length != 0)isBond_TC = (BOOL)oauth.userBond_TC;
    else isBond_TC = NO;
    
    if (isBond_Sina && self.sinaStatus) [self.sina setImage:[UIImage imageNamed:@"weibo64.png"] forState:UIControlStateNormal];
    else [self.sina setImage:[UIImage imageNamed:@"weibo64_Black.png"] forState:UIControlStateNormal];

    if (isBond_TC && self.tcStatus) [self.tc setImage:[UIImage imageNamed:@"TCweiboicon32.png"] forState:UIControlStateNormal];
    else [self.tc setImage:[UIImage imageNamed:@"Tc32_Black.png"] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sendTextView.layer.cornerRadius = 6;
    
    self.sendTextView.text = self.txt;
    self.sinaStatus = YES;
    self.tcStatus = YES;
}

- (IBAction)sinaAuth:(UIButton *)sender
{
    if (self.sinaStatus && isBond_Sina) self.sinaStatus = NO;
    else{
        self.sinaStatus = YES;
        if (!isBond_Sina)
            [self sendOauthSina];
    }
}

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

- (IBAction)rightConfirm:(UIBarButtonItem *)sender {
    [self.sendTextView resignFirstResponder];
    
    NSString *feedback = [NSString string];
    if (isBond_Sina && self.sinaStatus) feedback = [self sendRequestSina];
    if (isBond_TC && self.tcStatus) feedback = [self sendRequestTC];
    
    if(!(isBond_Sina && self.sinaStatus) && !(isBond_TC && self.tcStatus)){
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

-(void)sendOauthSina
{
    NSString *url = OAUTH_URL_SINA;
    url = [url stringByAppendingFormat:@"?client_id=%@",YOUR_CLIENT_ID];
    url = [url stringByAppendingString:@"&response_type=token"];
    url = [url stringByAppendingString:@"&display=mobile"];
    url = [url stringByAppendingString:@"&forcelogin=true"];        
    url = [url stringByAppendingFormat:@"&redirect_uri=%@",YOUR_REGISTERED_REDIRECT_URI];
    NSArray *senderObj = [NSArray arrayWithObjects:url,@"Sina", nil];
    [self performSegueWithIdentifier:@"oauth 2.0" sender:senderObj];
}

-(NSString *)sendRequestSina{
    float sum = 0.0;  
    for(int i=0;i<[self.sendTextView.text length];i++) {  
        NSString *character = [self.sendTextView.text substringWithRange:NSMakeRange(i, 1)];  
        if([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)  
            sum++;
        else sum += 0.5;  
    }  
    
    if (sum <= 140 && sum > 0){
        NSString *msg = self.sendTextView.text;
        NSString *token = oauth.userToken_Sina;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.frame = CGRectMake(160, 160, indicator.frame.size.width, indicator.frame.size.height);
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [indicator startAnimating];
        [self.view addSubview:indicator];
        
        dispatch_queue_t sinaShare = dispatch_queue_create("share sina weibo", NULL);
        dispatch_async(sinaShare, ^{
            NSDictionary *error = [UserTokenFileOperate sendTextInfo_Sina:msg token:token];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *result = [UserTokenFileOperate errorParse_Sina:error];
                
                AlertViewManager *alert = [[AlertViewManager alloc] init];
                [alert alertNewView:self msg:result];
                if ([result isEqualToString:FEEDBACK_SUCCESS])
                    [TimerManager timer:self timeInterval:0 timeSinceNow:2 selector:@selector(dismissSelf)];
                [indicator stopAnimating];
            });
        });
    }else if(sum >140){
        AlertViewManager *alert = [[AlertViewManager alloc] init];
        [alert alertNewView:self msg:@"对不起, 字数大于140, 超过了微博的限制"];
    }else{
        AlertViewManager *alert = [[AlertViewManager alloc] init];
        [alert alertNewView:self msg:@"对不起, 请不要发送空内容"];
    }
        
    return nil;
}

-(void)dismissSelf
{
    [self dismissModalViewControllerAnimated:YES];
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
    }else if(sum >140){
        AlertViewManager *alert = [[AlertViewManager alloc] init];
        [alert alertNewView:self msg:@"对不起, 字数大于140, 超过了微博的限制"];
    }else{
        AlertViewManager *alert = [[AlertViewManager alloc] init];
        [alert alertNewView:self msg:@"对不起, 请不要发送空内容"];
    }
    
    return nil;
}

- (void)viewDidUnload {
    [self setSina:nil];
    [self setTc:nil];
    [super viewDidUnload];
}
@end

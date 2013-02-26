//
//  OauthViewController.m
//  Golf
//
//  Created by Lynn Liu on 6/25/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import "OauthViewController.h"
#import "UserTokenFileOperate.h"
#import "OauthKey.h"

@interface OauthViewController () <UIWebViewDelegate>
{
    UIActivityIndicatorView *indicator;
    NSString *firstResponse;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *navigation;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end

@implementation OauthViewController
@synthesize navigation = _navigation;
@synthesize webview = _webview;
@synthesize url = _url;
@synthesize segueString = _segueString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webview setDelegate:self];
    
    indicator = [[UIActivityIndicatorView alloc] init];
    indicator.frame = CGRectMake(160, 160, indicator.frame.size.width, indicator.frame.size.height);
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.webview addSubview:indicator];
    [self.webview loadRequest:request];  
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [indicator startAnimating];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicator stopAnimating];
    
    NSString *url = webView.request.URL.absoluteString;
    NSString *tokenString = @"#access_token=";
    NSRange range = [url rangeOfString:tokenString];

    if (range.length && ![url isEqualToString:self.url]){
        [UserTokenFileOperate write:@"游客" url:url host:self.segueString];
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)leftConfirm:(UIBarButtonItem *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end

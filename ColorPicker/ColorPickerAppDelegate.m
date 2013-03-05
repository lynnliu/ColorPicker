//
//  ColorPickerAppDelegate.m
//  ColorPicker
//
//  Created by  lynn on 2/18/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ColorPickerAppDelegate.h"
#import "ColorPickerBaseViewController.h"
#import "TimerManager.h"

@implementation ColorPickerAppDelegate

ColorPickerRootViewController *cptbc;
DMSplashAdController *_splashAd;
UIImageView *coverView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 初始化开屏广告控制器，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
    _splashAd = [[DMSplashAdController alloc] initWithPublisherId:AdKey
                                                           window:self.window
                                                       background:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default@2x.png"]]
                                                        animation:YES];
    _splashAd.delegate = self;
    _splashAd.rootViewController = cptbc;
    
    coverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default@2x.png"]];
    [self.window.rootViewController.view addSubview:coverView];
    coverView.frame = [UIApplication sharedApplication].keyWindow.frame;
    [TimerManager timer:self timeInterval:5 timeSinceNow:0 selector:@selector(showAd:) repeats:NO];
    [TimerManager timer:self timeInterval:15 timeSinceNow:5 selector:@selector(removeBackground:) repeats:NO];

    // Override point for customization after application launch.
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        cptbc = [[ColorPickerRootViewController alloc] init];
        cptbc = (ColorPickerRootViewController *)self.window.rootViewController;
        cptbc.rootViewDelegate = self;
    }
    [WXApi registerApp:WXAppID];
    
    return YES;
}

-(void)showAd:(id)sender
{
    if (_splashAd.isReady) [_splashAd present];
}

-(void)removeBackground:(id)sender
{
    if (coverView){
        [coverView removeFromSuperview];
        coverView = nil;
    }
}

#pragma DMSplashAdController delegate
-(void)dmSplashAdSuccessToLoadAd:(DMSplashAdController *)dmSplashAd
{
    NSLog(@"success");
}

// 加载广告成功后，回调该方法
-(void)dmSplashAdWillPresentScreen:(DMSplashAdController *)dmSplashAd
{
    [coverView removeFromSuperview];
    coverView = nil;
}

// 加载广告失败后，回调该方法
-(void)dmSplashAdFailToLoadAd:(DMSplashAdController *)dmSplashAd withError:(NSError *)err
{
    [coverView removeFromSuperview];
    coverView = nil;
    NSLog(@"dmAd error = %@",err);
}

// 微信 分享
-(void)sendReqWebChat:(BOOL)reqType txt:(NSString *)msg
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"icon.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"icon@2x" ofType:@"png"];
    ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = reqType ? WXSceneTimeline : WXSceneSession;
    
    [WXApi sendReq:req];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)onReq:(BaseReq *)req
{
    NSLog(@"req = %@",req);
}

-(void)onResp:(BaseResp *)resp
{
    NSLog(@"resp = %@",resp);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

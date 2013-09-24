//
//  ColorPickerAppDelegate.m
//  ColorPicker
//
//  Created by  lynn on 2/18/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ColorPickerAppDelegate.h"
#import "ColorPickerTabBarController.h"
#import "TimerManager.h"

@implementation ColorPickerAppDelegate

ColorPickerTabBarController *cptbc;
DMSplashAdController *_splashAd;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 初始化开屏广告控制器，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
    _splashAd = [[DMSplashAdController alloc] initWithPublisherId:AdKey
                                                           window:self.window
                                                       background:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default@2x.png"]]
                                                        animation:YES];
    _splashAd.delegate = self;
    _splashAd.rootViewController = cptbc;
    [TimerManager timer:self timeInterval:5 timeSinceNow:0 selector:@selector(showAd:) repeats:NO];

    // Override point for customization after application launch.
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        cptbc = [[ColorPickerTabBarController alloc] init];
        cptbc = (ColorPickerTabBarController *)self.window.rootViewController;
    }

    return YES;
}

-(void)showAd:(id)sender
{
    if (_splashAd.isReady) [_splashAd present];
}

#pragma DMSplashAdController delegate
-(void)dmSplashAdSuccessToLoadAd:(DMSplashAdController *)dmSplashAd
{
    NSLog(@"success");
}

// 加载广告成功后，回调该方法
-(void)dmSplashAdWillPresentScreen:(DMSplashAdController *)dmSplashAd
{
    
}

// 加载广告失败后，回调该方法
-(void)dmSplashAdFailToLoadAd:(DMSplashAdController *)dmSplashAd withError:(NSError *)err
{
    NSLog(@"dmAd error = %@",err);
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
    //在此处接收到微信的消息请求，直接进行了分享应用程序。也可以打开特定页面，跟用户交互分享
    if ([req isKindOfClass:[GetMessageFromWXReq class]]){
        [self sendAppResponse];
    }
    NSLog(@"req = %@",req);
}

#define TITLE @"推荐一个应用：屏幕取色（ColorPicker)"
#define Description @"这个程序可以轻松取得你看到的图片上的颜色值。下载试试吧。"
//向微信发送消息
- (void) sendAppContent:(BOOL)reqType
{
    // 发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = TITLE;
    message.description = Description;
    [message setThumbImage:[UIImage imageNamed:@"Icon.png"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = Description;
    ext.url = ITUNESURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = reqType ? WXSceneTimeline : WXSceneSession;
    
    [WXApi sendReq:req];
}

//微信中请求
-(void)sendAppResponse
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"推荐一个应用：屏幕取色（ColorPicker)";
    [message setThumbImage:[UIImage imageNamed:@"Icon.png"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = Description;
    ext.url = ITUNESURL;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;

    [WXApi sendResp:resp];
}

- (void) sendNewsContent:(BOOL)reqType image:(UIImage *)image descript:(NSString *)descript
{
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"Icon.png"]];
    message.description = descript;
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
    ext.imageUrl = ITUNESURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = reqType ? WXSceneTimeline : WXSceneSession;
    
    [WXApi sendReq:req];
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

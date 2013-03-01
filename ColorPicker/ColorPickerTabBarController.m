//
//  ColorPickerTabBarController.m
//  ColorPicker
//
//  Created by  lynn on 2/26/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ColorPickerTabBarController.h"
#import "TimerManager.h"
#import "DMAdView.h"
#import "AlertViewManager.h"
#import <QuartzCore/QuartzCore.h>
#import "ShareSendViewController.h"
#import "DMTools.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Social/Social.h>
#import <ACCOUNTS/ACAccount.h>
#import "LINEActivity.h"

@interface ColorPickerTabBarController () <DMAdViewDelegate,CLLocationManagerDelegate>
{
    DMAdView *_dmAdView;
    UIView *menu;
    DMTools *_dmTools;
    CLLocationManager *locationManager;
}
@end

@implementation ColorPickerTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 500;
    }
    [TimerManager timer:self timeInterval:10 timeSinceNow:0 selector:@selector(showAd:) repeats:NO];
    
    self.sharingText = @"发现这个程序，屏幕取色，可以轻松取得看到图片上的颜色，挺有趣的! https://itunes.apple.com/us/app/color-picker-for-developer/id608956277?ls=1&mt=8";
    self.sharingImage = [UIImage imageNamed:@"Icon@2x.png"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 检查更新提醒
    if (!_dmTools){
        _dmTools = [[DMTools alloc] initWithPublisherId:AdKey];
        [_dmTools checkRateInfo];
    }

    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
        [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [_dmAdView setLocation:newLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location error = %@",error);
}

-(void)showAd:(id)sender
{
    if (self.tabBar.frame.origin.x == 0){
        _dmAdView = [[DMAdView alloc] initWithPublisherId:AdKey size:DOMOB_AD_SIZE_320x50];
        _dmAdView.delegate = self; // 设置 Delegate
        _dmAdView.rootViewController = self; // 设置 RootViewController
        [self.view addSubview:_dmAdView];
        
        UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
        [UIView animateWithDuration:0.4 delay:0 options:options animations:^{
            // 设置⼲⼴广告视图的位置
            _dmAdView.frame = CGRectMake(0, self.view.frame.size.height - 50,
                                         DOMOB_AD_SIZE_320x50.width,
                                         DOMOB_AD_SIZE_320x50.height);   
        } completion:^(BOOL finished){
            [_dmAdView loadAd];
        }];
    }
}

-(void)dismissAdView:(id)sender{
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:0.4 delay:0 options:options animations:^{
        menu.frame = CGRectMake(280, self.view.frame.size.height, 0, 0);
        _dmAdView.frame = CGRectMake(-320, self.view.frame.size.height - 50,DOMOB_AD_SIZE_320x50.width,DOMOB_AD_SIZE_320x50.height);
    } completion:^(BOOL finished){
        [menu removeFromSuperview];
        menu = nil;
        _dmAdView.delegate = nil;
        _dmAdView.rootViewController =  nil;
        _dmAdView = nil;
        [TimerManager timer:self timeInterval:55 timeSinceNow:5 selector:@selector(showAd:) repeats:NO];
    }];
}

#pragma DMAdView delegate
// 加载广告成功后，回调该方法
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    if (!menu) [self showMenu];
}
// 加载广告失败后，回调该方法
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    NSLog(@"dmAd error = %@",error);
}

-(void)showMenu
{
    menu = [[UIView alloc] initWithFrame:CGRectMake(280, self.view.frame.size.height, 0, 0)];
    menu.backgroundColor = [UIColor darkGrayColor];
    [menu.layer setCornerRadius:8];
    
    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 5, 30, 30)];
    [chooseButton addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
    [chooseButton setBackgroundImage:[UIImage imageNamed:@"History.png"] forState:UIControlStateNormal]; //Favourite.png
    chooseButton.tag = 100;
    [menu addSubview:chooseButton];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 40, 30, 30)];
    [closeButton addTarget:self action:@selector(dismissAdView:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[AlertViewManager closeButtonImage] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 10;
    [menu addSubview:closeButton];
    
    [self.view addSubview:menu];
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:0.4 delay:0.4 options:options animations:^{
        menu.frame = CGRectMake(280, self.view.frame.size.height - 125, 455, 75);
    } completion:^(BOOL finished){}];
}

-(void)switchView:(UIButton *)sender
{
    if (sender.tag == 100){
        self.selectedIndex = 1;
        sender.tag = 101;
        [sender setBackgroundImage:[UIImage imageNamed:@"Favourite.png"] forState:UIControlStateNormal];
    }else{
        self.selectedIndex = 0;
        sender.tag = 100;
        [sender setBackgroundImage:[UIImage imageNamed:@"History.png"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)addWeiboShare:(UIBarButtonItem *)sender
{
    if([SLComposeViewController class] != nil){
        NSArray *activityItems;
        
        if (self.sharingImage != nil) {
            activityItems = @[self.sharingText, self.sharingImage];
        } else {
            activityItems = @[self.sharingText];
        }
        
        NSArray *applicationActivities = @[[[LINEActivity alloc] init]];
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                          applicationActivities:applicationActivities];
        
        [self presentViewController:activityController animated:YES completion:nil];
    
    }else{
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

@end

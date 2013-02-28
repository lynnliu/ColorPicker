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

@interface ColorPickerTabBarController () <DMAdViewDelegate,CLLocationManagerDelegate>
{
    DMAdView *_dmAdView;
    UIButton *closeButton;
    DMTools *_dmTools;
    CLLocationManager *locationManager;
}
@end

@implementation ColorPickerTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 500;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 检查更新提醒
    if (!_dmTools){
        _dmTools = [[DMTools alloc] initWithPublisherId:AdKey];
        [_dmTools checkRateInfo];
    }
    
    //创建广告视图
    if (!_dmAdView){
        _dmAdView = [[DMAdView alloc] initWithPublisherId:AdKey size:DOMOB_AD_SIZE_320x50];
        _dmAdView.delegate = self; // 设置 Delegate
        _dmAdView.rootViewController = self; // 设置 RootViewController
        [self.view addSubview:_dmAdView];
        
        [TimerManager timer:self timeInterval:25 timeSinceNow:5 selector:@selector(showAd:) repeats:NO];
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
        [_dmAdView loadAd];
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

#pragma DMAdView delegate
// 加载广告成功后，回调该方法
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    [self closeButton];
}
// 加载广告失败后，回调该方法
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    NSLog(@"dmAd error = %@",error);
}

-(void)closeButton
{
    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(290, self.view.frame.size.height - 35, 20, 20)];
    [closeButton addTarget:self action:@selector(dismissAdView:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[AlertViewManager closeButtonImage] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 10;
    [self.view addSubview:closeButton];
}

-(void)dismissAdView:(id)sender{
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:0.4 delay:0 options:options animations:^{
        _dmAdView.frame = CGRectMake(-320, self.view.frame.size.height - 50,DOMOB_AD_SIZE_320x50.width,DOMOB_AD_SIZE_320x50.height);
    } completion:^(BOOL finished){
        [TimerManager timer:self timeInterval:55 timeSinceNow:5 selector:@selector(showAd:) repeats:NO];
        [closeButton removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)addWeiboShare:(UIBarButtonItem *)sender
{
    ShareSendViewController *ssvc = [[ShareSendViewController alloc] init];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ShareSend" bundle:nil];
    ssvc = story.instantiateInitialViewController;
    ssvc.txt = @"发现这个程序，屏幕取色，可以轻松取得看到图片上的颜色，挺有趣的! https://itunes.apple.com/us/app/color-picker-for-developer/id608956277?ls=1&mt=8";
    [self presentModalViewController:ssvc animated:YES];
}
@end

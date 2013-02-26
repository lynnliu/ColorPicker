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

@interface ColorPickerTabBarController () <DMAdViewDelegate>
{
    DMAdView *_dmAdView;
    UIButton *closeButton;
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
    // 创建⼲⼴广告视图，此处使⽤用的是测试ID，请登陆多盟官⺴⽹网（www.domob.cn）获取新的ID
    _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJzXIIuNaulQzdc5" size:DOMOB_AD_SIZE_320x50];
    _dmAdView.delegate = self; // 设置 Delegate
    _dmAdView.rootViewController = self; // 设置 RootViewController
    [self.view addSubview:_dmAdView]; //
    
    [TimerManager timer:self timeInterval:5 timeSinceNow:5 selector:@selector(showAd:) repeats:NO];
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
            [self closeButton];
        }];
    }
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
        [TimerManager timer:self timeInterval:25 timeSinceNow:5 selector:@selector(showAd:) repeats:NO];
        [closeButton removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addWeiboShare:(UIBarButtonItem *)sender
{
    ShareSendViewController *ssvc = [[ShareSendViewController alloc] init];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ShareSend" bundle:nil];
    ssvc = story.instantiateInitialViewController;
    ssvc.txt = @"发现这样一个程序，屏幕取色，可以轻松取得看到图片上的颜色，挺有趣的! http://www.vgolf.cn/indexm.aspx";
    [self presentModalViewController:ssvc animated:YES];
}

#pragma DMAdView delegate
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    NSLog(@"error = %@",error);
}
@end

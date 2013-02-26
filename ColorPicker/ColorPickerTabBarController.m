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

@interface ColorPickerTabBarController () <DMAdViewDelegate>
{
    DMAdView *_dmAdView;
}
@end

@implementation ColorPickerTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 创建⼲⼴广告视图，此处使⽤用的是测试ID，请登陆多盟官⺴⽹网（www.domob.cn）获取新的ID
        _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJzXIIuNaulQzdc5"
                                                     size:DOMOB_AD_SIZE_320x50];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dmAdView.delegate = self; // 设置 Delegate
    _dmAdView.rootViewController = self; // 设置 RootViewController
    [self.view addSubview:_dmAdView]; //
    
    [TimerManager timer:self timeInterval:5 timeSinceNow:5 selector:@selector(showAd:) repeats:YES];
}

-(void)showAd:(id)sender
{
    if (!self.tabBar.hidden){
        [_dmAdView loadAd];
        
        float y = self.tabBar.frame.origin.y;
        float w = self.tabBar.frame.size.width;
        float h = self.tabBar.frame.size.height;
        
        UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
        [UIView animateWithDuration:0.2 delay:0 options:options animations:^{
            self.tabBar.frame = CGRectMake(320, y, w, h);
            // 设置⼲⼴广告视图的位置
            _dmAdView.frame = CGRectMake(0, self.view.frame.size.height - 50,
                                         DOMOB_AD_SIZE_320x50.width,
                                         DOMOB_AD_SIZE_320x50.height);   
        } completion:^(BOOL finished){
            self.tabBar.hidden = YES;
            [_dmAdView loadAd];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma DMAdView delegate
// 成功加载⼲⼴广告后，回调该⽅方法
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{

}

- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    NSLog(@"error = %@",error);
}

// 当将要呈现出 Modal View 时，回调该⽅方法。如打开内置浏览器。
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView
{

}

- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView
{
    
}

@end

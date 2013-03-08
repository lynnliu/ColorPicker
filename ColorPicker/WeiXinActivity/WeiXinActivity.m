//
//  LINEActivity.m
//
//  Created by Noda Shimpei on 2012/12/04.
//  Copyright (c) 2012年 @noda_sin. All rights reserved.
//

#import "WeiXinActivity.h"
#import "ColorPickerRootViewController.h"

@interface WeiXinActivity() <ColorPickerRootViewControllerDelegate>

@end

@implementation WeiXinActivity

- (NSString *)activityType {
    return @"jp.naver.LINEActivity";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"WeiXinActivityIcon.png"];
}

- (NSString *)activityTitle
{
    NSString *title = @"";
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]){
        title = @"微信";
    }else{
        title = @"WeChat";
    }

    return title;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSString class]] || [activityItem isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([self openLINEWithItem:activityItem])
            break;
    }
}

- (BOOL)isUsableLINE
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]];
}

- (void)openLINEOnITunes
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/wechat/id414478124?mt=8"]];
}

- (BOOL)openLINEWithItem:(id)item
{
    if (![self isUsableLINE]) {
        [self openLINEOnITunes];
        return NO;
    }

    [self openWechat];
    
    return YES;
}

-(void)openWechat
{
    
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
    [[(ColorPickerRootViewController *)self rootViewDelegate] sendAppContent:reqType];
}


@end

//
//  OauthKey.h
//  Golf
//
//  Created by Lynn Liu on 6/26/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//
#pragma Sina app key
#define YOUR_CLIENT_ID @"1826898445"
#define YOUR_CLIENT_SECRET @"a57492e4f1e20431926c8233ca20e86c"

//APP应用程序中定义的回调页面，也可以使用默认的https://api.weibo.com/oauth2/default.html
#define YOUR_REGISTERED_REDIRECT_URI @"https://api.weibo.com/oauth2/default.html"

//新浪微博授权接口页面
#define OAUTH_URL_SINA @"https://api.weibo.com/oauth2/authorize"

//新浪微博发送文字请求接口
#define WEIBO_URL_TEXT_SEND @"https://api.weibo.com/2/statuses/update.json"

//新浪微博发送图片请求接口
#define WEIBO_URL_PHOTO_SEND @"https://upload.api.weibo.com/2/statuses/upload.json"


//腾讯微博
#define APP_KEY_TC @"801318925"
#define APP_SECRET_TC @"125cb4fab9fea45e63798e18c0f1646e"

#define OAUTH_URL_TC @"https://open.t.qq.com/cgi-bin/oauth2/authorize"
#define TC_Redirect_URL @"http://t.qq.com/liuzechenLynn?ptlang=1033"

//腾讯微博文字发送
#define APP_SEND_TEXT @"https://open.t.qq.com/api/t/add"

#define FEEDBACK_SUCCESS @"成功分享。"
#define FEEDBACK_UNSUCCESS @"您绑定的微博认证可能已经过期失效，请重新绑定。"
#define FEEDBACK_UNSUCCESS_REPEAT @"请不要过于频繁的发送同一内容。"

#import <Foundation/Foundation.h>

@interface OauthKey : NSObject

@end

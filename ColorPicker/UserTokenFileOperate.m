//
//  UserTokenFileOperate.m
//  Golf
//
//  Created by Lynn Liu on 6/27/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import "UserTokenFileOperate.h"

@implementation UserTokenFileOperate

+(void)write:(NSString *)userid url:(NSString *)url host:(NSString *)host
{
    UserOauthData *oauth = [[UserOauthData alloc] init];
        
    //获取应用程序沙盒的Documents目录  
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);  
    NSString *plistPath = [paths objectAtIndex:0];
    //得到完整的文件名  
    NSString *filename=[plistPath stringByAppendingPathComponent:@"UserInfoPropertyList.plist"];  
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename]; 
    
    if (!data){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"UserInfoPropertyList" ofType:@"plist"];
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    
    if ([host isEqualToString:@"Sina"]){
        oauth = [self urlParse:url];
        //添加一项内容
        [data setObject:oauth.userToken_Sina forKey:@"userToken_Sina"];
        [data setObject:oauth.userBond_Sina forKey:@"userBond_Sina"];
    }else{
        oauth = [self urlParse_TC:url];    
        //添加一项内容
        [data setObject:oauth.userToken_TC forKey:@"userToken_TC"];
        [data setObject:oauth.userBond_TC forKey:@"userBond_TC"]; 
        [data setObject:oauth.UID_TC forKey:@"UID_TC"];
    }
    
    //输入写入  
    [data writeToFile:filename atomically:YES];
}

+(NSString *)clear:(NSString *)name
{    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);  
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserInfoPropertyList.plist"];  
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];  
    
    if ([name isEqualToString:@"Sina"]){
        [data setObject:@"" forKey:@"userBond_Sina"];
        [data setObject:@"" forKey:@"userToken_Sina"];
    }else{
        [data setObject:@"" forKey:@"userBond_TC"];
        [data setObject:@"" forKey:@"userToken_TC"];
        [data setObject:@"" forKey:@"UID_TC"];
    }
    [data writeToFile:filename atomically:YES];
    return @"绑定";
}

+(UserOauthData *)read
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserInfoPropertyList.plist"];  
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];  
    
    if (!data) NSLog(@"第一次哦。。。");
    
    UserOauthData *oauth = [[UserOauthData alloc] init];
    oauth.userBond_Sina = [data objectForKey:@"userBond_Sina"];
    oauth.userToken_Sina = [data objectForKey:@"userToken_Sina"];

    oauth.userBond_TC = [data objectForKey:@"userBond_TC"];
    oauth.userToken_TC = [data objectForKey:@"userToken_TC"];
    oauth.UID_TC = [data objectForKey:@"UID_TC"];; 

    return oauth;
}

+(UserOauthData *)urlParse:(NSString *)url
{
    UserOauthData *oauth = [[UserOauthData alloc] init];
        
    NSRange rang = NSMakeRange(52, 32);  
    oauth.userToken_Sina = [url substringWithRange:rang];  
    
    NSString *expiresString = @"&expires_in=";
    NSRange rangeExpire = [url rangeOfString:expiresString];
    NSString *uidString = @"&uid=";
    NSRange rangeUID = [url rangeOfString:uidString];
    
    oauth.userBondTime_Sina = [url substringWithRange:NSMakeRange(rangeExpire.location + rangeExpire.length,rangeUID.location - rangeExpire.length - rangeExpire.location)];
    oauth.userBond_Sina = @"YES";
    oauth.UID_Sina = [url substringWithRange:NSMakeRange(rangeUID.location + rangeUID.length,url.length - rangeUID.location - rangeUID.length)];
    
    return oauth;
}

+(UserOauthData *)urlParse_TC:(NSString *)url
{
    UserOauthData *oauth = [[UserOauthData alloc] init];
    
    NSRange rang = NSMakeRange(52, 32);  
    oauth.userToken_TC = [url substringWithRange:rang];      
    oauth.userBond_TC = @"YES";
    
    NSString *openIDString = @"&openid=";
    NSRange rangeOpenID = [url rangeOfString:openIDString];
    NSString *openKeyString = @"&openkey=";
    NSRange rangeOpenKey = [url rangeOfString:openKeyString];

    oauth.UID_TC = [url substringWithRange:NSMakeRange(rangeOpenID.location + rangeOpenID.length, rangeOpenKey.location - rangeOpenID.location - rangeOpenID.length)];
    
    return oauth;
}

+(NSDictionary *)sendTextInfo_Sina:(NSString *)text token:(NSString *)token
{    
    NSString *para = [NSString stringWithFormat:@"access_token=%@",token];
    para = [para stringByAppendingFormat:@"&status=%@",text];
    
    NSDictionary *dic = [self uploadWeiBo:WEIBO_URL_TEXT_SEND para:para];

    return dic;
}

+(NSDictionary *)sendTextInfo_TC:(NSString *)text token:(NSString *)token openid:(NSString *)openID
{
    NSString *para = [NSString stringWithFormat:@"oauth_consumer_key=%@",APP_KEY_TC];
    para = [para stringByAppendingFormat:@"&access_token=%@",token];
    para = [para stringByAppendingFormat:@"&openid=%@",openID];
    para = [para stringByAppendingString:@"&oauth_version=2.a"];    
    para = [para stringByAppendingString:@"&clientip=223.4.112.10"];
    
    para = [para stringByAppendingString:@"&format=json"];
    para = [para stringByAppendingString:@"&syncflag=0"];    
    para = [para stringByAppendingFormat:@"&content=%@",text];
    
    return [self uploadWeiBo:APP_SEND_TEXT para:para];
}

+(NSString *)errorParse_Sina:(NSDictionary *)feedback
{
    if([[feedback objectForKey:@"error"] length] != 0){
        
        if ([[feedback objectForKey:@"error_code"] intValue] == 20016 || [[feedback objectForKey:@"error_code"] intValue] == 20019){
            return FEEDBACK_UNSUCCESS_REPEAT;
        }else{
            [self clear:@"Sina"];
            return FEEDBACK_UNSUCCESS;
        }
    }
    return FEEDBACK_SUCCESS;
}

+(NSString *)errorParse_TC:(NSDictionary *)feedback;
{
    if([[feedback objectForKey:@"errcode"] intValue] != 0){
        if ([[feedback objectForKey:@"errcode"] intValue] == 10 || [[feedback objectForKey:@"errcode"] intValue] == 13){
            return FEEDBACK_UNSUCCESS_REPEAT;
        }else{
            [self clear:@"TC"];
            return FEEDBACK_UNSUCCESS;
        }
    }   
    return FEEDBACK_SUCCESS;
}

+ (NSDictionary *)uploadWeiBo:(NSString *)url para:(NSString *)post
{
    NSURL *requestUrl = [NSURL URLWithString:url];
    NSData *returnData = [self request:requestUrl para:post];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData
                                                        options:NSUTF8StringEncoding
                                                          error:nil];
    return dic;
}

//向服务器发请求
+(NSData *)request:(NSURL *)url para:(NSString *)post
{
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url
                                                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                        timeoutInterval:9];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[post length]];
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    
    //超时，尝试再次加载
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    
    if (error) {
        NSLog(@"%d",error.code);
        return nil;
    }
    return data;
}

@end

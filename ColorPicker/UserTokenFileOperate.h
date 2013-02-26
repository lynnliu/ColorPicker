//
//  UserTokenFileOperate.h
//  Golf
//
//  Created by Lynn Liu on 6/27/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserOauthData.h"
#import "OauthKey.h"

@interface UserTokenFileOperate : NSObject

+(void)write:(NSString *)username url:(NSString *)url host:(NSString *)host;
+(UserOauthData *)read;
+(NSString *)clear:(NSString *)name;

+(NSDictionary *)sendTextInfo_Sina:(NSString *)text token:(NSString *)token;
+(NSDictionary *)sendTextInfo_TC:(NSString *)text token:(NSString *)token openid:(NSString *)openID;

+(NSString *)errorParse_Sina:(NSDictionary *)feedback;
+(NSString *)errorParse_TC:(NSDictionary *)feedback;

@end

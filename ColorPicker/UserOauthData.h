//
//  UserOauthData.h
//  Golf
//
//  Created by Lynn Liu on 6/27/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserOauthData : NSObject

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *userToken_Sina;
@property (nonatomic,strong) NSString *userBond_Sina;
@property (nonatomic,strong) NSString *userBondTime_Sina;
@property (nonatomic,strong) NSString *UID_Sina;
@property (nonatomic,strong) NSString *userToken_TC;
@property (nonatomic,strong) NSString *userBond_TC;
@property (nonatomic,strong) NSString *userBondTime_TC;
@property (nonatomic,strong) NSString *UID_TC;

@end

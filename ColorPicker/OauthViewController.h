//
//  OauthViewController.h
//  Golf
//
//  Created by Lynn Liu on 6/25/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerBaseViewController.h"

@interface OauthViewController : ColorPickerBaseViewController

@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *segueString;

@end

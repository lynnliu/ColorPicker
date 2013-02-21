//
//  AlertViewManager.h
//  Golf
//
//  Created by  lynn on 12/14/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertViewManager : NSObject

+(void)alertViewShow:(id)viewController cancel:(NSString *)cancelTitle confirm:(NSString *)confirmTitle msg:(NSString *)msg;

-(void)alertNewView:(id)viewController msg:(NSString *)msg;

@end

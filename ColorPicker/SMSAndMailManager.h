//
//  SMSAndMailManager.h
//  Golf
//
//  Created by  lynn on 12/21/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class SMSAndMailManager;

@interface SMSAndMailManager : NSObject <MFMessageComposeViewControllerDelegate>

@property (nonatomic,strong) id viewController;
@property (nonatomic,strong) NSString *msg;

-(void)sendMsg;
-(void)sendMail;

@end

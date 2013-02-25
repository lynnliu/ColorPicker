//
//  SMSAndMailManager.m
//  Golf
//
//  Created by  lynn on 12/21/12.
//  Copyright (c) 2012 uLynn. All rights reserved.
//

#import "SMSAndMailManager.h"

@implementation SMSAndMailManager
@synthesize viewController = _viewController;
@synthesize msg = _msg;

-(void)sendMsg
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        MFMessageComposeViewController *msg_send = [[MFMessageComposeViewController alloc] init];
        msg_send.messageComposeDelegate = self;
        msg_send.body = [NSString stringWithString:self.msg];
        [self.viewController presentModalViewController:msg_send animated:YES];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled: break;
        default: break;
    }
    [self.viewController dismissModalViewControllerAnimated:YES];
}

-(void)sendMail
{
    MFMailComposeViewController *mail_send = [[MFMailComposeViewController alloc] init];
    mail_send.mailComposeDelegate = self;
    [mail_send setSubject:@"About ColorPicker"];
    NSArray *array = [NSArray arrayWithObject:@"ulynncom@gmail.com"];
    [mail_send setToRecipients:array];
    [mail_send setMessageBody:self.msg isHTML:NO];
    [self.viewController presentModalViewController:mail_send animated:YES];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled: break;
        case MFMailComposeResultSent: break;
        default: break;
    }
    [self.viewController dismissModalViewControllerAnimated:YES];
}

@end

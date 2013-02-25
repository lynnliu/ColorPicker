//
//  AboutViewController.m
//  ColorPicker
//
//  Created by  lynn on 2/25/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//
#define ITUNESURL @"http://itunes.apple.com/us/app/vgolf/id543834543?ls=1&mt=8"

#import "AboutViewController.h"
#import "SMSAndMailManager.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rateMe:(id)sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:ITUNESURL]];
}

- (IBAction)mailMe:(id)sender
{
    SMSAndMailManager *mail = [[SMSAndMailManager alloc] init];
    mail.msg = @"to Developer:";
    mail.viewController = self;
    [mail sendMail];
}

@end

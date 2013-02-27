//
//  AboutViewController.m
//  ColorPicker
//
//  Created by  lynn on 2/25/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//
#define ITUNESURL @"https://itunes.apple.com/us/app/color-picker-for-developer/id608956277?ls=1&mt=8"

#import "AboutViewController.h"
#import "SMSAndMailManager.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *version;
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
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.version.text = [NSString stringWithFormat:@"Version:%@",version];
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

- (void)viewDidUnload {
    [self setVersion:nil];
    [super viewDidUnload];
}
@end

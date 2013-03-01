//
//  AboutViewController.m
//  ColorPicker
//
//  Created by  lynn on 2/25/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "AboutViewController.h"
#import "SMSAndMailManager.h"
#import "ShareSendViewController.h"

@interface AboutViewController () <MFMailComposeViewControllerDelegate>

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

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled: break;
        case MFMailComposeResultSent: break;
        default: break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)share:(UIButton *)sender
{
    ShareSendViewController *ssvc = [[ShareSendViewController alloc] init];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ShareSend" bundle:nil];
    ssvc = story.instantiateInitialViewController;
    ssvc.txt = @"我发现这个程序，屏幕取色，可以轻松取得看到图片上的颜色，挺有趣的! https://itunes.apple.com/us/app/color-picker-for-developer/id608956277?ls=1&mt=8";
    [self presentModalViewController:ssvc animated:YES];
}

- (void)viewDidUnload {
    [self setVersion:nil];
    [super viewDidUnload];
}
@end

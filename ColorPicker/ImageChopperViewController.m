//
//  ImageChopperViewController.m
//  ColorPicker
//
//  Created by  lynn on 2/18/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ImageChopperViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PickedImageVIew.h"
#import "AlertViewManager.h"
#import "ColorsData+Operator.h"
#import "ImageOperate.h"
#import "ColorHistoryTableViewController.h"

@interface ImageChopperViewController ()<UIGestureRecognizerDelegate,PickedImageVIewDelegate,UIAlertViewDelegate>
{
    UIView *colorPatone;
    UILabel *red;
    UILabel *green;
    UILabel *blue;
    UILabel *alpha;
    NSDictionary *colorsDictionary;
    UIActivityIndicatorView *indicator;
}
@property (strong, nonatomic) UIImageView *choosedImageView;
@end

@implementation ImageChopperViewController

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
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"])
        self.title = @"选取";
    else
        self.title = @"Pick Color";
    
    for (id gesture in  [self.view gestureRecognizers])
        [self.view removeGestureRecognizer:gesture];
    [self patoneCanvas];
    
    UIImage *image = [self.choosedImageInfo objectForKey:@"UIImagePickerControllerEditedImage"];
    PickedImageVIew *pickedImageView = [[PickedImageVIew alloc] initWithFrame:CGRectMake(0, 0, 320, 320 * image.size.height / image.size.width)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) pickedImageView.frame = CGRectMake(192, 0, 640, 640 * image.size.height / image.size.width);
    pickedImageView.sendImage = image;
    pickedImageView.delegate = self;
    [self.view addSubview:pickedImageView];
    
    [self saveButton];
}

-(void)patoneCanvas
{
    colorPatone = [[UIView alloc] initWithFrame:CGRectMake(0, 320, 320, self.view.frame.size.height - 320)];
    colorPatone.backgroundColor = [UIColor clearColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) colorPatone.frame = CGRectMake(0, 400, 1024, self.view.frame.size.height - 400);
    
    red = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    red.textColor = [UIColor lightGrayColor];
    red.backgroundColor = [UIColor clearColor];
    red.font = [UIFont systemFontOfSize:14];
    red.shadowColor = [UIColor darkTextColor];
    [red setShadowOffset:CGSizeMake(0, .3)];
    [colorPatone addSubview:red];
    
    green = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 80, 20)];
    green.textColor = [UIColor lightGrayColor];
    green.backgroundColor = [UIColor clearColor];
    green.font = [UIFont systemFontOfSize:14];
    green.shadowColor = [UIColor darkTextColor];
    [green setShadowOffset:CGSizeMake(0, .3)];
    [colorPatone addSubview:green];
    
    blue = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 80, 20)];
    blue.textColor = [UIColor lightGrayColor];
    blue.backgroundColor = [UIColor clearColor];
    blue.font = [UIFont systemFontOfSize:14];
    blue.shadowColor = [UIColor darkTextColor];
    [blue setShadowOffset:CGSizeMake(0, .3)];
    [colorPatone addSubview:blue];
    
    alpha = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 80, 20)];
    alpha.textColor = [UIColor lightGrayColor];
    alpha.backgroundColor = [UIColor clearColor];
    alpha.font = [UIFont systemFontOfSize:14];
    alpha.shadowColor = [UIColor darkTextColor];
    [alpha setShadowOffset:CGSizeMake(0, .3)];
    [colorPatone addSubview:alpha];
    [colorPatone setUserInteractionEnabled:NO];
    [self.view addSubview:colorPatone];
}

-(void)saveButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(230, 330, 80, 80)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        button.frame = CGRectMake(934, 410, 80, 80);
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *buttonTitle = @"";
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"])
        buttonTitle = @"保存";
    else
        buttonTitle = @"Save";

    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveTheColor:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"SaveButton.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:button];
}

-(void)getColor:(NSDictionary *)colorInfo
{
    float redValue = [(NSNumber *)[colorInfo valueForKey:@"red"] floatValue];
    float greenValue = [(NSNumber *)[colorInfo valueForKey:@"green"] floatValue];
    float blueValue = [(NSNumber *)[colorInfo valueForKey:@"blue"] floatValue];
    float alphaValue = [(NSNumber *)[colorInfo valueForKey:@"alpha"] floatValue];
    UIColor *color = [[UIColor alloc] initWithRed:redValue / 255.0f green:greenValue / 255.0f blue:blueValue /255.0f alpha:alphaValue /255.0f];
    colorPatone.backgroundColor = color;
    colorsDictionary = colorInfo;
    red.text = [NSString stringWithFormat:@"red     : %.0f",redValue];
    red.textColor = [UIColor colorWithRed:(255 - redValue) / 255.f green:(255 - greenValue) / 255.f blue:(255 - blueValue) / 255.f alpha:1];
    green.text = [NSString stringWithFormat:@"green : %.0f",greenValue];
    green.textColor = red.textColor;
    blue.text = [NSString stringWithFormat:@"blue   : %.0f",blueValue];
    blue.textColor = red.textColor;
    alpha.text = [NSString stringWithFormat:@"alpha : %.0f",alphaValue];
    alpha.textColor = red.textColor;
}

-(void)saveTheColor:(id)sender
{
    if (!indicator){
        if (!red.text.length && !green.text.length && !blue.text.length && !alpha.text.length){
            NSString *msg = @"";
            NSArray *languages = [NSLocale preferredLanguages];
            NSString *currentLanguage = [languages objectAtIndex:0];
            if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]){
                msg = @"请先触摸图片，选择颜色";
            }else if ([currentLanguage isEqualToString:@"ja"]){
                msg = @"画像をタッチ";
            }else{
                msg = @"touch the screen first";
            }

            [AlertViewManager alertViewShow:nil cancel:@"OK" confirm:nil msg:msg];
        }else{
            NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            url = [url URLByAppendingPathComponent:@"Default Color Database"];
            
            UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
            if ([[NSFileManager defaultManager] fileExistsAtPath:[document.fileURL path]]){
                [document openWithCompletionHandler:^(BOOL success){
                    if (success) [self documentIsReady:document];
                    if (!success) NSLog(@"couldn’t open document at %@", url);
                }];
            }else{
                [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
                    if (success) [self documentIsReady:document];
                    if (!success) NSLog(@"couldn’t create document at %@", url);
                }];
            }
        }

    }
}

-(void)documentIsReady:(UIManagedDocument *)document
{
    if (document.documentState == UIDocumentStateNormal) {
        NSManagedObjectContext *context = document.managedObjectContext;
        
        //保存时间
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localDate = [date dateByAddingTimeInterval: interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dataString = [formatter stringFromDate:localDate];
        
        //保存图片到本地
        UIImage *image = [self.choosedImageInfo objectForKey:@"UIImagePickerControllerEditedImage"];
        NSString *filePath = [NSString stringWithFormat:@"%@.png",dataString];
        [ImageOperate writeImage:image toFileAtPath:filePath];
        
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[colorsDictionary valueForKey:@"red"],@"red",
                                                                        [colorsDictionary valueForKey:@"green"],@"green",
                                                                        [colorsDictionary valueForKey:@"blue"],@"blue",
                                                                        [colorsDictionary valueForKey:@"alpha"],@"alpha",
                                                                        [colorsDictionary valueForKey:@"pointx"],@"pointx",
                                                                        [colorsDictionary valueForKey:@"pointy"],@"pointy",
                                                                        filePath,@"savedimage",
                                                                        dataString,@"createtime",
                                                                        nil];
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator startAnimating];
        
        [document.managedObjectContext performBlock:^{
            ColorsData *color = [ColorsData ColorWithPickerInfo:info inManagedObjectContext:context];    
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                indicator = nil;
                NSString *msg = @""; NSString *cancel = @""; NSString *confirm = @"";
                if (color){
                    NSArray *languages = [NSLocale preferredLanguages];
                    NSString *currentLanguage = [languages objectAtIndex:0];
                    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]){
                        msg = @"保存成功，您可以进行如下操作！"; cancel = @"返回"; confirm = @"查看";
                    }else if ([currentLanguage isEqualToString:@"ja"]){
                        msg = @"OK！接下来："; cancel = @"帰る"; confirm = @"查看";
                    }else{
                        msg = @"Success！You can:"; cancel = @"Go back"; confirm = @"Check";
                    }
                    [AlertViewManager alertViewShow:self cancel:cancel confirm:confirm msg:msg];
                }else{
                    NSArray *languages = [NSLocale preferredLanguages];
                    NSString *currentLanguage = [languages objectAtIndex:0];
                    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]){
                        msg = @"操作失败！"; cancel = @"重试"; 
                    }else if ([currentLanguage isEqualToString:@"ja"]){
                        msg = @"Failed！"; cancel = @"再来";
                    }else{
                        msg = @"Failed！"; cancel = @"Again";
                    }

                    [AlertViewManager alertViewShow:nil cancel:@"重试" confirm:nil msg:@"操作失败！"];
                }
            });
        }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:{
            ColorHistoryTableViewController *chtvc = [[ColorHistoryTableViewController alloc] init];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"ColorHistoryTableViewController" bundle:nil];
            chtvc = story.instantiateInitialViewController;
            chtvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chtvc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    self.choosedImageView = nil;
    [super viewDidUnload];
}
@end

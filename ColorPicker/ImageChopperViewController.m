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

@interface ImageChopperViewController ()<UIGestureRecognizerDelegate,PickedImageVIewDelegate>
{
    UIView *colorPatone;
    UILabel *red;
    UILabel *green;
    UILabel *blue;
    UILabel *alpha;
    CGPoint savedPoint;
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
    for (id gesture in  [self.view gestureRecognizers])
        [self.view removeGestureRecognizer:gesture];
    
    UIImage *image = [self.choosedImageInfo objectForKey:@"UIImagePickerControllerEditedImage"];
    PickedImageVIew *pickedImageView = [[PickedImageVIew alloc] initWithFrame:CGRectMake(0, 0, 320, 320 * image.size.height / image.size.width)];
    pickedImageView.sendImage = image;
    pickedImageView.delegate = self;
    [self.view addSubview:pickedImageView];
    
    [self patoneCanvas];
    [self saveButton];
}

-(void)patoneCanvas
{
    colorPatone = [[UIView alloc] initWithFrame:CGRectMake(0, 320, 320, self.view.frame.size.height - 320)];
    colorPatone.backgroundColor = [UIColor clearColor];
    
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
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:UITextAlignmentCenter];
    [button addTarget:self action:@selector(saveTheColor:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"SaveButton.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:button];
}

-(void)getColor:(NSArray *)colorArray point:(CGPoint)point
{
    UIColor *color = [[UIColor alloc] initWithRed:[[colorArray objectAtIndex:0] floatValue] / 255.0f
                                            green:[[colorArray objectAtIndex:1] floatValue] / 255.0f
                                             blue:[[colorArray objectAtIndex:2] floatValue] /255.0f
                                            alpha:[[colorArray objectAtIndex:3] floatValue] /255.0f];
    
    colorPatone.backgroundColor = color;
    savedPoint = point;
    red.text = [NSString stringWithFormat:@"red     : %.0f",[[colorArray objectAtIndex:0] floatValue]];
    green.text = [NSString stringWithFormat:@"green : %.0f",[[colorArray objectAtIndex:1] floatValue]];
    blue.text = [NSString stringWithFormat:@"blue   : %.0f",[[colorArray objectAtIndex:2] floatValue]];
    alpha.text = [NSString stringWithFormat:@"alpha : %.0f",[[colorArray objectAtIndex:3] floatValue]];
}

-(void)saveTheColor:(id)sender
{
    if (!red.text.length && !green.text.length && !blue.text.length && !alpha.text.length)
        [AlertViewManager alertViewShow:nil cancel:@"OK" confirm:nil msg:@"请先触摸图片，选择颜色"];
    else{
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        [url URLByAppendingPathComponent:@"Default Color Database"];
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

-(void)documentIsReady:(UIManagedDocument *)document
{
    if (document.documentState == UIDocumentStateNormal) {
        NSManagedObjectContext *context = document.managedObjectContext;
        // do something with the Core Data context
        UIImage *image = [self.choosedImageInfo objectForKey:@"UIImagePickerControllerEditedImage"];
        NSUInteger width = CGImageGetWidth([image CGImage]);
        NSUInteger height = CGImageGetHeight([image CGImage]);
        NSData *imageData = [ImageOperate getImageData:image height:height width:width];
        
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localDate = [date dateByAddingTimeInterval: interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dataString = [formatter stringFromDate:localDate];
        
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[red.text intValue]],@"red",
                                                                        [NSNumber numberWithInt:[green.text intValue]],@"green",
                                                                        [NSNumber numberWithInt:[blue.text intValue]],@"blue",
                                                                        [NSNumber numberWithInt:[alpha.text intValue]],@"alpha",
                                                                        [NSNumber numberWithInt:savedPoint.x],@"pointx",
                                                                        imageData,@"savedimage",
                                                                        dataString,@"createtime",
                                                                        nil];
        [document.managedObjectContext performBlock:^{
            [ColorsData ColorWithPickerInfo:info inManagedObjectContext:context];
        }];
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

//
//  ColorHistoryTableViewController.m
//  ColorPicker
//
//  Created by  lynn on 2/23/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ColorHistoryTableViewController.h"
#import "ColorHistoryTableViewCell.h"
#import "ColorsData+Operator.h"
#import "ImageOperate.h"
#import "ColorHistoryDetailViewController.h"

@interface ColorHistoryTableViewController ()

@end

@implementation ColorHistoryTableViewController
@synthesize colorDatabase = _colorDatabase;

-(void)setColorDatabase:(UIManagedDocument *)colorDatabase
{
    if (_colorDatabase != colorDatabase){
        _colorDatabase = colorDatabase;
        [self userDocument];
    }
}

-(void)userDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.colorDatabase.fileURL path]]){
        [self.colorDatabase saveToURL:self.colorDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if (success) [self setupFetchedResultsController];
            if (!success) NSLog(@"couldn’t create document at %@", self.colorDatabase.fileURL);
        }];
    }
    else if (self.colorDatabase.documentState == UIDocumentStateClosed){
        [self.colorDatabase openWithCompletionHandler:^(BOOL success){
            if (success) [self setupFetchedResultsController];
            if (!success) NSLog(@"couldn’t open document at %@", self.colorDatabase.fileURL);
        }];
    }
    else if (self.colorDatabase.documentState == UIDocumentStateNormal){
        [self setupFetchedResultsController];
    }
}

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ColorsData"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createtime" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.colorDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.rowHeight = 60;
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]){
        self.title = @"历史纪录";
    }
    else{
        self.title = @"Color Data";
    }
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Default Color Database"];
    self.colorDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Color Cell";

    UINib *nib = [UINib nibWithNibName:@"ColorHistoryTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    ColorHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    ColorsData *color = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.colorValue = [NSString stringWithFormat:@"r:%d g:%d b:%d a:%d",[color.red intValue],[color.green intValue],[color.blue intValue],[color.alpha intValue]];
    cell.colorLabel.textColor = [UIColor colorWithRed:(255 - [color.red intValue]) / 255.f green:(255 - [color.green intValue]) / 255.f blue:(255 - [color.blue intValue]) / 255.f alpha:1];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:color.createtime];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *dataString = [formatter2 stringFromDate:date];
    cell.time = [NSString stringWithFormat:@"%@",dataString];
    
    cell.timeLabel.textColor = cell.colorLabel.textColor;
    cell.color = [UIColor colorWithRed:[color.red intValue]/255.0f green:[color.green intValue]/255.0f blue:[color.blue intValue]/255.0 alpha:[color.alpha intValue]/255.0];
    UIImage *image = [ImageOperate GetImageFromLocal:color.savedimage];
    if (image) cell.image = image;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //先行删除阵列中的物件
    ColorsData *color = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDictionary *colorInfo = [NSDictionary dictionaryWithObjectsAndKeys:color.red,@"red",
                               color.green,@"green",
                               color.blue,@"blue",
                               color.alpha,@"alpha",nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //读取存在沙盒里面的文件图片
    NSString *imageFullPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:color.savedimage];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageFullPath]) {
        //如果存在就删除
        [[NSFileManager defaultManager] removeItemAtPath:imageFullPath error:nil];
    }

    [ColorsData prepareToDeletion:colorInfo inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColorsData *color = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ColorHistoryDetailViewController *chdvc = [[ColorHistoryDetailViewController alloc] init];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ColorHistoryDetail" bundle:nil];
    chdvc = story.instantiateInitialViewController;
    
    chdvc.colorName = [NSString stringWithFormat:@"r:%d g:%d b:%d a:%d",[color.red intValue],[color.green intValue],[color.blue intValue],[color.alpha intValue]];
    chdvc.color = [UIColor colorWithRed:[color.red intValue] / 255.f green:[color.green intValue] / 255.f blue:[color.blue intValue] / 255.f alpha:1];
    chdvc.textColor = [UIColor colorWithRed:(255 - [color.red intValue]) / 255.f green:(255 - [color.green intValue]) / 255.f blue:(255 - [color.blue intValue]) / 255.f alpha:1];
    chdvc.image = [ImageOperate GetImageFromLocal:color.savedimage];
    
    chdvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chdvc animated:YES];
}

@end

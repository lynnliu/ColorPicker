//
//  ColorHistoryTableViewController.m
//  ColorPicker
//
//  Created by  lynn on 2/23/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ColorHistoryTableViewController.h"
#import "ColorsData.h"

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
    }else if (self.colorDatabase.documentState == UIDocumentStateClosed){
        [self.colorDatabase openWithCompletionHandler:^(BOOL success){
            if (success) [self setupFetchedResultsController];
            if (!success) NSLog(@"couldn’t open document at %@", self.colorDatabase.fileURL);
        }];
    }else if (self.colorDatabase.documentState == UIDocumentStateNormal){
        [self setupFetchedResultsController];
    }
}

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ColorsData"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createtime" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.colorDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.colorDatabase){
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        [url URLByAppendingPathComponent:@"Default Color Database"];
        self.colorDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Color Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    ColorsData *color = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"%@",color);
    
    return cell;
}

@end

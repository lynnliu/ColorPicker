//
//  ColorHistoryTableViewController.h
//  ColorPicker
//
//  Created by  lynn on 2/23/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface ColorHistoryTableViewController : CoreDataTableViewController

@property (nonatomic,strong) UIManagedDocument *colorDatabase;

@end

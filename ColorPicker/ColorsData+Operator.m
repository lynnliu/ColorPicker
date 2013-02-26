//
//  ColorsData+Operator.m
//  ColorPicker
//
//  Created by  lynn on 2/23/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ColorsData+Operator.h"
#import "AlertViewManager.h"

@implementation ColorsData (Operator)

+(ColorsData *)ColorWithPickerInfo:(NSDictionary *)colorInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    ColorsData *color = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ColorsData"];
    request.predicate = [NSPredicate predicateWithFormat:@"red = %@ and green = %@ and blue = %@ and alpha = %@",[colorInfo valueForKey:@"red"],
                                                                                                                 [colorInfo valueForKey:@"green"],
                                                                                                                 [colorInfo valueForKey:@"blue"],
                                                                                                                 [colorInfo valueForKey:@"alpha"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createtime" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1) {
        NSLog(@"错误发生了！matches in ColorsData(Operator, ColorWithPickerInfo) ");
        return nil;
    }else if ([matches count] == 0) {
        color = [NSEntityDescription insertNewObjectForEntityForName:@"ColorsData" inManagedObjectContext:(NSManagedObjectContext *)context];
        color.red = [colorInfo valueForKey:@"red"];
        color.green = [colorInfo valueForKey:@"green"];
        color.blue = [colorInfo valueForKey:@"blue"];
        color.alpha = [colorInfo valueForKey:@"alpha"];
        color.pointx = [colorInfo valueForKey:@"pointx"];
        color.pointy = [colorInfo valueForKey:@"pointy"];
        color.createtime = [colorInfo valueForKey:@"createtime"];
        return color;
    }else{
        [AlertViewManager alertViewShow:nil cancel:@"OK" confirm:nil msg:@"您已经保存了此颜色"];
        return nil;
    }
}

+(void)prepareToDeletion:(NSDictionary *)colorInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ColorsData"];
    request.predicate = [NSPredicate predicateWithFormat:@"red = %@ and green = %@ and blue = %@ and alpha = %@",[colorInfo valueForKey:@"red"],
                         [colorInfo valueForKey:@"green"],
                         [colorInfo valueForKey:@"blue"],
                         [colorInfo valueForKey:@"alpha"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createtime" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches || [matches count] == 0) {
        NSLog(@"错误发生了！matches in ColorsData(Operator, prepareToDeletion) ");
    }else
        [context deleteObject:[matches lastObject]];
}

@end

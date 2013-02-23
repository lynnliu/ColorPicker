//
//  ColorsData+Operator.h
//  ColorPicker
//
//  Created by  lynn on 2/23/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ColorsData.h"

@interface ColorsData (Operator)

+(ColorsData *)ColorWithPickerInfo:(NSDictionary *)colorInfo inManagedObjectContext:(NSManagedObjectContext *)context;

@end

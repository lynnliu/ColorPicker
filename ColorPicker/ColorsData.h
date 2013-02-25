//
//  ColorsData.h
//  ColorPicker
//
//  Created by  lynn on 2/25/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ColorsData : NSManagedObject

@property (nonatomic, retain) NSNumber * alpha;
@property (nonatomic, retain) NSNumber * blue;
@property (nonatomic, retain) NSString * createtime;
@property (nonatomic, retain) NSNumber * green;
@property (nonatomic, retain) NSNumber * pointx;
@property (nonatomic, retain) NSNumber * pointy;
@property (nonatomic, retain) NSNumber * red;
@property (nonatomic, retain) NSString * savedimage;

@end

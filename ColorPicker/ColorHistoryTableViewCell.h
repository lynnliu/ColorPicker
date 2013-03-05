//
//  ColorHistoryTableViewCell.h
//  ColorPicker
//
//  Created by  lynn on 2/25/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorHistoryTableViewCell : UITableViewCell

@property (nonatomic,strong) NSString *colorValue;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIColor *color;

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

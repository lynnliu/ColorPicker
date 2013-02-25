//
//  ColorHistoryTableViewCell.m
//  ColorPicker
//
//  Created by  lynn on 2/25/13.
//  Copyright (c) 2013 uLynn. All rights reserved.
//

#import "ColorHistoryTableViewCell.h"

@implementation ColorHistoryTableViewCell


@synthesize colorValue = _colorValue;
@synthesize time = _time;
@synthesize image = _image;
@synthesize color = _color;
@synthesize savedimageView = _savedimageView;
@synthesize colorLabel = _colorLabel;
@synthesize timeLabel = _timeLabel;

-(void)setColorValue:(NSString *)colorValue
{
    if (_colorValue !=  colorValue){
        _colorValue = colorValue;
        self.colorLabel.text = colorValue;
    }
}

-(void)setColor:(UIColor *)color
{
    if (_color != color){
        _color = color;
        self.backgroundColor = color;
        self.contentView.backgroundColor = color;
    }
}

-(void)setTime:(NSString *)time
{
    if(_time != time){
        _time = time;
        self.timeLabel.text = time;
    }
}

-(void)setImage:(UIImage *)image
{
    if (_image != image){
        _image = image;
        self.savedimageView.image = image;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

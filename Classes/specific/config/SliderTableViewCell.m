/*
 * Copyright (C) 2010 NullGravity
 *
 * This file is part of Curtain.
 *
 * Curtain is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Curtain is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Curtain.  If not, see <http://www.gnu.org/licenses/>.
 */

//
//  SliderTableViewCell.m
//  curtain
//
//  Created by 0xc01df00d on 10-07-16.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import "SliderTableViewCell.h"

#import "curtain.h"
#import "system.h"

@implementation SliderTableViewCell

@synthesize slider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        slider = [[UISlider alloc] initWithFrame:CGRectMake(170, 0, 125, 50)];
		slider.continuous =  NO;
		slider.minimumValue = 0;
		[self addSubview:slider];
		[slider release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end

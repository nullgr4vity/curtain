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
//  ConfigState.m
//  cloth_2
//
//  Created by 0xc01df00d on 10-06-08.
//  Copyright 2010 NullGravity. All rights reserved.
//


#import "Constant.h"
#import "ConfigState.h"


@implementation ConfigState

@synthesize type, value;
@synthesize prev, current;

-(id)init {	
	
	self = [super init];
	
	value = 0;
	type = 0;
	prev = nil;
	current = nil;
	
	return self;
};
	

- (void) encodeWithCoder:(NSCoder*)encoder {
	
	[encoder encodeInteger:value forKey:kConfigKeyMediaValue];
    [encoder encodeInteger:type forKey:kConfigKeyMediaType];	
};

- (id) initWithCoder:(NSCoder*)decoder {

	if (self = [super init]) {
		value = [decoder decodeIntegerForKey:kConfigKeyMediaValue];
		type = [decoder decodeIntegerForKey:kConfigKeyMediaType];
    }
	
	prev = nil;
	current = nil;	
	
    return self;	
};

@end

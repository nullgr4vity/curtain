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
//  ConfigState.h
//  cloth_2
//
//  Created by 0xc01df00d on 10-06-08.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigState : NSObject <NSCoding> {
	NSInteger	value;
	NSInteger	type;
	
	NSIndexPath *prev;
	NSIndexPath *current;
}

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSIndexPath *prev;
@property (nonatomic, retain) NSIndexPath *current;

- (void) encodeWithCoder:(NSCoder*)encoder;
- (id) initWithCoder:(NSCoder*)decoder;


@end

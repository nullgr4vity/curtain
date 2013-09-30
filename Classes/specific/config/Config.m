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
//  Config.m
//  cloth_2
//
//  Created by 0xc01df00d on 10-06-08.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import "Config.h"
#import "ConfigState.h"
#import "Constant.h"


@implementation Config

@synthesize front, back, gears, alpha;

static Config *config_instance = nil;

+(id) instance {
	if (config_instance == nil) {
		config_instance = [Config loadSettings];
	}
	
	return config_instance;
}

-(id) init {
	self = [super init];

	front  = [[ConfigState alloc] init];	
	back  = [[ConfigState alloc] init];	
	
	return self;
};

- (void) encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:front forKey:kConfigFront];
    [encoder encodeObject:back forKey:kConfigBack];	
    [encoder encodeInteger:gears forKey:kConfigGears];	
    [encoder encodeObject:[NSNumber numberWithFloat:alpha] forKey:kConfigAlpha];					
};

- (id) initWithCoder:(NSCoder*)decoder {
	
	if (self = [super init]) {
		
		if ([decoder containsValueForKey:kConfigFront]) {		
			front = [[decoder decodeObjectForKey:kConfigFront] retain];
		}
		
		if ([decoder containsValueForKey:kConfigBack]) {				
			back = [[decoder decodeObjectForKey:kConfigBack] retain];
		}
		
		if ([decoder containsValueForKey:kConfigGears]) {						
			gears = [decoder decodeIntegerForKey:kConfigGears];
		} else {
			gears = 5;
		}
		
		if ([decoder containsValueForKey:kConfigAlpha]) {		
			NSNumber *tmp = [decoder decodeObjectForKey:kConfigAlpha];
			alpha = [tmp floatValue];
		} else {
			alpha	= 0.95;
		}

    }
    return self;	
};

+ (id) loadDefaultSettings {
	Config *config = [[Config alloc] init];
	config.front.type	= kConfigMediaTypeDefault;
	config.front.value	= kDummyValue;
	config.back.type	= kConfigMediaTypeDefault;
	config.back.value	= kDummyValue;	
	
	config.gears		= 5;
	config.alpha		= 0.95;	
	
	[config saveSettings];
	
	return config;
};

+ (id) loadSettings {
	
	NSLog(@"Config::loadSettings(), start");	
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];	
	NSData *encodedObject = [prefs objectForKey:kConfigSettingsUser];
	
	Config *config = [[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject] retain];
	if (config == nil) {
		[config release];
		config = [Config loadDefaultSettings];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kConfigChangesDidFinishNotify object:config];
	
	NSLog(@"Config::loadSettings(), end");	
	
	return config;
}

- (void) saveSettings {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];	
	NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
	
	[prefs setObject:encodedObject forKey:kConfigSettingsUser];	
	[prefs synchronize];
};


@end

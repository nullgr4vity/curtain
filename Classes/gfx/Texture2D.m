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
//  Texture2D.m
//  curtain
//
//  Created by 0xc01df00d on 10-07-05.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import "Texture2D.h"


@implementation Texture2D

@synthesize name;
@synthesize width, height;

-(id) initWithFile:(NSString*)file {
	
	UIImage *image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:file ofType:nil]];
	
	width = CGImageGetWidth(image.CGImage);
	height = CGImageGetHeight(image.CGImage);	
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
	
    void *data = malloc( width * height * 4 );
    CGContextRef context = CGBitmapContextCreate( data, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast );	
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
    CGContextRelease(context);	

	[self setTexData:data];
	
	return self;
}

- (id) setTexData:(const void*)data
{
	if((self = [super init])) {
		glGenTextures(1, &name);
		glBindTexture(GL_TEXTURE_2D, name);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);		
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
		
		size = CGSizeMake(width,height);
		maxS = size.width / (float)width;
		maxT = size.height / (float)height;
	}					
	return self;
}

@end

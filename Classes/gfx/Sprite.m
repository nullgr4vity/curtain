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
//  Sprite.m
//  curtain
//
//  Created by 0xc01df00d on 10-07-05.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

-(id) init
{
	if( (self=[super init]) ) {
		
		[self setTexture:nil];
		
		animations_ = nil;
	
		memset(&t, 0, sizeof(Transformation));		
		
		t.scale[0] = 1;
		t.scale[1] = 1;
		t.scale[2] = 1;	        
	}
	
	return self;
}

+(id) spriteWithFile:(NSString*)filename {
	Texture2D *texture = [[[Texture2D alloc] initWithFile:filename] autorelease];
	if( texture ) {
		return [[Sprite alloc] initWithTexture:texture];
	}
	return nil;
};

-(id) initWithTexture:(Texture2D*)texture {
	if( (self = [self init]) )
	{
		[self setTexture:texture];
		[self setTextureRectWithPosition];
	}
	return self;
}

-(void)setTextureRectWithPosition {
	
	float x1 = 0, y1 = 0;
	float x2 = 1, y2 = 1;
	float  z = 0;
	    
    vertices[0][0] = x1; vertices[0][1] = y1; vertices[0][2] = z;
    vertices[1][0] = x2; vertices[1][1] = y1; vertices[1][2] = z;
    vertices[2][0] = x1; vertices[2][1] = y2; vertices[2][2] = z;
    vertices[3][0] = x2; vertices[3][1] = y2; vertices[3][2] = z;
    
	[self updateTextureCoords:1 :1];
}

-(void) setTexture:(Texture2D*)texture {
	[tex_ release];
	tex_ = [texture retain];
}


-(void) setRotation:(float)angle {
	t.rotate = angle;
};

-(void) setTranslation:(float)x :(float)y :(float)z{
	t.translate[0] = x;
	t.translate[1] = y;
	t.translate[2] = z;
};

-(void) setScale:(float)x :(float)y :(float)z{
	t.scale[0] = x;
	t.scale[1] = y;
	t.scale[2] = z;
	
};

-(float) getRotation{
	return t.rotate;
};

-(float*) getTranslation {
	return (float*)t.translate;
};
-(float*) getScale {
	return (float*)t.scale;
};

-(void)updateTransform:(float)elapsed {
};

-(void)updateTextureCoords:(float)u :(float)v {
	
    
    uv[0][0] = 0; uv[0][1] = 0;
    uv[1][0] = 0; uv[1][1] = v;
    uv[2][0] = u; uv[2][1] = 0;
    uv[3][0] = u; uv[3][1] = v;
}

#define kQuadSize sizeof(quad_.bl)

-(void) draw {

	glBindTexture(GL_TEXTURE_2D, [tex_ name]);

    glColor4f(1, 1, 1, 1);
	glVertexPointer(3, GL_FLOAT, 0, (void*) vertices );
	glTexCoordPointer(2, GL_FLOAT, 0, (void*)uv);

	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

}

@end

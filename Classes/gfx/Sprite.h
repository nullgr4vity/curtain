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
//  Sprite.h
//  curtain
//
//  Created by 0xc01df00d on 10-07-05.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "Texture2D.h"

typedef struct {
	float translate[3];
	float rotate;
	float scale[3];	
} Transformation;

@interface Sprite : Texture2D {
	
	Transformation t;
	
	Texture2D *tex_;
	
	float vertices[4][3];
	float uv[4][2];
		
	NSMutableDictionary *animations_;	
}

+(id) spriteWithFile:(NSString*)filename;

-(id) init;
-(id) initWithTexture:(Texture2D*)texture;

-(void)setTextureRectWithPosition;
-(void)setTexture:(Texture2D*)texture;
-(void)updateTextureCoords:(float)u :(float)v;


-(void) setRotation:(float)angle;
-(void) setTranslation:(float)x :(float)y :(float)z;
-(void) setScale:(float)x :(float)y :(float)z;
-(float) getRotation;
-(float*) getTranslation;
-(float*) getScale;

-(void) updateTransform:(float)elapsed;
-(void) draw;
@end

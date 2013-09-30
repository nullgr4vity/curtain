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

/*
 *  resources.h
 *  cloth_2
 *
 *  Created by 0xc01df00d on 10-05-17.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */


#ifndef __RESOURCES_H__
#define __RESOURCES_H__


#include "mesh.h"
#include "image.h"

#include <OpenGLES/ES1/gl.h>
#include "CoreFoundation/CFDictionary.h"


#ifdef __cplusplus
extern "C" {
#endif
		
extern Mesh	*mesh;
	
Image* reload_texture(NSString *name);	
void load_texture(NSString *resource, Image *image);
void resize_and_save_uiimage(UIImage *input, NSString *name, CGSize size);
void copy_texture_to_documents_if_not_exist(NSString *fname);
void save_uiimage(NSString *fname, UIImage *image);	
		
#ifdef __cplusplus
}
#endif
	
#endif
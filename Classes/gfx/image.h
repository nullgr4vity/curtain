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
 *  image.h
 *  curtain
 *
 *  Created by 0xc01df00d on 10-06-13.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */

#ifndef __ENGINE_IMAGE_H__
#define __ENGINE_IMAGE_H__



#ifdef __cplusplus
extern "C" {
#endif


typedef struct {
	unsigned int	width;
	unsigned int	height;
	
	void			*data;
	
	unsigned int	tid;
} Image;

void free_image(Image* img);

#ifdef __cplusplus
}
#endif
	
#endif
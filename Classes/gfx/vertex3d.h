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
 *  vertice.h
 *  cloth_2
 *
 *  Created by 0xc01df00d on 10-05-17.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */


#ifndef __VERTICE_H__
#define __VERTICE_H__


#include <OpenGLES/ES1/gl.h>

struct ConstraintGraphNode;

typedef struct {
	GLfloat	current[3];
	
	GLfloat u;
	GLfloat v;	
	
	GLfloat	old[3];
	GLfloat vector[3];
	GLfloat step;
	
	int frame;
	
	int triangles[10];
	int trianglesCount;
	

} Vertex3d;

#endif
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
 *  constraint.h
 *  cloth_2
 *
 *  Created by 0xc01df00d on 10-05-17.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */


#ifndef __CONSTRAINT_H__
#define __CONSTRAINT_H__


#include <OpenGLES/ES1/gl.h>
#include "vertex3d.h"


typedef struct {
	
	int index0;
	int index1;
	
	int x1, y1;	
	int x2, y2;
	
	Vertex3d* v0;
	Vertex3d* v1;
	
	GLfloat	length;
	GLfloat inv_length;
	
	int		ignore;
	
} Constraint;


struct Node {

	Constraint *c;

	struct Node	*next;
};


GLfloat compute_length( GLfloat* v1, GLfloat* v2 );
GLfloat estimate_length( GLfloat* v, GLfloat inv_guess, GLfloat guess );


#endif
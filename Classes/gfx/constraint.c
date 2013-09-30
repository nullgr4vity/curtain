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
 *  constraint.c
 *  cloth_2
 *
 *  Created by 0xc01df00d on 10-05-17.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */

#include "constraint.h"
#include <math.h>


GLfloat compute_length( GLfloat* v1, GLfloat* v2 ) {
	
	GLfloat v[3];
	
	v[0] = v2[0] - v1[0];
	v[1] = v2[1] - v1[1];
	v[2] = v2[2] - v1[2];
	
	return sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
		
};

GLfloat estimate_length( GLfloat* v, GLfloat inv_guess, GLfloat guess ) {
	
	GLfloat tmp = v[0] * v[0] + v[1] * v[1] + v[2] * v[2];
	GLfloat len = (tmp * inv_guess + guess) * 0.5;
	
	return len;
}
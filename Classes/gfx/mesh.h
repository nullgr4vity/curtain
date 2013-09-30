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
 *  mesh.h
 *  cloth_2
 *
 *  Created by 0xc01df00d on 10-05-17.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */


#include "Vertex3d.h"
#include "constraint.h"
#include "image.h"

#ifndef __MESH_H__
#define __MESH_H__

typedef struct {
	int		size;
	int		vindex[5];
} Touch;

typedef struct {
	Vertex3d *p1;
	Vertex3d *p2;
	Vertex3d *p3;
} Triangle;

typedef struct {
	int				numVertices;
	Vertex3d		*vertices;
	Vertex3d		*vertices_tier2;	
		
	int				numTriangles;	
	Triangle		*triangles;
	
	int				numConstraints;
	int				constraintsBufferSize;	
	Constraint		*constraints;
	
	Image			*texture;	
		
	GLfloat			*uvs;
	GLfloat			*verts;
		
	int				use_texture;	
	
	Touch			touch;
	
	
	int				use_tearing;
	int				track_tearing;	
	
} Mesh;

#ifdef __cplusplus
extern "C" {
#endif
	
	Mesh*	mesh_init_model();
	void	mesh_free(Mesh* mesh);
	
	
#ifdef __cplusplus
}
#endif

#endif

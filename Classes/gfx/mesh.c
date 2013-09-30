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
 *  mesh.c
 *  cloth_2
 *
 *  Created by 0xc01df00d on 10-05-17.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */

#include "mesh.h"
#include "system.h"
#include <stdio.h>
#include <stdlib.h>

Mesh* mesh;


int max_mem_size = 0;

void* alloc_mem(int size, int count) {
	max_mem_size += (size * count);
	
	NSLog(@"pamiec: %d (razem: %d)", size * count, max_mem_size );
	return calloc(size, count);
}


void build_vertices(Mesh* mesh_ptr) {
	mesh_ptr->numVertices = CLOTH_WIDTH * CLOTH_HEIGHT;
	NSLog(@"rezerwacja pamieci dla mesh_ptr->vertices");
	mesh_ptr->vertices = (Vertex3d*)alloc_mem(1, mesh_ptr->numVertices * sizeof(Vertex3d));	
	memset(mesh_ptr->vertices, 0, mesh_ptr->numVertices * sizeof(Vertex3d));
	NSLog(@"rezerwacja pamieci dla mesh_ptr->vertices_tier2");	
	mesh_ptr->vertices_tier2 = (Vertex3d*)alloc_mem(1, mesh_ptr->numVertices * sizeof(Vertex3d));
	memset(mesh_ptr->vertices_tier2, 0, mesh_ptr->numVertices * sizeof(Vertex3d));	
	
	int index = 0;
	
	for (int y=0; y<CLOTH_HEIGHT; y++) {
		for (int x=0; x<CLOTH_WIDTH; x++) {
			index = x + (y * CLOTH_WIDTH);
			
			mesh_ptr->vertices[index].old[0] = mesh_ptr->vertices[index].current[0] = (x - CLOTH_WIDTH/2)  *  GAP_X;
			mesh_ptr->vertices[index].old[1] = mesh_ptr->vertices[index].current[1] = (y - CLOTH_HEIGHT/2) * -GAP_Y;
			mesh_ptr->vertices[index].old[2] = mesh_ptr->vertices[index].current[2] = 0.0;			
		}
		
	}
	
	return;
}

void build_constraints(Mesh* mesh_ptr) {
	
	mesh_ptr->numConstraints = (CLOTH_WIDTH * CLOTH_HEIGHT * 2) - CLOTH_WIDTH - CLOTH_HEIGHT;	
	mesh_ptr->constraintsBufferSize = mesh_ptr->numConstraints * 4;
	NSLog(@"rezerwacja pamieci dla bufora (rezerwaca 4 razy wiekszy niz potrzeba) mesh_ptr->constraints (ilosc: %d)", mesh_ptr->constraintsBufferSize);		
	mesh_ptr->constraints = (Constraint*)alloc_mem(1, sizeof(Constraint) * mesh_ptr->constraintsBufferSize);
	
	int i = 0;
	for (int y=0; y<CLOTH_HEIGHT; y++) {
		for (int x=0; x<CLOTH_WIDTH; x++) {
			if ((x+1) < CLOTH_WIDTH) {
				
				mesh_ptr->constraints[i].x1 = x;
				mesh_ptr->constraints[i].y1 = y;
				mesh_ptr->constraints[i].x2 = x+1;
				mesh_ptr->constraints[i].y2 = y;
				
				mesh_ptr->constraints[i].index0 = x     + (y * CLOTH_WIDTH);
				mesh_ptr->constraints[i].index1 = x + 1 + (y * CLOTH_WIDTH);				
				mesh_ptr->constraints[i].v0 = &mesh_ptr->vertices[x     + (y * CLOTH_WIDTH)];
				mesh_ptr->constraints[i].v1 = &mesh_ptr->vertices[x + 1 + (y * CLOTH_WIDTH)];
				
				mesh_ptr->constraints[i].length = compute_length(mesh_ptr->constraints[i].v0->current, 
																 mesh_ptr->constraints[i].v1->current);
				mesh_ptr->constraints[i].inv_length = 1/mesh_ptr->constraints[i].length;
				
				i++;
			}
			
			if ((y+1) < CLOTH_HEIGHT) {
				
				mesh_ptr->constraints[i].x1 = x;
				mesh_ptr->constraints[i].y1 = y;
				mesh_ptr->constraints[i].x2 = x;
				mesh_ptr->constraints[i].y2 = y+1;				
				
				mesh_ptr->constraints[i].index0 = x               + (y * CLOTH_WIDTH);
				mesh_ptr->constraints[i].index1 = x + CLOTH_WIDTH + (y * CLOTH_WIDTH);				
				
				mesh_ptr->constraints[i].v0 = &mesh_ptr->vertices[x               + (y * CLOTH_WIDTH)];
				mesh_ptr->constraints[i].v1 = &mesh_ptr->vertices[x + CLOTH_WIDTH + (y * CLOTH_WIDTH)];
				
				mesh_ptr->constraints[i].length = compute_length(mesh_ptr->constraints[i].v0->current,  
																 mesh_ptr->constraints[i].v1->current);				
				mesh_ptr->constraints[i].inv_length = 1/mesh_ptr->constraints[i].length;
				
				i++;
			}
			
			if (i > mesh_ptr->numConstraints) { 
				NSLog(@"!!!! brakuje miejsca dla constraintow, petla: %d, (%d, %d)", mesh_ptr->numConstraints, i, x, y);						
				break;
			}
						
			mesh_ptr->constraints[i].ignore = true;						
		}
		if (i > mesh_ptr->numConstraints) break;
	}
	
	if (i != mesh_ptr->numConstraints) {
		NSLog(@"constraintow: %d, petla: %d", mesh_ptr->numConstraints, i);	
	}
	
	return;
}



void build_triangles(Mesh* mesh_ptr) {
	mesh_ptr->numTriangles = (CLOTH_WIDTH-1) * (CLOTH_HEIGHT-1) * 2;
	NSLog(@"rezerwacja pamieci dla mesh_ptr->triangles (ilosc: %d)", mesh_ptr->numTriangles);			
	mesh_ptr->triangles = (Triangle*)alloc_mem(1,  mesh_ptr->numTriangles * sizeof(Triangle));	
	
	NSLog(@"rezerwacja pamieci dla mesh_ptr->verts");	
	mesh_ptr->verts = (GLfloat*)alloc_mem(1, sizeof(GLfloat[3]) * 3 * mesh_ptr->numTriangles * 3);
	NSLog(@"rezerwacja pamieci dla mesh_ptr->uvs");		
	mesh_ptr->uvs = (GLfloat*)alloc_mem(1, sizeof(GLfloat[2]) * 3 * mesh_ptr->numTriangles * 3);		
		
	int index = 0;
	Triangle *t;	
	
	float frac_x = (SCREEN_WIDTH/512.0) * 1.0/(CLOTH_WIDTH - 1);
	float frac_y = (SCREEN_HEIGHT/512.0) * 1.0/(CLOTH_HEIGHT - 1);	
	
	for (int y=0; y < CLOTH_HEIGHT-1; y++) {  
		for (int x=0; x < CLOTH_WIDTH-1; x++) {
			
			int pos = x + (y * CLOTH_WIDTH);
			
			//			p1 .--. p2
			//			   | /
			//			   ./
			//			  p3			
			t = (Triangle*)&mesh_ptr->triangles[index];
			
			mesh_ptr->vertices[pos].triangles[mesh_ptr->vertices[pos].trianglesCount++] = index;
			t->p1 = &mesh_ptr->vertices[pos];			
			t->p1->u = x * frac_x;
			t->p1->v = y * frac_y;
			
			mesh_ptr->vertices[pos + 1].triangles[mesh_ptr->vertices[pos + 1].trianglesCount++] = index;
			t->p2 = &mesh_ptr->vertices[pos + 1];
			t->p2->u = x * frac_x + frac_x;
			t->p2->v = y * frac_y;			
			
			mesh_ptr->vertices[pos + CLOTH_WIDTH].triangles[mesh_ptr->vertices[pos + CLOTH_WIDTH].trianglesCount++] = index;			
			t->p3 = &mesh_ptr->vertices[pos + CLOTH_WIDTH];
			t->p3->u = x * frac_x;
			t->p3->v = y * frac_y + frac_y;			
			index++;
			
			//			      . p1
			//			     /|
			//			   ./_.
			//			  p3  p2
			t = (Triangle*)&mesh_ptr->triangles[index];			
			
			mesh_ptr->vertices[pos + 1].triangles[mesh_ptr->vertices[pos + 1].trianglesCount++] = index;			
			t->p1 = &mesh_ptr->vertices[pos + 1];
			t->p1->u = x * frac_x + frac_x;
			t->p1->v = y * frac_y;			
			
			mesh_ptr->vertices[pos + 1 + CLOTH_WIDTH].triangles[mesh_ptr->vertices[pos + 1 + CLOTH_WIDTH].trianglesCount++] = index;						
			t->p2 = &mesh_ptr->vertices[pos + 1 + CLOTH_WIDTH];
			t->p2->u = x * frac_x + frac_x;
			t->p2->v = y * frac_y + frac_y;		
			
			mesh_ptr->vertices[pos + CLOTH_WIDTH].triangles[mesh_ptr->vertices[pos + CLOTH_WIDTH].trianglesCount++] = index;						
			t->p3 = &mesh_ptr->vertices[pos + CLOTH_WIDTH];
			t->p3->u = x * frac_x;
			t->p3->v = y * frac_y + frac_y;	
			index++;			
		}
	}
	
	int uv = 0;
	for (int i=0; i < mesh_ptr->numTriangles; i++) {
		
		Triangle *t = &mesh_ptr->triangles[i];
		mesh_ptr->uvs[uv++] = t->p1->u;
		mesh_ptr->uvs[uv++] = t->p1->v;		
		mesh_ptr->uvs[uv++] = t->p2->u;
		mesh_ptr->uvs[uv++] = t->p2->v;
		mesh_ptr->uvs[uv++] = t->p3->u;
		mesh_ptr->uvs[uv++] = t->p3->v;				
	}	
	
	return;
}

Mesh* mesh_init_model() {
	/*	
	float gap_x = (320.0/512.0) * 1.0/CLOTH_WIDTH;
	float gap_y = (480.0/512.0) * 1.0/CLOTH_HEIGHT;	
	*/
	
	NSLog(@"rezerwacja pamieci dla mesh_ptr");			
	Mesh* mesh_ptr = (Mesh*)alloc_mem(1, sizeof(Mesh));
	
	build_vertices(mesh_ptr);
	build_constraints(mesh_ptr);
	build_triangles(mesh_ptr);

	mesh_ptr->touch.size = 0;
	memset(mesh_ptr->touch.vindex, 0, sizeof(int) * 5);
	
	mesh_ptr->use_texture = true;
	mesh_ptr->use_tearing = false;
	
	return mesh_ptr;
};

void mesh_free(Mesh* mesh) {
	
	free(mesh->vertices);	
	mesh->vertices = 0x0;
	free(mesh->vertices_tier2);	
	mesh->vertices_tier2 = 0x0;
	
	free(mesh->triangles);
	mesh->triangles = 0x0;
	
	free(mesh->constraints);
	mesh->constraints = 0x0;	
	
	free_image(mesh->texture);
	mesh->texture = 0x0;
	
	free(mesh->uvs);	
	mesh->uvs = 0x0;
	
	free(mesh->verts);
	mesh->verts = 0x0;
	
	free(mesh);
	mesh = 0x0;
};

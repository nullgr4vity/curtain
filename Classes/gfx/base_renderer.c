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
 *  base_renderer.c
 *  cloth_2
 *
 *  Created by 0xc01df00d on 10-05-17.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */

#include "base_renderer.h"

#include "system.h"
#include "mesh.h"

#include "tearpath.h"

#include <time.h>

#include "Microphone.h"

int			current_frame = 0;
Microphone *mic = [Microphone instance];

void update_vertex(Vertex3d *v) {

	if (v->frame == current_frame) {
		return;
	} 
	
	v->frame = current_frame;
	
	//GLfloat dtdt = 0.0001; 
	GLfloat damping = 0.999;	
		
	GLfloat old[3] = { v->old[0], v->old[1], v->old[2] };
	GLfloat tmp[3] = { v->current[0], v->current[1], v->current[2] };
	
	tmp[0] += damping * (tmp[0] - old[0]);
	tmp[1] += damping * (tmp[1] - old[1]) - 0.00098f;
	

	// ograniczenie na osi Z, tak zeby nie mozna, ponizej zaczynaja sie zebatki 
	if (tmp[2] > -0.1) {	
		float lowPass = [mic lowPassResults];	
		// sprawdzenie mikrofonu, low pass filter
		if (lowPass > 0.8) {								
			// wybor wierzcholkow ktore zaktualizujemy
			if ((float)random()/RAND_MAX > 0.7) {			
				tmp[2] += damping * (tmp[2] - old[2]) - 0.01 * lowPass;			
			}
		} else {
			tmp[2] += damping * (tmp[2] - old[2]);		
		}
	}
	
	v->old[0] = v->current[0];
	v->old[1] = v->current[1];
	v->old[2] = v->current[2];
	
	v->current[0] = tmp[0];
	v->current[1] = tmp[1];
	v->current[2] = tmp[2];
	
	return;
};


void verlet_integrate(Mesh* m) {
		
	for (int i=0; i < m->numTriangles; i++) {
		
		Triangle *t = &m->triangles[i];
				
		update_vertex(t->p1);
		update_vertex(t->p2);
		update_vertex(t->p3);
		
	}
};

void update_touch(Mesh* m) {

	for (int i=0; i < m->touch.size;i++) {
	
		Vertex3d* v = &m->vertices[m->touch.vindex[i]];

		v->current[0]  = v->vector[0];
		v->current[1]  = v->vector[1];
	
		if (v->current[2] > v->vector[2]) {
			v->current[2] += v->step;
		}
	}
}						

Constraint* get_up_constraint(Mesh *m, int index) {
	
	int x = index % 21;
	int y = index / 21;
	
	int up_index = (y-1) * (20 + 21) + (x * 2) + 1;	
	
	
	return &m->constraints[up_index];
}

void process_tearing(Mesh *m, path_node *path) {

	path_node *node = path->first;

	while (node != 0x0) {

		Constraint *c = node->value;
		
		int axis = c->index1 - c->index0;
				
		if (axis == 1) {	

			NSLog(@"tearing poziomy frame: %d, dla c(%d, %d)", current_frame, c->index0, c->index1);
			NSLog(@"tearing poziomy frame: %d, (%d, %d) -> (%d, %d)", current_frame, node->value->x1, node->value->y1, node->value->x2, node->value->y2);
					
			if (node->value->y1 != node->value->y2) {
				NSLog(@"node->value->y1 != node->value->y2");
				return;
			}

			Constraint *clone = &m->constraints[m->numConstraints++];
			memcpy(clone, c, sizeof(Constraint));
			clone->v0 = &m->vertices_tier2[c->index0];
			memcpy(clone->v0, c->v0, sizeof(Vertex3d));
			clone->v1 = &m->vertices_tier2[c->index1];
			memcpy(clone->v1, c->v1, sizeof(Vertex3d));			
			
			Constraint *prev_v = (Constraint *)c+1;
			prev_v->v0 = clone->v0;	
			
			Constraint *next_v = (Constraint *)c+3;			
			if (c->y1 != next_v->y1) {	
				next_v = (Constraint *)c+2;
			}
			next_v->v0 = clone->v1;
			
			if (node == node->first) {
				Constraint *tmp = c-2;
				if (c->y1 == tmp->y1) {					
					Constraint *prev_h = &m->constraints[m->numConstraints++];
					memcpy(prev_h, c-2, sizeof(Constraint));
					prev_h->v1 = clone->v0;
				}
			}
			
			if (node->next == 0x0) {
				Constraint *next_h = &m->constraints[m->numConstraints++];			
				memcpy(next_h, c+2, sizeof(Constraint));			
				next_h->v0 = clone->v1;	
			}
			
			
			clone->v0->triangles[0] = 0x0;
			clone->v0->triangles[1] = 0x0;
			clone->v0->triangles[2] = 0x0;			
			clone->v1->triangles[0] = 0x0;
			clone->v1->triangles[1] = 0x0;
			clone->v1->triangles[2] = 0x0;			
			
			
			// aktualizacja trojkatow		
			if (clone->v0 != nil) {
				
				m->triangles[clone->v0->triangles[3]].p2 = clone->v0;
				m->triangles[clone->v0->triangles[4]].p1 = clone->v0;		
				m->triangles[clone->v0->triangles[5]].p1 = clone->v0;		
			}
			
			if (clone->v1 != nil) {
				m->triangles[clone->v1->triangles[3]].p2 = clone->v1;
				m->triangles[clone->v1->triangles[4]].p1 = clone->v1;		
				m->triangles[clone->v1->triangles[5]].p1 = clone->v1;				
			}
		} else if (axis > 1) {
			
			NSLog(@"tearing vertical frame: %d, dla c(%d, %d)", current_frame, c->index0, c->index1);
			NSLog(@"tearing vertical frame: %d, (%d, %d) -> (%d, %d)", current_frame, node->value->x1, node->value->y1, node->value->x2, node->value->y2);
			
			return;
		}
		
		node = node->next;
		
	}		
	return;
}

void satisfy_constraints(Mesh* m) {
	
	float max_length = 0;
	Constraint *tear_spot = nil;
	
	int number = m->numConstraints;
	
	for (int i=0; i < ITERATION_COUNT; i++)
	{
		update_touch(m);
		
		for (int k=0; k < number; k++)
		{						
			Constraint *c = &m->constraints[k];
						
			
			if (c->v0 == nil || c->v1 == nil) continue;
			
			float c_length = c->length;
			float c_inv_length = c->inv_length;			
			
			GLfloat p0[3] = { c->v0->current[0], c->v0->current[1], c->v0->current[2]};
			GLfloat p1[3] = { c->v1->current[0], c->v1->current[1], c->v1->current[2]};
			
			GLfloat d[3] = {p1[0] - p0[0], p1[1] - p0[1], p1[2] - p0[2]};
			
			GLfloat len = estimate_length(d, c_inv_length, c_length);			
			GLfloat diff = (len - c_length) / len;
			
			// stiffness
			//diff *= 0.75;
			
			d[0] *= diff * 0.5;
			d[1] *= diff * 0.5;
			d[2] *= diff * 0.5;
			
			c->v0->current[0] += d[0];
			c->v0->current[1] += d[1];
			c->v0->current[2] += d[2];			
			
			c->v1->current[0] -= d[0];
			c->v1->current[1] -= d[1];
			c->v1->current[2] -= d[2];
			
			if (len > max_length) {
				max_length = len;
				tear_spot = c;
			}
		}
		
		//NSLog(@"max_length: %f", max_length);
		for (int i = 0; i < CLOTH_WIDTH; i++) {
			m->vertices[i].current[0] = m->vertices[i].old[0];
			m->vertices[i].current[1] = m->vertices[i].old[1];
			m->vertices[i].current[2] = m->vertices[i].old[2];			
		}
	}
	
	if (m->use_tearing) {	
		if (max_length > 0.15) {
			if (m->track_tearing == 1) {
				Constraint *c = tear_spot;
				if (c->index1 - c->index0 != 1) {
					c += 1;
				}
				
				path_node *node = 0x0;
				for (int i=-4; i<4; i+=2) {	
					node = tear_path_add(node, c + i);									
				}
				
				process_tearing(m, node->first);
				tear_path_free(node);
				m->track_tearing = 0;	
			}		
		}	
	}
	
};

NSTimeInterval cet = 0;
void cloth_process(Mesh* m) {
	
	current_frame ++;	

/*
	NSDate *startTime = [NSDate date];
*/
	verlet_integrate(m);
	satisfy_constraints(m);

/*	
	NSDate *stopTime = [NSDate date];
	cet += [stopTime timeIntervalSinceDate:startTime];	
	if (current_frame % 1000000) {
		NSLog(@"cloth_process: %f ms", cet / current_frame);		
	}
*/
};

GLint cloth_copy_vertices(Mesh* m) {
	
	int index = 0;
		
	for (int i=0; i < m->numTriangles; i++) {
		
		Triangle *t = &m->triangles[i];
		
		m->verts[index++] = t->p1->current[0];
		m->verts[index++] = t->p1->current[1];
		m->verts[index++] = t->p1->current[2];
				
		m->verts[index++] = t->p2->current[0];
		m->verts[index++] = t->p2->current[1];
		m->verts[index++] = t->p2->current[2];
		
		m->verts[index++] = t->p3->current[0];
		m->verts[index++] = t->p3->current[1];
		m->verts[index++] = t->p3->current[2];
	}
	
    return m->numTriangles * 3;
}

GLint cloth_copy_vertices_by_constraints(Mesh* m) {
	int index = 0;
			
	for (int i=0; i < m->numConstraints; i++) {
		
		Constraint *c = &m->constraints[i];
		
		m->verts[index++] = c->v0->current[0];
		m->verts[index++] = c->v0->current[1];
		m->verts[index++] = c->v0->current[2];		
		m->verts[index++] = c->v1->current[0];
		m->verts[index++] = c->v1->current[1];
		m->verts[index++] = c->v1->current[2];		
	}	
	
	return m->numConstraints * 2;
	
}

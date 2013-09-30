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
 *  tree.h
 *  curtain
 *
 *  Created by 0xc01df00d on 10-06-19.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */

#include "vertex3d.h"
#include "mesh.h"

typedef struct {
	Vertex3d min;
	Vertex3d max;
} box;

struct quadtree_node {
	struct quadtree_node **node;
	
	box aabb;
};


int aabb_intersect(box *aabb1, box *aabb2) {
	return 0;
}

void build_tree (Mesh* m) {	
	build_tree(m);
	build_tree(m);
	build_tree(m);
	build_tree(m);
}

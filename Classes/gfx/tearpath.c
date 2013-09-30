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
 *  tearpath.c
 *  curtain
 *
 *  Created by 0xc01df00d on 10-06-22.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */

#include "tearpath.h"
#include <stdlib.h>
#include <stdio.h>

path_node* tear_path_add(path_node *node, Constraint *c) {
	if (node != 0x0) {
		
		path_node *item = (path_node*)calloc(1, sizeof(path_node));
		item->next = 0x0;
		item->value = c;
		item->first = node->first;		
		node->next = item;		
		
		node = item;
		
	} else {
		node = (path_node*)calloc(1, sizeof(path_node));
		node->next = 0x0;		
		node->value = c;
		node->first = node;		
	}
	
	return node;
};

void tear_path_free(path_node *path) {
	path_node *first = path->first;
	while(first != 0x0) {
		path_node *tmp = first;
		first = first->next;
		free(tmp);
	}
};
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
 *  system.h
 *  cloth_2
 *
 *  Created by 0xc01df00d on 10-05-17.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */

#define CLOTH_SIZE			441
#define CLOTH_WIDTH			21
#define CLOTH_HEIGHT		21

#define CLOTH_WIDTH_FACTOR	0.065625 // CLOTH_HEIGHT/320.0
#define CLOTH_HEIGHT_FACTOR	0.04375  // CLOTH_WIDTH/480.0

#define GAP_X				0.029761905 // float gap_x = (320.0/512.0) * 1.0/CLOTH_WIDTH;
#define GAP_Y				0.044642857 // float gap_y = (480.0/512.0) * 1.0/CLOTH_HEIGHT;



#define TIMEDELTASQ			0.00001
#define ITERATION_COUNT		10

#define SCREEN_WIDTH		320
#define SCREEN_HEIGHT		480

/*
#define CLOTH_SIZE			1024
#define CLOTH_WIDTH			32
#define CLOTH_HEIGHT		32 
 
#define CLOTH_WIDTH_FACTOR		0.1 // CLOTH_HEIGHT/320.0
#define CLOTH_HEIGHT_FACTOR		0.0666666  // CLOTH_WIDTH/480.0

#define GAP_X 0.01953125 // float gap_x = (320.0/512.0) * 1.0/CLOTH_WIDTH;
#define GAP_Y 0.029296875 // float gap_y = (480.0/512.0) * 1.0/CLOTH_HEIGHT;
*/



#define X 0
#define Y 1
#define Z 2

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)


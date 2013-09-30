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

//
//  curtainAppDelegate.h
//  curtain
//
//  Created by 0xc01df00d on 10-06-13.
//  Copyright NullGravity 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@class BackgroundViewController;
@class TableViewController;

@interface curtainAppDelegate : NSObject <UIAccelerometerDelegate> {
	
	IBOutlet UIWindow *window;		
	IBOutlet UIWindow *windowBackground;
	
	IBOutlet UINavigationController *navController;
	
	IBOutlet BackgroundViewController *backViewController;	
	
	IBOutlet EAGLView *glView;	
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIWindow *windowBackground;

@property (nonatomic, retain) BackgroundViewController *backViewController;
@property (nonatomic, retain) EAGLView *glView;

@property (nonatomic, retain) UINavigationController *navController;

- (void) switchToGL;
- (void) switchToConfig;
- (void) switchToCameraPlusEAGL;

- (void) rearrangeWindows;
- (void) rearrangeWindows_2;

@end

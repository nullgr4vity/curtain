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
//  curtainAppDelegate.m
//  curtain
//
//  Created by 0xc01df00d on 10-06-13.
//  Copyright NullGravity 2010. All rights reserved.
//


#import "curtainAppDelegate.h"
#import "EAGLView.h"

#import <MobileCoreServices/UTCoreTypes.h>

#import "ConfigState.h"
#import "BackgroundViewController.h"

#import "curtain.h"
#import "Config.h"

@implementation curtainAppDelegate

@synthesize window;
@synthesize windowBackground;

@synthesize navController;
@synthesize backViewController;
@synthesize glView;



- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	NSLog(@"applicationDidFinishLaunching");
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO ];	
	
	[self switchToCameraPlusEAGL];
	
	[Config instance];	
}


- (void)switchToConfig {
	[glView stopAnimation];
	[window addSubview:[navController view]];	
	
	appCtx.backgroundTime = YES;
}

- (void)switchToGL {
		
	[[navController view] removeFromSuperview];
	
	glView.animationInterval = 1.0 / 60.0;
	[glView startAnimation];	
	
	appCtx.backgroundTime = NO;		
}

- (void) rearrangeWindows_2 {
	NSArray *windows = [[UIApplication sharedApplication] windows];	
	NSLog(@"rearrange_2, aktualnie obiektow typu UIWindow: %d", [windows count]);
	
	if ([windows count] > 2) {
		UIWindow* wnd;
		
		for (wnd in windows) {
			
			if (wnd == window) {
				NSLog(@"ustawiam level dla window, %f na 0.5", wnd.windowLevel);
				wnd.windowLevel = 0.5;				
				
			} else if (wnd == windowBackground) {
				NSLog(@"ustawiam level dla windowBack, %f na 0.0", wnd.windowLevel);				
				wnd.windowLevel = 0.0;
				
			} else {
				NSLog(@"ustawiam level dla else, %f na 1.0", wnd.windowLevel);				
				wnd.windowLevel = 1.0;
			}
		}
	}
	
	
	[window makeKeyAndVisible];
}

- (void) rearrangeWindows {
	
	
	NSArray *windows = [[UIApplication sharedApplication] windows];	
	NSLog(@"rearrange, aktualnie obiektow typu UIWindow: %d", [windows count]);
	
	if ([windows count] > 2) {
		UIWindow* wnd;
		
		for (wnd in windows) {
			
			if (wnd == window) {
				NSLog(@"ustawiam level dla window, %f na 1.0", wnd.windowLevel);
				wnd.windowLevel = 1.0;
				
				
			} else if (wnd == windowBackground) {
				NSLog(@"ustawiam level dla windowBack, %f na 0.0", wnd.windowLevel);				
				wnd.windowLevel = 0.0;
				
			} else {
				NSLog(@"ustawiam level dla else, %f na 0.5", wnd.windowLevel);				
				wnd.windowLevel = 0.5;
			}
		}
	}
	
	
	[window makeKeyAndVisible];
}

- (void)switchToCameraPlusEAGL {
	
	windowBackground.autoresizesSubviews = YES;
	
	backViewController.parentWindow = windowBackground;
	
	windowBackground.windowLevel = 0.0;
	
	glView.opaque = NO;
	glView.alpha = 1.0;
	glView.backgroundColor = [UIColor clearColor];	
	
	glView.animationInterval = 1.0 / 60.0;
	[glView startAnimation];
	
	window.windowLevel = 1.0;
	[window makeKeyAndVisible];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	NSLog(@"applicationWillResignActive");
	glView.animationInterval = 1.0 / 5.0;
}

-(void) applicationDidEnterBackground:(UIApplication *)application {
	NSLog(@"applicationDidEnterBackground");
	appCtx.backgroundTime == YES;
}

-(void) applicationWillEnterForeground:(UIApplication *)application {
	NSLog(@"applicationWillEnterForeground");	
	appCtx.backgroundTime == NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"applicationDidBecomeActive");	
	glView.animationInterval = 1.0 / 60.0;
}

-(void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"applicationWillTerminate");		
}

- (void)dealloc {
	[glView release];	
	
	[backViewController release];
	
	[window release];	
	[windowBackground release];

	[navController release];
	
	[super dealloc];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
}

@end

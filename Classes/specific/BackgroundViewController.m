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
//  CameraViewController.m
//  cloth_2
//
//  Created by 0xc01df00d on 10-05-31.
//  Copyright 2010 NullGravity. All rights reserved.
//

// [[NSUserDefaults standardUserDefaults] integerForKey:kControlModeKey];


#import "BackgroundViewController.h"

#import "Constant.h"
#import "Config.h"
#import "ConfigState.h"

@implementation BackgroundViewController

@synthesize camera, imageView;
@synthesize parentWindow;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
		
		camera = nil;
		imageView = nil;
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(configChangesDidFinish:) 
													 name:kConfigChangesDidFinishNotify 
												   object:nil];
    }
	
	NSLog(@"BackgroundViewController::initWithCoder(), end");
	
    return self;
}

- (void) configChangesDidFinish:(NSNotification*)notification {
	
	Config *cfg = [notification.object retain];
	
	if (cfg == nil) {
		NSLog(@"BackgroundViewController, notification, cfg == nil");
		return;
	}

	if (cfg.back == nil) {
		NSLog(@"BackgroundViewController, notification, cfg.back == nil");
		return;
	}
	
	[self objectsCleanup];
	
	if (cfg.back.type == kConfigMediaTypeImage) {
		NSLog(@"back.type: wybrano image");
				
		NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];	
		NSString *fpath = [NSString stringWithFormat:@"%@/%@", path, kBackgroundImage];
				
		UIImage *img = [UIImage imageWithContentsOfFile:fpath];			
		[self setImageForImageView:img];
	};
				
	if (cfg.back.type == kConfigMediaTypeCamera) {
		NSLog(@"back.type: wybrano camera");
		[self setAndStartCamera];
	};
				
	if (cfg.back.type == kConfigMediaTypeDefault) {
				
		NSLog(@"back.type: wybrano default");
				
		[self setAndStartCamera];
	}
		
	NSLog(@"BackgroundViewController::configChangesDidFinish(), notification");
};

- (void) setAndStartCamera {

	NSArray *array = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	if ([array count] > 0) {	
		camera = [[UIImagePickerController alloc] init];	
		camera.delegate		= self;	
		camera.sourceType	= UIImagePickerControllerSourceTypeCamera;		
		camera.showsCameraControls = NO;	
		
		[parentWindow addSubview: camera.view];				
	} else {
		[parentWindow setBackgroundColor:[UIColor blackColor]];
	}
}

-(void)setImageForImageView:(UIImage*)image {
	
	if (imageView == nil) {
		imageView = [[UIImageView alloc] init];
	};
	
	imageView.image = image;
	[imageView setFrame:CGRectMake(0, 0, 320, 480)];
	
	[parentWindow addSubview: imageView];
};

-(void) objectsCleanup {
	
	if (camera) {
		[camera.view removeFromSuperview];		
		[camera release];
		camera = nil;
	}
	
	if (imageView) {
		[imageView removeFromSuperview];
		[imageView release];
		imageView = nil;
	}
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
		
	NSLog(@"BackgroundViewController::viewDidLoad");
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	if (camera) [camera release];
	if (imageView) [imageView release];
}


- (void)dealloc {
	
	if (camera) [camera dealloc];
	if (imageView) [imageView dealloc];	
		
    [super dealloc];
}


@end

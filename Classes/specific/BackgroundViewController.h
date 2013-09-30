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
//  CameraViewController.h
//  cloth_2
//
//  Created by 0xc01df00d on 10-05-31.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface BackgroundViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	UIImagePickerController *camera;
	UILabel *label;	
	UIImageView *imageView;
	
	UIWindow *parentWindow;
}

@property (nonatomic, retain) UIImagePickerController *camera;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIWindow *parentWindow;

-(void)setImageForImageView:(UIImage*)image;

-(void) configChangesDidFinish:(NSNotification*)notification;

-(void) setAndStartCamera;

-(void) objectsCleanup;

@end

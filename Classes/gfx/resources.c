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
 *  resources.c
 *  cloth_2
 *
 *  Created by 0xc01df00d on 10-05-17.
 *  Copyright 2010 NullGravity. All rights reserved.
 *
 */


#include "resources.h"
#include "constant.h"
#include <Foundation/NSString.h>

Image* reload_texture(NSString *name) {
	copy_texture_to_documents_if_not_exist(name);
		
	Image *image = (Image*)calloc(1, sizeof(Image));	
	memset(image, 0, sizeof(Image));

	load_texture( name, image);	
		
	return image;
}

void load_texture(NSString *fname, Image *image) {
	
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [NSString stringWithFormat:@"%@/%@", docPath, fname];
	NSLog(@"load_texture, path: %@", path);
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *uiimage = [[UIImage alloc] initWithData:texData];
    if (uiimage == nil)
        NSLog(@"Do real error checking here");
	
	//UIImageWriteToSavedPhotosAlbum(uiimage, nil, nil, nil);			
	
	image->width = CGImageGetWidth(uiimage.CGImage);
	image->height = CGImageGetHeight(uiimage.CGImage);	
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(uiimage.CGImage);
	
    image->data = malloc( image->height * image->width * 4 );
    CGContextRef context = CGBitmapContextCreate( image->data, image->width, image->height, 8, 4 * image->width, colorSpace, kCGImageAlphaPremultipliedLast );
 
    CGContextDrawImage( context, CGRectMake( 0, 0, image->width, image->height ), uiimage.CGImage );
    CGContextRelease(context);	
	
	glGenTextures( 1, &image->tid );
	NSLog(@"load_texture, glGenTextures, tid: %d", image->tid);
	glBindTexture( GL_TEXTURE_2D, image->tid );	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image->width, image->height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image->data);	
	
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);	
		
    [uiimage release];
}

void copy_texture_to_documents(NSString *fname) {
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *dstPath = [NSString stringWithFormat:@"%@/%@", docPath, fname];	
	
	NSLog(@"dst: %@", dstPath);
	NSLog(@"doc: %@", docPath);	
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *appPath = [[NSBundle mainBundle] bundlePath];		
	NSString *srcPath = [NSString stringWithFormat:@"%@/%@", appPath, fname];
		
	NSError *error = nil;
	BOOL success = [fm copyItemAtPath:srcPath toPath:dstPath error:&error];
	if (!success) {
		NSLog(@"copy_texture_to_documents: copy error: %@", [error description]);
	}
	
	if (fm) [fm release];
}

void copy_texture_to_documents_if_not_exist(NSString *fname) {
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *dstPath = [NSString stringWithFormat:@"%@/%@", docPath, fname];	
	
	NSLog(@"dst: %@", dstPath);
	NSLog(@"doc: %@", docPath);	
	
	
	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL fileExists = [fm fileExistsAtPath:dstPath];
	if (!fileExists) {
		NSString *appPath = [[NSBundle mainBundle] bundlePath];		
		NSString *srcPath = [NSString stringWithFormat:@"%@/%@", appPath, fname];
		
		NSError *error = nil;
		BOOL success = [fm copyItemAtPath:srcPath toPath:dstPath error:&error];
		if (!success) {
			NSLog(@"copy_texture_to_documents_if_not_exist: copy error: %@", [error description]);
		}
	}
	
	if (fm) [fm release];
	
	NSLog(@"copy_texture_to_documents_if_not_exist end");	
}

void save_uiimage(NSString* fname, UIImage *image) {
	
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];	
	NSString *fpath = [NSString stringWithFormat:@"%@/%@", path, fname];
	
	NSLog(@"save_uiimage, save to: %@", fpath);
	
	NSData *data = UIImagePNGRepresentation(image);
	BOOL success = [data writeToFile:fpath atomically:YES];	

	NSLog(@"save_uiimage, end, success: %d", success);
}

void resize_and_save_uiimage(UIImage *input, NSString *name, CGSize size) {		
	UIGraphicsBeginImageContext(size);		
	CGSize input_size = [input size];	
	[input drawInRect:CGRectMake(0, 0, 320, 480)];	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	NSLog(@"resize_and_save_uiimage end, pre save_uiimage");
	
	save_uiimage(name, image);
	
	return;
}

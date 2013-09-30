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
//  TableViewController.m
//  curtain
//
//  Created by 0xc01df00d on 10-07-16.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import "TableViewController.h"
#import "resources.h"
#import "image.h"
#import "Constant.h"

#import "Config.h"
#import "ConfigState.h"

#import <MobileCoreServices/UTCoreTypes.h>

#import "TwitterAgent.h"

#import "curtain.h"

@implementation TableViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"TableViewController.viewDidLoad");	
	
    [super viewDidLoad];
}

- (id) initWithCoder:(NSCoder*)decoder {
	NSLog(@"TableViewController::initWithCoder");
	
	self = [super initWithCoder:decoder];
	
	image_picker = nil;
	currentIndexPath = nil;
	
	config = [Config loadSettings];	
	
	return self;
}

- (void) viewDidAppear:(BOOL)animated {
		
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (section == kConfigSectionFront) {
		return @"Front page";
	}
	
	if (section == kConfigSectionBackground) {
		return @"Back page";
	}

	if (section == kConfigSectionGeneral) {
		return @"Message center";
	}	
	
	return @"Default";
	
}

-(UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		if (indexPath.row == 0) {
			if (indexPath.section == 0) {
				cell = alphaCell = [[[SliderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				alphaCell.slider.maximumValue = 1.0;
				alphaCell.slider.value = appCtx.alpha;					
				[alphaCell.slider addTarget:self action:@selector(sliderAlphaChanged:) forControlEvents:UIControlEventValueChanged];				
			} else if (indexPath.section == 1) {
				cell = gearsCell = [[[SliderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				gearsCell.slider.maximumValue = 6*8;
				gearsCell.slider.value = appCtx.gears;
				[gearsCell.slider addTarget:self action:@selector(sliderGearsChanged:) forControlEvents:UIControlEventValueChanged];								
			} 
		} else {
			cell = [[[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
	}
	
	config = [Config instance];	
	
	if ([indexPath section] == kConfigSectionFront) {			
		if([indexPath row] == 0) { 
			cell.textLabel.text = [NSString stringWithFormat:@"alpha: %.2f", appCtx.alpha];
		};

		if([indexPath row] == 1) { 
			cell.textLabel.text = @"image";	
		};

		if([indexPath row] == 2) { 
			cell.textLabel.text = @"default image";	
		};		
		
		if (config.front.type == [indexPath row]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			config.front.current = indexPath;
		}
	};
	
	if ([indexPath section] == kConfigSectionBackground) {
		if([indexPath row] == 0) {
			cell.textLabel.text = [NSString stringWithFormat:@"gears: %d", appCtx.gears];
		}				
		if([indexPath row] == 1) {
			cell.textLabel.text = @"image";	
		}
		if([indexPath row] == 2) {
			cell.textLabel.text = @"camera";	
		}
		
		if (config.back.type == [indexPath row]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			config.back.current = indexPath;
		}
	};

	return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
	if (section < kConfigSectionGeneral) {
		return 0;
	}
	
	return 100;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
	if (section < kConfigSectionGeneral) return nil;
	if (footerView == nil) {				
		footerView = [[UIView alloc] init];
		
		UIButton *twitterBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[twitterBtn setFrame:CGRectMake(10, 5, 300, 44)];
		[twitterBtn setTitle:@"if you like it, tweet this" forState:UIControlStateNormal];
		[twitterBtn addTarget:self action:@selector(callTwitter:) forControlEvents:UIControlEventTouchUpInside];
		UIImage *image = [UIImage imageNamed:@"twitter-logo-twit.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 32, 32)];		
		[imageView setImage:image];		
		[twitterBtn addSubview:imageView];
	
		UIButton *emailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[emailBtn setFrame:CGRectMake(10, 55, 300, 44)];
		[emailBtn setTitle:@"send us feedback, good or bad" forState:UIControlStateNormal];
		[emailBtn addTarget:self action:@selector(callEmail:) forControlEvents:UIControlEventTouchUpInside];
		
		[footerView addSubview:twitterBtn];		
		[footerView addSubview:emailBtn];				
		
		[imageView release];		
	}
	
	return footerView;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (section == kConfigSectionFront) return 3;
	if (section == kConfigSectionBackground) {
		NSArray *array = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
		if ([array count] > 0) {	
			return 3;
		} else {
			return 2;
		}
	}
	if (section == kConfigSectionGeneral) return 0;	
	
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ConfigState *state = nil;	
	currentIndexPath = indexPath;
	
	NSLog(@"didSelectRowAtIndexPath: s:%d, r:%d", indexPath.section, indexPath.row);
	
	if (indexPath.section == kConfigSectionGeneral) {
		return;
	}	
	
	if (indexPath.section == kConfigSectionFront) {	
		
		state = config.front;
		
		switch (indexPath.row) {
			case 1: {
				
				[self initImagePicker];
				
				NSArray *types = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
				image_picker.mediaTypes = types;			
				[self.navigationController presentModalViewController:image_picker animated:YES];			
								
				break;
			}
			case 2: {
				
				UIImage *image = [UIImage imageNamed:kTextureImage];				
				save_uiimage(kTextureImage, image);
				
				Image *tmp = mesh->texture;	
				mesh->texture = reload_texture(kTextureImage);	
				free_image(tmp);				
				
				config.front.type = kConfigMediaTypeDefault;
				config.front.value = kDummyValue;													

				break;
			}				
			default:
				break;
		}
	}
	
	if (indexPath.section == kConfigSectionBackground) {
		
		state = config.back;
		
		switch (indexPath.row) {
			case 1: {
								
				[self initImagePicker];
				
				image_picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
				[self.navigationController presentModalViewController:image_picker animated:YES];
								
				break;
			}
			case 2: {
				
				config.back.type = kConfigMediaTypeCamera;
				config.back.value = kDummyValue;				
				
				break;
			}
				
			default:
				break;
		}		
	}
	
	UITableViewCell *cell = nil;	
	
	if (state == nil) {
		NSLog(@"synchronizeCheckboxesForSection:%d, ConfigState == nil", indexPath.section);
		return;
	}

	if (indexPath.row == 0) {
		return;
	}
			
	state.prev = state.current;
	
	UITableView *table = (UITableView*)self.tableView;
	
	if (state.prev) {
		cell = [table cellForRowAtIndexPath:state.prev];
		if (cell) cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	state.current = indexPath;
	cell = [table cellForRowAtIndexPath:state.current];
	if (cell) cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)sliderGearsChanged:(id)sender {
	UISlider *slider = (UISlider*)sender;
	appCtx.gears = slider.value;	
	gearsCell.textLabel.text = [NSString stringWithFormat:@"gears: %d", appCtx.gears];
};

- (void)sliderAlphaChanged:(id)sender {
	UISlider *slider = (UISlider*)sender;
	appCtx.alpha = slider.value;	
	alphaCell.textLabel.text = [NSString stringWithFormat:@"alpha: %.2f", appCtx.alpha];	
};


-(void) resetCloth:(id)sender {
	return;
}

-(void) callTwitter:(id)sender {
	[[TwitterAgent defaultAgent] twit:@"Im playing with Curtain!!! #iphone #curtain" withLink:@"http://nullgravity.eu/apps/curtain" makeTiny:NO];
	return;
}

-(void) callEmail:(id)sender {
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;	
	[picker setSubject:@"iphone Curtain application feedback"];	
	[picker setToRecipients:[NSArray arrayWithObject:@"curtain@nullgravity.eu"]];
	
	[self presentModalViewController:picker animated:YES];
	
	return;
}

- (IBAction) done:(id)sender {
	
	config.gears = appCtx.gears;
	config.alpha = appCtx.alpha;	
	
	[config saveSettings];	
	[[NSNotificationCenter defaultCenter] postNotificationName:kConfigChangesDidFinishNotify object:config];
	
	[APP_DELEGATE switchToGL];
};

- (void) initImagePicker {
	
	if (image_picker == nil) {	
		image_picker = [[UIImagePickerController alloc] init];
		image_picker.delegate = self;
		image_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];	
	
	if (kConfigSectionFront == currentIndexPath.section) {
		if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {               
			UIImage* img = [info objectForKey:UIImagePickerControllerEditedImage];
			if (!img)
				img = [info objectForKey:UIImagePickerControllerOriginalImage];             
			
			resize_and_save_uiimage(img, kTextureImage, CGSizeMake(512, 512));	
			
			Image *tmp = mesh->texture;	
			mesh->texture = reload_texture(kTextureImage);	
			free_image(tmp);				
			
			config.front.type = kConfigMediaTypeImage;
			config.front.value = kDummyValue;						
		}
		
	} else if (kConfigSectionBackground == currentIndexPath.section) {	
		
		if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) { 
			
			UIImage* img = [info objectForKey:UIImagePickerControllerEditedImage];			
			if (!img)
				img = [info objectForKey:UIImagePickerControllerOriginalImage];             
			
			resize_and_save_uiimage(img, kBackgroundImage, CGSizeMake(320, 480));		
			
			config.back.type = kConfigMediaTypeImage;
			config.back.value = kDummyValue;
		}
	}
	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];	
	
	return;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	UITableViewCell *cell = nil;	
	ConfigState *state = nil;	
	
	if (kConfigSectionFront == currentIndexPath.section) {		
		state = config.back;
	}			
	if (kConfigSectionBackground == currentIndexPath.section) {		
		state = config.back;
	}		
	
	if (state == nil) {
		NSLog(@"synchronizeCheckboxesForSection:%d, ConfigState == nil", currentIndexPath.section);
		return;
	}
	
	
	
	UITableView *table = (UITableView*)self.view;
	
	if (state.current) {
		cell = [table cellForRowAtIndexPath:state.current];
		if (cell) cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	state.current = state.prev;
	
	if (state.prev) {
		cell = [table cellForRowAtIndexPath:state.prev];
		if (cell) cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];		
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissModalViewControllerAnimated:YES];
	
	if (result == MFMailComposeResultSent) {		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Thank you very much for feedback" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	[image_picker release];
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[image_picker dealloc];
	
    [super dealloc];
}


@end

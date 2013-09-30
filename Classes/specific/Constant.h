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
//  const.h
//  cloth_2
//
//  Created by 0xc01df00d on 10-06-03.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "curtainAppDelegate.h"

#define APP_DELEGATE (curtainAppDelegate*)[[UIApplication sharedApplication] delegate]

#ifdef __cplusplus
#define MP_EXTERN	extern "C" __attribute__((visibility ("default")))
#else
#define MP_EXTERN	extern __attribute__((visibility ("default")))
#endif

MP_EXTERN NSString * const kConfigSettingsUser;

MP_EXTERN NSString * const kConfigKeyMediaType;
MP_EXTERN NSString * const kConfigKeyMediaValue;

MP_EXTERN NSString * const kConfigFront;
MP_EXTERN NSString * const kConfigBack;
MP_EXTERN NSString * const kConfigGears;
MP_EXTERN NSString * const kConfigAlpha;

MP_EXTERN NSInteger const kConfigSectionFront;
MP_EXTERN NSInteger const kConfigSectionBackground;
MP_EXTERN NSInteger const kConfigSectionGeneral;

MP_EXTERN NSInteger const kConfigMediaTypeImage;
MP_EXTERN NSInteger const kConfigMediaTypeCamera;
MP_EXTERN NSInteger const kConfigMediaTypeDefault;
MP_EXTERN NSInteger const kConfigMediaTypeGears;


MP_EXTERN NSInteger const kDummyValue;

MP_EXTERN NSString * const kConfigSectionItems;
MP_EXTERN NSString * const kConfigSectionName;
MP_EXTERN NSString * const kConfigSectionId;
MP_EXTERN NSString * const kConfigSectionCurrentIndexPath;
MP_EXTERN NSString * const kConfigSectionPrevIndexPath;

MP_EXTERN NSString * const kBackgroundImage;
MP_EXTERN NSString * const kTextureImage;

/*
 * notyfikacje
 */

MP_EXTERN NSString * const kConfigChangesDidFinishNotify;




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
//  Constant.m
//  cloth_2
//
//  Created by 0xc01df00d on 10-06-08.
//  Copyright 2010 NullGravity. All rights reserved.
//

NSString * const kConfigSettingsUser		= @"cloth.settings.user";

NSString * const kConfigKeyMediaType		= @"cloth.settings.type";
NSString * const kConfigKeyMediaValue		= @"cloth.settings.value";

NSString * const kConfigFront				= @"cloth.settings.front";
NSString * const kConfigBack				= @"cloth.settings.back";
NSString * const kConfigGears				= @"cloth.settings.gears";
NSString * const kConfigAlpha				= @"cloth.settings.alpha";

NSInteger const kConfigSectionFront			= 0;
NSInteger const kConfigSectionBackground	= 1;
NSInteger const kConfigSectionGeneral		= 2;

NSInteger const kConfigMediaTypeDefault		= 10;
NSInteger const kConfigMediaTypeGears		= 0;
NSInteger const kConfigMediaTypeImage		= 1;
NSInteger const kConfigMediaTypeCamera		= 2;

NSInteger const kDummyValue = 0;

NSString * const kConfigSectionItems = @"CONFIG_SECTION_ITEMS";
NSString * const kConfigSectionName = @"CONFIG_SECTION_NAME";
NSString * const kConfigSectionId = @"CONFIG_SECTION_INDEX";
NSString * const kConfigSectionCurrentIndexPath = @"CONFIG_SECTION_CURRENT_INDEX_PATH";
NSString * const kConfigSectionPrevIndexPath = @"CONFIG_SECTION_PREV_INDEX_PATH";


NSString * const kBackgroundImage = @"back.png";
NSString * const kTextureImage = @"texture.png";

NSString * const kConfigChangesDidFinishNotify = @"CONFIG_CHANGES_DID_FINISH_NOTIFY";

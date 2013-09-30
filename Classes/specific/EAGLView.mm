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



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"

#include "curtain.h"
#include "CoreFoundation/CFDictionary.h"

#include "system.h"
#include "resources.h"

#import "TouchInfo.h"

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end

@implementation EAGLView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;


+ (Class)layerClass {
	return [CAEAGLLayer class];
}

- (id)initWithCoder:(NSCoder*)coder {
	if (self = [super initWithCoder:coder]) {	
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
		   [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context]) {
			[self release];
			return nil;
		}
		
		[ self setMultipleTouchEnabled:YES ];	
		
		animationInterval = 1.0 / 60.0;
				
		touchBeginPoints = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, 0, 0);
	}
	return self;
}

- (void)drawView {
	
	if (appCtx.backgroundTime == YES) return;
	
	curtainRender();

	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)layoutSubviews {
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self drawView];
}

- (BOOL)createFramebuffer {
	
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	glGenRenderbuffersOES(1, &depthRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	
	appCtx.window.size = CGSizeMake(backingWidth, backingHeight);
	appCtx.backgroundTime = NO;
	curtainLoading();
	
	return YES;
}

-(void)copyTouchInfo {
		
}

static void update_touch_info (const void* key, const void* value, void* context) {
	
	TouchInfo *ti = (TouchInfo *)value;
		
	Vertex3d *v = &mesh->vertices[ti.index];
	
	int x = [ti current].x * CLOTH_WIDTH_FACTOR;
	int y = [ti current].y * CLOTH_HEIGHT_FACTOR;
	
	v->vector[X] = (x - (CLOTH_WIDTH * 0.5)) * GAP_X;
	v->vector[Y] = (y - (CLOTH_HEIGHT * 0.5)) * -GAP_Y;
	v->vector[Z] = 0.15;
	
	mesh->vertices[ti.index].step		 = 0.001;
		
	mesh->touch.vindex[mesh->touch.size] = ti.index;
	mesh->touch.size++;
}

static void update_move_touch_info (const void* key, const void* value, void* context) {
	
}

-(int) findIndex:(float*)pt {
		
	int index = 0;
	
	float minDist = 0.01;
	float dist;
	int   closest = -1;
	
	for (int x = 0; x < 21; x++) {
		for (int y = 0; y < 21; y++) {
						
			index = x + y * 21;			
			float *v = &mesh->vertices[index].current[0];
			
			dist = (pt[0] - v[0]) * (pt[0] - v[0]) + (pt[1] - v[1]) * (pt[1] - v[1]);
			if (dist < minDist) {
				minDist = dist;
				closest = index;
			}
		}
	}
	
	return closest;
}

BOOL dragForSettings = NO;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{			
    if ([touches count] > 0) {
		
		mesh->track_tearing = 1;
		
        for (UITouch *touch in touches) {
		
			CGPoint point = [touch locationInView:self];
			if (point.x < 90 && point.y < 50) {
				dragForSettings = YES;
				return;
			}
			
			Boolean exist = CFDictionaryContainsKey (touchBeginPoints, touch);
			
			if (!exist) {
				
				CGPoint current = [touch locationInView:self];
				int x = current.x * CLOTH_WIDTH_FACTOR;
				int y = current.y * CLOTH_HEIGHT_FACTOR;
				
				float point[3] = { (x - CLOTH_WIDTH*0.5)  *  GAP_X, (y - CLOTH_HEIGHT*0.5) * -GAP_Y, 1 };				
				int index = [self findIndex:point];
				
				if (index >= 441 || index <= 0) {
					continue;
				}				
				
				TouchInfo *ti = [TouchInfo alloc];				
				ti.current = [touch locationInView:self];
				ti.index = index; 
								 
				CFDictionaryAddValue(touchBeginPoints, touch, ti);				
							
				if (ti.index < 0) ti.index = 0;
				if (ti.index > CLOTH_SIZE) ti.index = CLOTH_SIZE;
			}
        }
		
		mesh->touch.size = 0;
		CFDictionaryApplyFunction(touchBeginPoints, update_touch_info, NULL);		
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch;
	
	for( touch in touches ) {
		//printf("move, szukam key 0x%x\n", touch);
		Boolean exist = CFDictionaryContainsKey (touchBeginPoints, touch);
		if (exist) {			
			//printf("move, modyfikuje key 0x%x\n", touch);
			TouchInfo *ti = (TouchInfo*)CFDictionaryGetValue(touchBeginPoints, touch);
			if (ti == NULL) {
				ti = [TouchInfo alloc];
				CFDictionarySetValue(touchBeginPoints, touch, ti);				
			}
			
			ti.current = [touch locationInView:self];
			
			//printf("move, przesuniecie (x,y):(%f, %f)\n", ti.current.x * CLOTH_WIDTH_FACTOR, ti.current.y * CLOTH_HEIGHT_FACTOR);
		}
	}
	
	mesh->touch.size = 0;
	CFDictionaryApplyFunction(touchBeginPoints, update_touch_info, NULL);	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch;
	
	if ([touches count] == 0) {
		mesh->track_tearing = 0;
	}
	
	for( touch in touches ) {
		if (dragForSettings == YES) {
			
			dragForSettings = NO;
			CGPoint point = [touch locationInView:self];		
			
			if (point.x > 270 && point.y < 50) {
				[[UIApplication sharedApplication].delegate switchToConfig];				
				
				return;
			}	
		}
		
		Boolean exist = CFDictionaryContainsKey (touchBeginPoints, touch);		
		if (exist) {
			TouchInfo *ti = (TouchInfo*)CFDictionaryGetValue(touchBeginPoints, touch);	
			[ti dealloc];
		}
		CFDictionaryRemoveValue(touchBeginPoints, touch);
	}	
	
	mesh->touch.size = 0;
	CFDictionaryApplyFunction(touchBeginPoints, update_touch_info, NULL);
}

- (void)destroyFramebuffer {
	
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}

- (void)startAnimation {
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
	self.animationTimer = nil;
}

- (void)setAnimationTimer:(NSTimer *)newTimer {
	[animationTimer invalidate];
	animationTimer = newTimer;
}

- (void)setAnimationInterval:(NSTimeInterval)interval {
	
	animationInterval = interval;
	if (animationTimer) {
		[self stopAnimation];
		[self startAnimation];
	}
}

- (void)dealloc {
	
	[self stopAnimation];
	
	if ([EAGLContext currentContext] == context) {
		[EAGLContext setCurrentContext:nil];
	}
	
	[context release];	
	[super dealloc];
}

@end

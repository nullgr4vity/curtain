//
//  Microphone.h
//  curtain
//
//  Created by 0xc01df00d on 10-06-24.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface Microphone : NSObject {
	AVAudioRecorder *recorder;
	NSTimer *levelTimer;	
	double lowPassResults;	
}

+ (Microphone *) instance;

- (id) init;
- (void) startListening;
- (void) stopListening;
- (void) levelTimerCallback:(NSTimer *)timer;

@property (readonly) double lowPassResults;

@end

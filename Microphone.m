//
//  Microphone.m
//  curtain
//
//  Created by 0xc01df00d on 10-06-24.
//  Copyright 2010 NullGravity. All rights reserved.
//

#import "Microphone.h"


@implementation Microphone

@synthesize lowPassResults;

static Microphone *micSingleInstance = nil;

+ (Microphone *)instance {
	@synchronized(self) {
		if (micSingleInstance == nil)
			micSingleInstance = [[self alloc] init];
	}
	
	return micSingleInstance;
}

- (id) init {

	recorder = nil;
	levelTimer = nil;
	lowPassResults = 0.0;
	
	return self;
}

-(void) startListening {
	
	if ([[AVAudioSession sharedInstance] inputIsAvailable]) {	
		NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
		
		NSLog(@"Microphone startListening");
		
		NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
								  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
								  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
								  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
								  nil];
		
		NSError *error;
		
		recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
		
		if (recorder) {
			[recorder prepareToRecord];
			recorder.meteringEnabled = YES;
			[recorder record];
			
			levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 
														  target: self 
														selector: @selector(levelTimerCallback:) 
														userInfo: nil 
														 repeats: YES];
			
		} else
			NSLog(@"Microphone start, error: %@", [error description]);	
	} else
		NSLog(@"Microphone, inputIsAvailable == NO");	
}


-(void) stopListening {
	
	NSLog(@"Microphone stopListening");	
	
	if (levelTimer != nil) {
		[levelTimer release];	
	}
	
	if (recorder != nil) {
		[recorder release];
	}
}

- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];	
	
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;	
	
	//NSLog(@"Microphone timer, average input: %f peak input: %f low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);
};

@end

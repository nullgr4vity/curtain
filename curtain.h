

#ifndef __CLOTH_2_H
#define __CLOTH_2_H


typedef struct {
	
	CGSize size;
	
} EngineWindow;

typedef struct {
	
	EngineWindow window;
	BOOL backgroundTime;
	
	NSInteger	gears;
	float		alpha;
	
} ApplicationContext;


extern ApplicationContext appCtx;

void curtainLoading( void );

void curtainRender( void );

void curtainShutdown( void );

#endif

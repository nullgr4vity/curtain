

#include "curtain.h"

#include "mesh.h"
#include "base_renderer.h"
#include "resources.h"
#include "system.h"

#include "glu.h"

#include "image.h"

#include "Constant.h"

#include "Microphone.h"

#include "Sprite.h"

#include "Config.h"

ApplicationContext appCtx;
Image *config_texture = 0x0;

BOOL loaded = NO;

NSMutableArray *sprites = nil;
Sprite *frame = nil;

NSDate *startTime = nil;

void setup_opengl() {
		
	glEnableClientState(GL_VERTEX_ARRAY);	
	glEnable(GL_TEXTURE_2D);	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
	
	glCullFace(GL_BACK);
	glDisable(GL_CULL_FACE);
	
	glEnable(GL_DEPTH_TEST);
    glDepthMask(GL_TRUE);
	
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);		
}

void setup_projection(GLfloat fov = 60.0, GLfloat aspect = 480.0/320.0, GLfloat zNear = 0.1, GLfloat zFar = 1000.0) {
		
	glMatrixMode (GL_PROJECTION);
	glLoadIdentity ();
	
    GLfloat size = zNear * tanf(DEGREES_TO_RADIANS(fov) / 2.0);
    glFrustumf(-size, size, -size / (320.0 / 480.0), size / (320.0 / 480.0), zNear, zFar);
	
    glViewport(0, 0, 320, 480);
    
	GLfloat eye[3] = {0, 0, .5152};
	GLfloat center[3] = {0, 0, 0};
	GLfloat up[3] = {0, 1, 0};	
	
	gluLookAt(eye[0], eye[1], eye[2], center[0], center[1], center[2], up[0], up[1], up[2]);
}

void curtainLoading( void ) {	
	
	appCtx.gears = [[Config instance] gears];
	appCtx.alpha = [[Config instance] alpha];
	
	NSLog(@"appCtx.gears : %d", appCtx.gears);
	
	mesh = mesh_init_model();
		
	Image *tmp = mesh->texture;	
	mesh->texture = reload_texture(kTextureImage);	
	free_image(tmp);
		
	setup_opengl();
		
	setup_projection();
		
	[[Microphone instance] startListening];
	
	// sprity
	sprites = [[NSMutableArray alloc] init];
	
	Sprite *s = nil;
	
	int i = 1;
	for (int ix=0; ix<6; ix++) {
		for (int iy=0; iy<8; iy++) {		
			NSString *tex_name = [NSString stringWithFormat:@"gear_%d.png", (rand() % 5) + 1];		
			s = [Sprite spriteWithFile:tex_name];
			
			float x = -1.5 + (ix * 0.5) + (rand() / RAND_MAX);			
			float y = -2.0 + (iy * 0.5) + (rand() / RAND_MAX);
			float z = -0.75 + ( i++ * 0.002);
			
			//NSLog(@"x: %f, y: %f, z: %f", x, y, z);
			[s setTranslation:x :y :z ];
			
			float speed = 1 + (arc4random() % 100) / 100.0; 
			
			[s setRotation:speed];	
			[sprites addObject:s];	
		}
	}
	
	for (i=0;i<[sprites count];i++) {
		NSInteger randIndex = random() % [sprites count];
		[sprites exchangeObjectAtIndex:i withObjectAtIndex:randIndex];
	}

	for (i=0;i<[sprites count];i++) {
		Sprite *s = [sprites objectAtIndex:i];
		float *t = [s getTranslation];
		float z = -0.75 + (i * 0.002);
		[s setTranslation:t[0] :t[1] :z];
	}
	
	
	frame = [Sprite spriteWithFile:@"frame.png"];
	[frame setTranslation:0 :0 :-0.5];
	[frame setScale:1.9 :2.8 :1];
	[frame setRotation:0];
	[frame updateTextureCoords:235.0/512.0 :290.0/512.0];	
	
	loaded = YES;
}

void draw_config_button() {
			
	const GLfloat squareVertices[] = {
		-10.0f, -10.0f,
		10.0f,  -10.0f,
		-10.0f,  10.0f,
		10.0f,   10.0f,
	};
	
	const GLfloat uvs[] = {
		0,0,
		0,1,
		1,0,
		1,1
	};
		
	glTranslatef( appCtx.window.size.width - 10, appCtx.window.size.height - 10, 0.0f );	
	
	glColor4f(1, 1, 1, 1);
	
	glBindTexture(GL_TEXTURE_2D, config_texture->tid);
	glTexCoordPointer(2, GL_FLOAT, 0, uvs);		
	
	glVertexPointer( 2, GL_FLOAT, 0, squareVertices );	
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);	
		
	glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
}

void draw_cloth() {
	
	cloth_process(mesh);
		
	GLuint vertices_copied = 0;
	
	if (mesh->use_texture) {
		vertices_copied = cloth_copy_vertices(mesh);
	} else {
		vertices_copied = cloth_copy_vertices_by_constraints(mesh);
	}
	
	if (mesh->use_texture) {	
		glBindTexture(GL_TEXTURE_2D, mesh->texture->tid);
		glTexCoordPointer(2, GL_FLOAT, 0, mesh->uvs);		
	}

	glEnableClientState(GL_VERTEX_ARRAY);	
	glVertexPointer(3, GL_FLOAT, 0, mesh->verts);
	
	if (mesh->use_texture) {
		glDrawArrays(GL_TRIANGLES, 0, vertices_copied);
	} else {
		glDrawArrays(GL_LINES, 0, vertices_copied);		
	}
}


void switch_back_to_frustrum()
{
    glEnable(GL_DEPTH_TEST);
    
	glMatrixMode(GL_PROJECTION);			
	glPopMatrix();				
	
	glMatrixMode(GL_MODELVIEW);	
	glLoadIdentity();
}

void switch_to_ortho()
{
    glDisable(GL_DEPTH_TEST);
    
	glMatrixMode(GL_PROJECTION);			
	glPushMatrix();							
	glLoadIdentity();						
	glOrthof(0, appCtx.window.size.width, 0, appCtx.window.size.height, -1, 1);		
	
	glMatrixMode(GL_MODELVIEW);										
    glLoadIdentity();		
}

CFTimeInterval startFrameTime = CFAbsoluteTimeGetCurrent();

int frameNumber = 0;

void curtainRender( void ) {	
		
	if (loaded == NO) return;
		
	CFTimeInterval thisFrameTime = CFAbsoluteTimeGetCurrent();
	float elapsed = thisFrameTime - startFrameTime;
	
	frameNumber += 1;
	
	glClearColor(0, 0, 0, 0);
	
	glClear( GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT );

	glColor4f(1, 1, 1, 1);		

	glEnable(GL_BLEND);	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDisable(GL_COLOR_MATERIAL);
	
	if (appCtx.gears > 0) {	
		Sprite *sprite = nil;
		for (int i=0; i< appCtx.gears; i++) {		
			glMatrixMode(GL_MODELVIEW);
			glLoadIdentity();
			
			sprite = [sprites objectAtIndex:i];
			
			float *t = [sprite getTranslation];			
			glTranslatef(t[0], t[1], t[2]);									
			
			float a = [sprite getRotation];
			glRotatef(a * frameNumber, 0, 0, 1);

			float *s = [sprite getScale];		
			glTranslatef(-0.5 * s[0], -0.5 * s[1], t[2]);		
			glScalef(s[0], s[1], s[2]);
					
			[sprite updateTransform:elapsed];
			[sprite draw];	
		}

		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		float *t = [frame getTranslation];			
		float *s = [frame getScale];	
		glTranslatef(t[0], t[1], t[2]);									
		glTranslatef(-0.5 * s[0], -0.5 * s[1], t[2]);		
		glScalef(s[0], s[1], s[2]);
		
		[frame updateTransform:elapsed];
		[frame draw];	

	}

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glColor4f(1, 1, 1, appCtx.alpha);		
	
	glEnable(GL_BLEND);	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	draw_cloth(); 
}


void curtainShutdown( void ) {
	
	[[Microphone instance] stopListening];	
	
	[sprites removeAllObjects];
	[sprites release];
	
	[frame release];
	
	mesh_free(mesh);
	
	free_image(config_texture);	
			   	
	printf("\nCurtain: shutdown...\n" );
}
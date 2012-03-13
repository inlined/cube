#if 0
#include "GraphicsLib.h"
#include "trackball.h"
#include "animation.h"
#include "Cube.h"
#include <string.h>
#include <stdlib.h>


// initial model angle
static float dragquat[4] = {0.0, 0.0, 0.0, 1.0};
static int isDragging = 0;

extern CUBE theCube;

/* vars for draging */
static int xInit = 0;
static int yInit = 0;
static int xLast = 0;
static int yLast = 0;

float trackRotAxis[3] = {0, 0, 0};
float trackRotAngle = 0;

/* vars for rotations */
extern int isRotatingVert;
extern int isRotatingHoriz;

// initial viewer position
static GLfloat modelTrans[] = {0.0, 0.0, -5.0};

void normCrossProd(float v1[3], float v2[3], float out[3]) {
   // cross v1[] and v2[] and return the result in out[]
   // from OpenGL Programming Guide, p. 58
   out[0] = v1[1]*v2[2] - v1[2]*v2[1];
   out[1] = v1[2]*v2[0] - v1[0]*v2[2];
   out[2] = v1[0]*v2[1] - v1[1]*v2[0];
   normalize(out);
}

float dot(float v1[3], float v2[3]) {
    return v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2];
}

void processHits(GLint hits, GLuint buffer[])
{
    int i, j;
    GLuint names, *ptr;
    GLfloat closestDistance = 1.0/0.0;
    GLfloat distance;
    GLuint ndxClosest = -1;
    float quat[4];
    float identity[4];
    float axis[3];
    float phi = 3.14159 / 2;
    memset(axis, 0, sizeof(axis));
    memset(identity, 0, sizeof(float) * 3);
    identity[3] = 1;
    
    if( hits == 0 )
        return;
    
    ptr = (GLuint *) buffer;
    for(i=0; i<hits; i++) {
        names = *ptr;
        ptr++;
        distance = (float) *ptr/0x7fffffff;
        ptr++;
        ptr++;
        if( distance < closestDistance ) {
            closestDistance = distance;
            ndxClosest = *ptr;
        }
        for (j=0; j<(int)names; j++) {
            ptr++;
        }
    }
    if( ndxClosest == -1 ) { 
        fprintf(stderr, "error calculating closest object\n");
    } else {
        switch(ndxClosest) {
        /* TOP: */
        case TOP_LEFT:
            axis[0] = 1; /* rotate about the x axis */
            phi = -phi;
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_LEFT_VERT_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoVertTwistDown,
                           (void *)0
                           );
            break;
        case TOP_MID:
            axis[0] = 1; /* rotate about the x axis */
            phi = -phi;
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_MID_VERT_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoVertTwistDown,
                           (void *)1
                           );
            break;
        case TOP_RIGHT:
            axis[0] = 1; /* rotate about the x axis */
            phi = -phi;
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_RIGHT_VERT_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoVertTwistDown,
                           (void *)2
                           );
            break;
        case BOTTOM_LEFT:
            axis[0] = 1; /* rotate about the x axis */
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_LEFT_VERT_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoVertTwistUp,
                           (void *)0
                           );
            break;
        case BOTTOM_MID:
            axis[0] = 1; /* rotate about the x axis */
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_MID_VERT_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoVertTwistUp,
                           (void *)1
                           );
            break;
        case BOTTOM_RIGHT:
            axis[0] = 1; /* rotate about the x axis */
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_RIGHT_VERT_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoVertTwistUp,
                           (void *)2
                           );
            break;
        case RIGHT_TOP:
            axis[1] = 1; /* rotate about the y axis */
            phi = -phi;
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_TOP_HORIZ_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoHorizTwistRight,
                           (void *)0
                           );
            break;
        case RIGHT_MID:
            axis[1] = 1; /* rotate about the y axis */
            phi = -phi;
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_MID_HORIZ_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoHorizTwistRight,
                           (void *)1
                           );            break;
        case RIGHT_BOTTOM:
            axis[1] = 1; /* rotate about the y axis */
            phi = -phi;
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_BOTTOM_HORIZ_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoHorizTwistRight,
                           (void *)2
                           );
            break;
        case LEFT_TOP:
            axis[1] = 1; /* rotate about the y axis */
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_TOP_HORIZ_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoHorizTwistLeft,
                           (void *)0
                           );
            break;
        case LEFT_MID:
            axis[1] = 1; /* rotate about the y axis */
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_MID_HORIZ_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoHorizTwistLeft,
                           (void *)1
                           );
            break;
        case LEFT_BOTTOM:
            axis[1] = 1; /* rotate about the y axis */
            axis_to_quat(axis, phi, quat);
            StartAnimation(
                           ANIM_BOTTOM_HORIZ_TWIST,
                           identity,
                           quat,
                           1000,
                           NULL,
                           (void (*)(void *))DoHorizTwistLeft,
                           (void *)2
                           );
            break;
        default:
            fprintf(stderr, "Unhandled selection\n");
        }
    }
}

//---------------------------------------------------------
//   Set up the view

void setUpView() {
   // this code initializes the viewing transform
   glLoadIdentity();
   
   // moves viewer along coordinate axes
//   gluLookAt(0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
   
   // move the view back some relative to viewer[] position
   glTranslatef(0.0f,0.0f, -8.0f);   

   return;
}

void RotateTrackBall() {
    GLfloat m[4][4];
    GLfloat transform[4];
 
    GetAnimationQuat(transform, ANIM_DRAG_DROP | ANIM_ROTATE);
    add_quats(transform, dragquat, transform);

    build_rotmatrix(m, transform);
    glMultMatrixf(&m[0][0]);
}

//----------------------------------------------------------
//  Set up model transform

void setUpModelTransform() {
   
    // moves model along coordinate axes
    glTranslatef(modelTrans[0], modelTrans[1], modelTrans[2]);
    
}

//----------------------------------------------------------
//  Set up the light

void setUpLight() {
   // set up the light sources for the scene
   // a directional light source from directly behind
   GLfloat lightDir[] = {0.0, 0.0, 5.0, 0.0};
   GLfloat diffuseComp[] = {1.0, 1.0, 1.0, 1.0};
   
   glEnable(GL_LIGHTING);
   glEnable(GL_LIGHT0);
   
   glLightfv(GL_LIGHT0, GL_POSITION, lightDir);
   glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuseComp);
   
   return;
}

//-----------------------------------------------------------
//  Callback functions
void setUpProjection(int w, int h) {
    glViewport(0,0,w,h);
    
    if (w < h) {
        glFrustum(-2.0, 2.0, -2.0*(GLfloat) h / (GLfloat) w,
                  2.0*(GLfloat) h / (GLfloat) w, 2.0, 30.0);
    }
    else {
        glFrustum(-2.0, 2.0, -2.0*(GLfloat) w / (GLfloat) h,
                  2.0*(GLfloat) w / (GLfloat) h, 2.0, 30.0);
    }
    
    glMatrixMode(GL_MODELVIEW);
    
    return;
}

void reshapeCallback(int w, int h) {
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   setUpProjection(w, h);
}

void mouseCallback(int button, int state, int x, int y) {
   if (button == GLUT_LEFT_BUTTON && state == GLUT_DOWN) {
       isDragging = 1;
       xInit = xLast = x;
       yInit = yLast = y;
//       GetAnimationQuat(dragquat, ANIM_DRAG_DROP);
        #define BUFSIZE 512
       GLuint selectBuf[BUFSIZE];
       GLint hits;
       GLint viewport[4];
       GLint w, h;
       
       glGetIntegerv(GL_VIEWPORT, viewport);
       
       glSelectBuffer(BUFSIZE, selectBuf);
       (void) glRenderMode(GL_SELECT);
       
       glInitNames();
       glPushName(0);
       
       glPushMatrix();
       // now "render" everything for selection
       glMatrixMode(GL_PROJECTION);
       glLoadIdentity();
       // this is the only transform difference in the hierarchy
       gluPickMatrix((GLdouble) x, (GLdouble) (viewport[3] - y),
                     5.0, 5.0, viewport);
       w = viewport[2];
       h = viewport[3];
       setUpProjection(w, h);
       
       // the rest is the same as in display(), except the 
       // mode flag is different (GL_SELECT)
       glMatrixMode(GL_MODELVIEW);
       glLoadIdentity();
       setUpView();
       setUpModelTransform();
       DrawArrows(10.0, 5.0, GL_SELECT);
       glPopMatrix();
       
       glFlush();
       
       hits = glRenderMode(GL_RENDER);
       processHits(hits,selectBuf);
       
       // re-render everything again for display
       glMatrixMode(GL_PROJECTION);
       glLoadIdentity();
       setUpProjection(w, h);       
       
   } else if (button == GLUT_LEFT_BUTTON && state == GLUT_UP) {
       isDragging = 0;
       if( abs(xInit - x) > 5 || abs(yInit - y) > 5 ) {
            float identity[4] = {0, 0, 0, 1};
            float quatInProgress[4];
            GetAnimationQuat(quatInProgress, ANIM_DRAG_DROP);
            add_quats(dragquat, quatInProgress, dragquat);

            StartAnimation(
                ANIM_DRAG_DROP, 
                dragquat, 
                identity, 
                1000, 
                &isDragging,
                NULL,
                NULL
            );
       }
       memset(dragquat, 0, sizeof(float) * 3);
       dragquat[3] = 1;
       glutPostRedisplay();
   }
} 

void dragCallback(int x, int y) {
    float lastquat[4];
	GLint vp[4];
	
	if (x == xLast && y == yLast) return;
        
	if (!isDragging) return;
    
	glGetIntegerv(GL_VIEWPORT, vp);
    
    trackball(lastquat,
              (2.0*xLast - vp[2]) / vp[2],
              (vp[3] - 2.0*yLast) / vp[3],
              (2.0*x - vp[2]) / vp[2],
              (vp[3] - 2.0*y) / vp[3]
              );
    
    add_quats(lastquat, dragquat, dragquat);
    
	xLast = x;
	yLast = y;
	glutPostRedisplay();
}

void keyCallback(int key, int x, int y) {
    float quat[4];
    float identity[4];
    float axis[3];
    float phi = 3.14159 / 2;
    memset(axis, 0, sizeof(axis));
    memset(identity, 0, sizeof(float) * 3);
    identity[3] = 1;
    
    if( key == GLUT_KEY_LEFT ) {
        axis[1] = 1; /* rotate about the y axis */
        axis_to_quat(axis, phi, quat);
        StartAnimation(
            ANIM_ROTATE,
            identity,
            quat,
            1000,
            NULL,
            (void (*)(void *))RotateCubeLeft,
            theCube
            );
    } else if( key == GLUT_KEY_RIGHT ) {
        axis[1] = 1; /* rotate about the y axis */
        phi = -phi;
        axis_to_quat(axis, phi, quat);
        StartAnimation(
           ANIM_ROTATE,
           identity,
           quat,
           1000,
           NULL,
           (void (*)(void *))RotateCubeRight,
           theCube
           );
    } else if( key == GLUT_KEY_UP ) {
        axis[0] = 1; /* rotate about the left axis */
        axis_to_quat(axis, phi, quat);
        StartAnimation(
           ANIM_ROTATE,
           identity,
           quat,
           1000,
           NULL,
           (void (*)(void *))RotateCubeUp,
           theCube
           );
        //RotateCubeUp(theCube);
    } else if( key == GLUT_KEY_DOWN ) {
        axis[0] = 1; /* rotate about the left axis */
        phi = -phi;
        axis_to_quat(axis, phi, quat);
        StartAnimation(
           ANIM_ROTATE,
           identity,
           quat,
           1000,
           NULL,
           (void (*)(void *))RotateCubeDown,
           theCube
           );
   }   

    glutPostRedisplay();
}

//---------------------------------------------------------
//  Utility functions

void normalize(float v[3]) {
   // normalize v[] and return the result in v[]
   // from OpenGL Programming Guide, p. 58
   GLfloat d = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
   if (d == 0.0) {
      printf("zero length vector");
      return;
   }
   v[0] = v[0]/d; v[1] = v[1]/d; v[2] = v[2]/d;
}

void display() {
    static int first_time = 1;
    if( first_time ) {
        first_time = 0;
        Randomize(100);
    }
    // this code executes whenever the window is redrawn (when opened,
    //   moved, resized, etc.
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // set the viewing transform
    setUpView();
    
    // set up light source
    setUpLight();
    
    // start drawing objects
    setUpModelTransform();
    DrawCube(theCube, 10.0);
    DrawArrows(10.0, 5.0, GL_RENDER);
    
    glutSwapBuffers();
}
#endif
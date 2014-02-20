#pragma once

#include "ofMain.h"

#import "ofxNodeKit.h"
#import <CoreMotion/CoreMotion.h>

class nodeTest : public ofxiOSApp {
    
public:
    
    // OF CORE
    
    void setup();
    void update();
    void draw();
    void exit();
	
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    // EXAMPLE VARS

    float rot;
    float spin;
    int dir;
    
    NSTimeInterval lastTime;
    
    ofxSceneNode *scene;
    ofxNode *pivot;
    
    
    // CORE MOTION STUFF
    
    void setupCM();
    
    ofMatrix3x3 attitude;
    ofMatrix3x3 lastAttitude;
    ofMatrix3x3 normalized;
    void correctNormalization();
    
    float aspectRatio;
    
    void logSensorOrientation();
    void logAttitude();
    void logMatrix3x3(ofMatrix3x3 matrix);
    void logMatrix4x4(ofMatrix4x4 matrix);
    void log2Matrices3x3(ofMatrix3x3 m1, ofMatrix3x3 m2);
    ofMatrix3x3 getInverse(ofMatrix3x3 x);
    ofMatrix3x3 multMatrices(ofMatrix3x3 m1, ofMatrix3x3 m2);
    
    UIPinchGestureRecognizer *pinchGesture;
    CMMotionManager *motionManager;

    
};



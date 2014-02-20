#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#import "ofxNodeKit.h"

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
    
};



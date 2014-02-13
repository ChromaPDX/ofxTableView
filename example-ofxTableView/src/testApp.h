#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxTableView.h"

class testApp : public ofxiOSApp, ofxTableViewDelegate{
    
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
    
    ofxTableViewController *vc;
    ofxTableView *tbv;
    ofxTableView *modalTable;
    
    float rot;
    float spin;
    int dir;
    
    // TABLE VIEW DELEGATE
    
    void cellWasSelected(ofxTableViewCell *cell);
    
};



#ifndef OFXSCROLLVIEWCONTROLLER_H_INCLUDED
#define OFXSCROLLVIEWCONTROLLER_H_INCLUDED

//--------------------------------------------------------------
#include "ofMain.h"
#include "ofxMultiTouch.h"

class ofxTableView;


class    ofxTableViewController : public ofxMultiTouchListener
{
    //Handles overall control of the User interface.
    
private:
    //VARIABLES:--------------------------------------------------
    bool    isHidden;
    int     hideKey;
    bool    keysWhileHidden;
    bool    isTypingBlocked;
    
    
public:
    ofxTableViewController();                           //constructor
    ~ ofxTableViewController();                          //destructor
    void             initialize();          //initialize objects.
    
    //METHODS:--------------------------------------------------------
    
    // bool            update(int idNum);
    void            draw(int x, int y);
    
    vector          <ofxTableView*> tableViews;
    ofxTableView* addTableView(int x,int y,int w, int h);
    
    void update();
    
    void            draw();
    
    void touchDown(float x, float y, int touchId);
    void touchMoved(float x, float y, int touchId);
    void touchUp(float x, float y, int touchId);
    void touchDoubleTap(float x, float y, int touchId);
    
    void            hide();
    void            unHide();
    void            setHideKey(int key);
    
    
    bool             isSafeToType();
    void             disableKeys();
    void             enableKeys();
    bool             isGuiHidden();
    
    
};



#endif // OFXSCROLLVIEWCONTROLLER_H_INCLUDED

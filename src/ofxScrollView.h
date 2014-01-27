#ifndef  ofxScrollView_H_INCLUDED
#define  ofxScrollView_H_INCLUDED

#include "ofMain.h"

#define DEFAULT_FONT_STRING "ofxTableViewDefault.ttf"
#define DEFAULT_FONT_SIZE 16

typedef enum ScrollPhase {
    ScrollPhaseNil,
    ScrollPhaseBegan,
    ScrollPhaseRecognized,
    ScrollPhaseBeginFail,
    ScrollPhaseFailed,
    ScrollPhaseEnded,
    ScrollPhaseRestitution
} ScrollPhase;

class    ofxScrollView
{
    // BASE CLASS
    
protected:
    
    ofRectangle frame;
    
    int             verticalPadding;
    int             horizontalPadding;
    
    int             state;
    
    // Touch Handliing

    bool fdirty = true;
    bool dirty = true;
    bool cdirty = true;
    
    int contentSize;
    // SCROLLING INTERNAL VARIABLES
    
    int restitution = 0;
    int easeIn = 0;
    bool easeOut = false;
    
    int xOrigin = 0;
    int yOrigin = 0;
    
    float scrollVel = 0.0f;
    float counterVel = 0.0f;
    float drag = 1.1f;
    
    int scrollPosition = 0;
    
    ScrollPhase scrollPhase;
    
    // RASTER
    
    ofFbo           raster;


    
    ofxScrollView * _parent;
    vector<ofxScrollView *> children;
    
    bool            highlighted;
    
public:
    ofxScrollView();                           //constructor
    ~ ofxScrollView();                          //destructor
    
    //METHODS:--------------------------------------------------------
    
    // METHODS TO BE CALLED BY SUBCLASSES
    
    void                    initWithParent(ofxScrollView *parent, ofRectangle frame);
    void                    addChild(ofxScrollView *child);
    
    void                    update();
    ofRectangle             getFrame();
    
    void                    setHighlighted(bool setHighlighted);
    
    float                   outOfBounds();
    
    void                    begin();
    void                    end();
    
    int                     getHeight();
    int                     getWidth();
    
    // METHODS TO OVERRIDE
    
    virtual void            draw(ofRectangle rect);
    
    virtual ofRectangle     getChildRect(ofxScrollView *view);
    virtual ofRectangle     getParentRect();
    
    virtual bool            containsPoint(int x, int y);           //check to see if mouse is within boundaries of this panel.
    
    virtual int             getContentSize();
    
    virtual void            touchDown(float x, float y, int touchId);
    virtual void            touchMoved(float x, float y, int touchId);
    virtual void            touchUp(float x, float y, int touchId);
    virtual void            touchDoubleTap(float x, float y, int touchId);
    
    
    
    void scaleFrame(float scale);
    float _scale = 1.;
    
    // PUBLIC SCALAR PROPERTIES
    
    string          displayName;
    
    int             referenceId = 0;
    int             displayId = 0;
    
    
    bool            hidden = true;
    bool            drawsBorder = true;
    bool            drawsName = true;
    bool            scrollDirectionVertical = true;
    bool            scrollingEnabled = false;
    bool            shouldRasterize = false;
    
    void            setScrollPostion(int offset, bool animated);
    
    float           heightPct = .5;
    float           widthPct = .5;
    
    int             scrollPostion = 0;
    
    float           fgColor[4] = {0,0,0,0};
    float           bgColor[4] = {0,0,0,0};
    
    
    // BASE ONLY PROPERTIES
    
    ofImage         bgImage;
    
    // BASE OR INHERITED PROPERTIES
    
    ofTrueTypeFont localFont;
    ofTrueTypeFont *sharedFont;
    
    float localTint;
    float *sharedTint;
    
    // OFCOLOR EXTENSION
    
    void ofSetColorf(float* color);
    void setBgColor(float* color);
    void setBgColor(ofColor color);
    void setFgColor(float* color);
    void setFgColor(ofColor color);
    
    
    
};



#endif //  ofxScrollView_H_INCLUDED



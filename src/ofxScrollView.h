/***********************************************************************
 * Written by Leif Shackelford
 * Copyright (c) 2014 Chroma Games
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Chroma Games nor the names of its contributors
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ***********************************************************************/

#ifndef  ofxScrollView_H_INCLUDED
#define  ofxScrollView_H_INCLUDED

#include "ofMain.h"

#define DEFAULT_FONT_STRING "ofxTableViewDefault.ttf"
#define DEFAULT_FONT_SIZE 16

class frame3d {
    
    public:
    
    float x,y,z,w,h;
    
    frame3d(){
        x=0;
        y=0;
        z=0;
        w=0;
        h=0;
    }
    
    frame3d(float nx, float ny, float nz, float nw, float nh){
        x=nx;
        y=ny;
        z=nz;
        w=nw;
        h=nh;
    }
    
    frame3d(ofPoint pos, ofRectangle bounds){
        x=pos.x;
        y=pos.y;
        z=pos.z;
        w=bounds.width;
        h=bounds.height;
    }
    
    frame3d& operator= (const frame3d& emp)  // Assignment operator overloading function
    {
        x=emp.x;
        y=emp.y;
        z=emp.z;
        w=emp.w;
        h=emp.h;
        
        return *this;
    }
    
    float getWidth(){
        return w;
    }
    float getHeight(){
        return h;
    }
    
    ofPoint getPosition() {
        return ofPoint(x,y,z);
    }
    
    ofPoint getSize(){
        return ofPoint(w,h);
    }
    
    ofPoint getCenter(){
        return ofPoint(x+w/2.,y+h/2.,z);
    }
    
    ofRectangle getBounds(){
        return ofRectangle(0,0,w,h);
    }
    
    
    
};

typedef enum ScrollPhase {
    ScrollPhaseNil,
    ScrollPhaseBegan,
    ScrollPhaseRecognized,
    ScrollPhaseBeginFail,
    ScrollPhaseFailed,
    ScrollPhaseEnded,
    ScrollPhaseRestitution
} ScrollPhase;

typedef enum TransitionStyle {
    TransitionStyleNone,
    TransitionStyleEnterFromRight,
    TransitionStyleEnterFromLeft,
    TransitionStyleExitToLeft,
    TransitionStyleExitToRight,
    TransitionStyleZoomIn,
    TransitionStyleZoomOut,
    TransitionStyleFade
} TransitionStyle;


class    ofxScrollViewAnimation
{
    
public:
    
    int scrollPosition = 0;
    
    bool completed = false;
    
    long long startTime = 0;
    long long duration = 0;
    
    float completion = 0;
    
    float srcAlpha = 1.;
    float dstAlpha = 1.;
    
    frame3d sourceFrame;
    frame3d destFrame;
    
    TransitionStyle style;
    
};

class    ofxScrollView : public ofNode
{

private:
    // BASE CLASS

protected:
    
    ofRectangle bounds;
    
    
    float alpha;
    
    int             _xRootOffset;
    int             _yRootOffset;
    int *           xTouchOffset;
    int *           yTouchOffset;

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
    
    ScrollPhase scrollPhase = ScrollPhaseNil;
    
    // RASTER
    
    ofFbo           raster;
    
    ofxScrollView * _parent = NULL;
    vector<ofxScrollView *> children;
    
    vector<ofxScrollViewAnimation *> animations;

    bool            highlighted = false;
    
public:
    ofxScrollView();                           //constructor
    ~ ofxScrollView();                          //destructor
    
    //METHODS:--------------------------------------------------------
    
    // METHODS TO BE CALLED BY SUBCLASSES
    
    
    void                    initWithParent(ofxScrollView *parent, frame3d frame);
    void                    addChild(ofxScrollView *child);
    
    void                    update();
    
    frame3d                 getFrame();
    
    ofRectangle             getDrawFrame();
    ofRectangle             getWorldFrame();
    
    ofVec3f                 getCenter();
    void                    setFrame(frame3d frame);
    
    void                    setHighlighted(bool setHighlighted);
    
    float                   outOfBounds();
    
    void                    begin();
    void                    end();
    
    int                     getHeight();
    int                     getWidth();
    
    float                   getScreenScale();
    
    void                    pushModalView(ofxScrollView *child, TransitionStyle transitionStyle, float durationSec);
    void                    popModalView(TransitionStyle transitionStyle,float durationSec);
    void                    updateAnimation(ofxScrollViewAnimation *anim);
    
    ofxScrollView*          getParent();
    ofxScrollView*          getRoot();
    
    ofxScrollView * _modalParent = NULL;
    ofxScrollView * _modalChild = NULL;
    
    // METHODS TO OVERRIDE

    frame3d cachedFrame;
    
    void                    setParent(ofxScrollView* parent);
    
    virtual void            draw();
    
    frame3d                 getChildFrame(ofxScrollView *view);
    
    virtual bool            containsPoint(int x, int y);           //check to see if mouse is within boundaries of this panel.
    
    virtual int             getContentSize();
    
    virtual bool            touchDown(float x, float y, int touchId);
    virtual bool            touchMoved(float x, float y, int touchId);
    virtual bool            touchUp(float x, float y, int touchId);
    virtual bool            touchDoubleTap(float x, float y, int touchId);
    
    
    void scaleFrame(float scale);
    float _scale = 1.;
    
    // INHERITED FROM OF NODE
    
    
    // PUBLIC SCALAR PROPERTIES
    
    string          displayName = "null";
    
    int             referenceId = 0;
    int             displayId = 0;
    
    bool            hidden = false;
    bool            drawsBorder = true;
    bool            drawsName = false;
    bool            scrollDirectionVertical = true;
    bool            scrollingEnabled = false;
    bool            shouldRasterize = false;
    bool            clipToBounds = false;
    
    bool            scrollShouldCull();
    
    int             verticalPadding;
    int             horizontalPadding;
    
    void            setScrollPostion(int offset, bool animated);
    
    float           autoSizePct = 1.;
    
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



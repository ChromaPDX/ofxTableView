#include "ofxScrollView.h"

#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include <Foundation/Foundation.h>

ofxScrollView:: ofxScrollView()//constructor
{
}

ofxScrollView::~ ofxScrollView()//destructor
{
    
    
}

float ofxScrollView::getScreenScale(){
    
    if (((ofAppiOSWindow*)ofGetWindowPtr())->isRetinaEnabled()){
        return 2.0f;
    }
    return 1.0f;
}

void ofxScrollView::initWithParent(ofxScrollView *parent, ofRectangle nframe){
    
    bounds = ofRectangle(0,0,nframe.width,nframe.height);
    frame = ofRectangle(nframe);
    
    if (parent){
        
        _parent = parent;
        
        horizontalPadding = 20;
        verticalPadding = 0;
        
        setFgColor(parent->fgColor);
        
        sharedTint = &parent->localTint;
        sharedFont = parent->sharedFont;
        
        parent->cdirty = true;
        
        xTouchOffset = parent->xTouchOffset;
        yTouchOffset = parent->yTouchOffset;
        
        
    }
    
    else {
        
        localTint = 1.;
        sharedTint = &localTint;
        
        if (!localFont.loadFont(DEFAULT_FONT_STRING, DEFAULT_FONT_SIZE * getScreenScale())){
            
        }
        
        sharedFont = &localFont;
        
        setFgColor(ofColor(255));
        
        _xRootOffset = nframe.x;
        _yRootOffset = nframe.y;
        
        xTouchOffset = &_xRootOffset;
        yTouchOffset = &_yRootOffset;
        
    }
    
    hidden = false;
    restitution = 3;
    drag = 1.5;
    
    
}

void ofxScrollView::addChild(ofxScrollView *child){
    
    child->referenceId = children.size();
    child->displayId = child->referenceId;
    child->hidden = false;
    
    cdirty = true;
    
    children.push_back(child);
    
}

float ofxScrollView::outOfBounds(){
    
    if (scrollDirectionVertical) {
        
        if (scrollPosition > verticalPadding) {
            return scrollPosition - verticalPadding;
        }
        
        else {
            
            if (getContentSize() > frame.height) {
                
                int diff = scrollPosition + getContentSize() - frame.height;
                if (diff < 0){
                    
                    return diff;
                    
                }
                
            }
            else {
                if (scrollPosition < verticalPadding) {
                    return scrollPosition - verticalPadding;
                }
            }
            
        }
        
    }
    
    else {
        
        if (scrollPosition > horizontalPadding) {
            return scrollPosition - horizontalPadding;
        }
        
        else {
            
            if (getContentSize() > frame.width) {
                
                int diff = scrollPosition + getContentSize() - frame.width;
                
                if (diff < 0){
                    
                    return diff;
                    
                }
                
            }
            else {
                if (scrollPosition < horizontalPadding) {
                    return scrollPosition - horizontalPadding;
                }
            }
            
        }
        
        
    }
    
    return 0;
    
}

bool ofxScrollView::scrollShouldCull() {
    
    if (_parent){
        
        if (_parent->scrollingEnabled) {
            
            if (_parent->scrollDirectionVertical && (frame.y + frame.height < _parent->getFrame().y || frame.y > _parent->getFrame().y + _parent->getHeight())) {
                return true;
            }
            
            else if (frame.x + frame.width < _parent->getFrame().x || frame.x > _parent->getFrame().x + _parent->getWidth()) {
                return true;
            }
            
//            else if (_parent->hidden == false) {
//                hidden = false;
//            }
//            
        }
        
    }
    
    return false;
}

void ofxScrollView::update() {
    
    if  (scrollingEnabled){
        
        
        if (scrollPhase != ScrollPhaseNil) {
            
            if (fabsf(scrollVel) > restitution){
                scrollVel = scrollVel / drag;
            }
            
            else {
                scrollVel = 0;
            }
            
            
            if (fabsf(counterVel) > restitution){
                counterVel = counterVel / drag;
            }
            
            else {
                counterVel = 0;
            }
            
        }
        
        if (scrollPhase == ScrollPhaseEnded) {
            
            drag = 1.04;
            
            if (scrollVel != 0 && !outOfBounds()) {
                setScrollPostion(scrollPosition + scrollVel, false);
            }
            
            else {
                scrollPhase = ScrollPhaseRestitution;
                easeIn = 20;
                easeOut = false;
                //NSLog(@"start restitution");
            }
            
        }
        
        if (scrollPhase == ScrollPhaseRestitution) {
            
            scrollVel = 0;
            
            if (!easeOut) {
                if (easeIn > 5) easeIn--;
                else easeOut = true;
            }
            else {
                if (easeIn < 20) easeIn++;
            }
            
            float dir = outOfBounds();
            
            if (dir != 0) {
                setScrollPostion(scrollPosition - dir / easeIn, false);
            }
            
            else {
                //NSLog(@"scroll stopped");
                scrollPhase = ScrollPhaseNil;
            }
            
        }
        
    }
    
    
    for(int i = 0; i < children.size(); i++)
    {
        children[i]->update();
    }
    
    
    
    
}


void ofxScrollView::setScrollPostion(int offset, bool animated){
    
    if (scrollPosition != offset) {
        scrollPosition = offset;
        fdirty = true;
    }
    
}

int  ofxScrollView::getHeight() {
    return frame.height;
}

int  ofxScrollView::getWidth() {
    return frame.width;
}

int ofxScrollView::getContentSize(){
    
    if (cdirty) {
        
        int tempSize = 0;
        
        for(int i = 0; i < children.size(); i++)
        {
            if (scrollDirectionVertical) {
                int temp = children[i]->getHeight();
                tempSize += temp + verticalPadding;
            }
            else {
                int temp = children[i]->getWidth();
                tempSize += temp + horizontalPadding;
            }
            
        }
        
        contentSize = tempSize;
        
        return tempSize;
        
    }
    
    else {
        return contentSize;
    }
}

ofRectangle  ofxScrollView::getChildRect(ofxScrollView *v){
    
    if (fdirty) {
        
        v->fdirty = true;
        
        //   NSLog(@"rasterizing!!");
        
        if (scrollDirectionVertical){
            
            int tempSize = 0;
            for(int i = 0; i < v->referenceId; i++)
            {
                int temp = children[i]->getHeight();
                tempSize += temp + verticalPadding;
            }
            
            
            v->frame = ofRectangle(frame.x + (horizontalPadding / 2.),
                                   frame.y + tempSize + scrollPosition,
                                   frame.width-(horizontalPadding),
                                   frame.height * v->heightPct
                                   );
            
            v->hidden = v->scrollShouldCull();
            
            return v->frame;
            
        }
        
        else {
            
            int tempSize = 0;
            
            for(int i = 0; i < v->referenceId; i++)
            {
                int temp = children[i]->getWidth();
                tempSize += temp + horizontalPadding;
            }
            
            v->frame = ofRectangle(frame.x + tempSize + scrollPosition,
                                   frame.y + (verticalPadding/2.),
                                   frame.width * v->widthPct,
                                   frame.height - verticalPadding);
            
            v->hidden = v->scrollShouldCull();
            
            return v->frame;
            
        }
        
    }
    
    else {
        return v->frame;
    }
    
    
}

ofRectangle ofxScrollView::getFrame() {
    return frame;
}

void ofxScrollView::setFrame(ofRectangle nframe){
    frame = nframe;
    fdirty = true;
}

ofRectangle ofxScrollView::getParentRect(){
    
    return ofRectangle(_parent->getFrame());
    
}

void ofxScrollView::scaleFrame(float scale){
    
    if (_scale != scale){
        
        fdirty = true;
        cdirty = true;
        
        float dScale = (scale - _scale);
        
        float rScale = 1 + dScale;
        
        bounds = ofRectangle(0,0,bounds.width * rScale,bounds.height * rScale);
        
        setFrame(ofRectangle(frame.x, frame.y, bounds.width, bounds.height));
        
        _xRootOffset = frame.x;
        _yRootOffset = frame.y;
        
        _scale += dScale;
        
        raster.allocate(bounds.width, bounds.height);
        
        NSLog(@"new: %f, delta : %f, scale %f",scale, dScale, _scale);
        
    }
    
}

void ofxScrollView::setHighlighted(bool setHighlighted) {
    
    if (scrollingEnabled) {
        if (!setHighlighted) {
            for (int i = 0; i < children.size(); i++ )
            {
                children[i]->setHighlighted(false);
            }
        }
    }
    
    else {
        highlighted = setHighlighted;
    }
    
}

void ofxScrollView::begin(ofRectangle rect) {
    
    if (!_parent) {
        //  ofEnableAlphaBlending();
    }
    
    if (!hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        
        if (shouldRasterize){
            
            if (!raster.isAllocated()) {
                raster.allocate(rect.width, rect.height);
            }
            raster.begin();
            
        }
        
        if (bgImage.isAllocated()) {
            bgImage.draw(rect);
            
//            if (highlighted) {
//                ofFill();
//                ofSetColor(255,255,255,50);
//                ofRect(rect);
//            }
        }
        
        else if (bgColor[3] != 0){

            ofFill();
            
//            if (highlighted) {
//                float tempColor[4] = {bgColor[0]+.2, bgColor[1]+.2, bgColor[2]+.2, bgColor[3]+.2};
//                ofSetColorf(tempColor);
//            }
            ofSetColorf(bgColor);
            ofRect(rect);
            
        }
        
        if (drawsName) {
            ofSetColorf(fgColor);
            sharedFont->drawString(displayName, rect.x + rect.width - sharedFont->stringWidth(displayName), rect.y + sharedFont->stringHeight(displayName));
        }
        
        
        
    }
    
}

void ofxScrollView::end(ofRectangle rect) {
    
    
    if (!hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        
        for(int i = 0; i < children.size(); i++)
        {
          
            children[i]->draw(getChildRect(children[i]));
        
        }
        
        if (drawsBorder) {
            ofNoFill();
            
            ofSetColorf(fgColor);
            ofSetLineWidth(2*getScreenScale());
            
            ofRect(rect);
        }
        

        if (shouldRasterize) {
            
            raster.end();
            raster.draw(frame.x, frame.y);
            
        }
        
        if (highlighted) {
            ofEnableBlendMode(OF_BLENDMODE_ADD);
            ofFill();
            ofSetColor(255,255,255,100);
            ofRect(rect);
            ofEnableBlendMode(OF_BLENDMODE_ALPHA);
        }
        
        dirty = false;
        fdirty = false;
    }
    
}

void     ofxScrollView::draw(ofRectangle rect)
{
    
    /*
    // SUBCLASS LOOKS LIKE
    
    if (!hidden) {
        
        ofxScrollView::begin();
        
        // CUSTOM DRAW CODE
        
        ofxScrollView::end();
        
    }
    */
    
}

bool     ofxScrollView::containsPoint(int x, int y) //check to see if mouse is within boundaries of object.
{
    
    int lx = x - *xTouchOffset;
    int ly = y - *yTouchOffset;
    
    bool withinArea = false;
    if ( lx > frame.x && lx < frame.x + frame.width && ly > frame.y && ly < frame.y + frame.height)
    {
        withinArea = true;
    }
    return withinArea;
}


//------------MOUSE-and KEYBOARD-------------------------------------------------
//-------------------------------------------------------------------------------

void     ofxScrollView::touchDown(float x , float y, int touchId)
{
    
    if (scrollingEnabled) {
        
        scrollPhase = ScrollPhaseBegan;
        
        xOrigin = x;
        yOrigin = y;
        
        counterVel = 0;
        scrollVel = 0;
        
        drag = 1.5;
        
    }
    
    else {
        for (int i = 0; i < children.size(); i++ )
        {
            if ( children[i]->containsPoint(x,y) == true)
            {
                children[i]->setHighlighted(true);
                children[i]->touchDown(x, y, touchId);
            }
            else
            {
                children[i]->setHighlighted(false);
            }
        }
    }
    
}

void     ofxScrollView::touchMoved(float x, float y, int touchId)
{
    
    if  (scrollingEnabled) {
        
        int sDt;
        int cDt;
        
        if (scrollDirectionVertical) {
            sDt = (y - yOrigin);
            cDt = (x - xOrigin);
        }
        else {
            sDt = (x - xOrigin);
            cDt = (y - yOrigin);
        }
        
        xOrigin = x;
        yOrigin = y;
        
        scrollVel += sDt;
        counterVel += cDt;
        
        if (scrollPhase <= ScrollPhaseBegan){
            
            if (fabs(scrollVel) > fabs(counterVel) + (restitution * 2.)){
                scrollPhase = ScrollPhaseRecognized;
                //NSLog(@"Scroll started %f, %f", scrollVel, counterVel);
                
            }
            
            else if (fabs(counterVel) > fabs(scrollVel) + (restitution)){
               // NSLog(@"FAILED %f, %f", counterVel, scrollVel);
                scrollPhase = ScrollPhaseBeginFail;
            }
            
        }
        
        else if (scrollPhase == ScrollPhaseRecognized){
            
            setScrollPostion(scrollPosition + sDt, false);
            
        }
        
        else if (scrollPhase == ScrollPhaseBeginFail) {
            
            for (int i = 0; i < children.size(); i++ )
            {
                if ( children[i]->containsPoint(x,y) == true)
                {
                    children[i]->setHighlighted(true);
                    children[i]->touchDown(x, y, touchId);
                }
                else
                {
                    children[i]->setHighlighted(false);
                }
            }
            
            scrollPhase = ScrollPhaseFailed;
            
        }
        
        else if (scrollPhase == ScrollPhaseFailed) {
            
            for (int i = 0; i < children.size(); i++ )
            {
                if ( children[i]->containsPoint(x,y) == true)
                {
                    
                    children[i]->touchMoved(x, y, touchId);
                    
                }
            }
            
        }
        
    }
    
    else {
        for (int i = 0; i < children.size(); i++ )
        {
            if ( children[i]->containsPoint(x,y) == true)
                children[i]->touchMoved(x, y, touchId);
        }
        
    }
    
}

void     ofxScrollView::touchUp(float x, float y, int touchId)
{
    
    if (scrollingEnabled) {
        
        if (scrollPhase == ScrollPhaseFailed || scrollPhase == ScrollPhaseBegan || scrollPhase == ScrollPhaseNil) {
            
            //            if (scrollPhase == ScrollPhaseBegan) { // NEVER RECOGNIZED
            //
            //                for (int i = 0; i < children.size(); i++ )
            //                {
            //                    if ( children[i]->containsPoint(x,y) == true)
            //                    {
            //                        children[i]->touchDown(x, y, touchId);
            //                    }
            //                }
            //            }
            
            for (int i = 0; i < children.size(); i++ )
            {
                
                children[i]->setHighlighted(false);
                
                if ( children[i]->containsPoint(x,y) == true)
                {
                    children[i]->touchUp(x, y, touchId);
                    children[i]->setHighlighted(true);
                }
                
                else if (children[i]->scrollPhase != ScrollPhaseNil) {
                    children[i]->touchUp(x, y, touchId);
                }
                
            }
            
            scrollPhase = ScrollPhaseNil;
            
        }
        
        else {
            
            
            // NSLog(@"scroll ended on %s %f", displayName.c_str(), scrollVel);
            
            scrollPhase = ScrollPhaseEnded;
        }
        
    }
    
    else {
        
        for (int i = 0; i < children.size(); i++ )
        {
            if ( children[i]->containsPoint(x,y) == true)
            {
                children[i]->touchUp(x, y, touchId);
            }
            
        }
        
    }
    
    
}

void ofxScrollView::touchDoubleTap(float x, float y, int touchId){
    
    
}

void ofxScrollView::ofSetColorf(float *c){
    ofSetColor(c[0]*255, c[1]*255, c[2]*255,c[3]*255);
}

void ofxScrollView::setFgColor(float *c){
    memcpy(fgColor, c, sizeof(float[4]));
}

void ofxScrollView::setFgColor(ofColor color){
    for (int i = 0; i<4; i++) {
        fgColor[i] = color[i] / 255.;
    }
}

void ofxScrollView::setBgColor(float *c){
    memcpy(fgColor, c, sizeof(float[4]));
}

void ofxScrollView::setBgColor(ofColor color){
    for (int i = 0; i<4; i++) {
        bgColor[i] = color[i] / 255.;
    }
}



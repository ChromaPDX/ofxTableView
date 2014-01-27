#include "ofxScrollView.h"
#include <Foundation/Foundation.h>

ofxScrollView:: ofxScrollView()//constructor
{
}

ofxScrollView::~ ofxScrollView()//destructor
{
    
    
}


void ofxScrollView::initWithParent(ofxScrollView *parent, ofRectangle nframe){
    
    if (parent){
        
        _parent = parent;
        
        horizontalPadding = 20;
        verticalPadding = 0;
        
        setFgColor(parent->fgColor);
        
        sharedTint = &parent->localTint;
        sharedFont = parent->sharedFont;
        
        parent->cdirty = true;
        
    }
    
    else {
        
        localTint = 1.;
        sharedTint = &localTint;
        
        if (!localFont.loadFont(DEFAULT_FONT_STRING, DEFAULT_FONT_SIZE)){
            
        }
        sharedFont = &localFont;
        
        
    }
    
    frame = ofRectangle(nframe);
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

void ofxScrollView::update() {
    
    if (frame.y + frame.height < 0 || frame.y > ofGetHeight()) {
        hidden = true;
    }
    else {
        
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
                    NSLog(@"start restitution");
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
                    NSLog(@"scroll stopped");
                    scrollPhase = ScrollPhaseNil;
                }
                
            }
            
        }
        
        hidden = false;
        
        for(int i = 0; i < children.size(); i++)
        {
            children[i]->update();
        }
        
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

ofRectangle ofxScrollView::getParentRect(){
    
    return ofRectangle(_parent->getFrame());
    
}

void ofxScrollView::scaleFrame(float scale){
    
    if (_scale != scale){
        
        fdirty = true;
        cdirty = true;
        
        float dScale = (scale - _scale);
        float rScale = 1 + dScale;
        
        frame = ofRectangle(frame.x * rScale, frame.y * rScale, frame.width * rScale, frame.height * rScale);
        
        _scale += dScale;
        
        NSLog(@"new: %f, delta : %f, scale %f",scale, dScale, _scale);
        
    }
    
}

void ofxScrollView::setHighlighted(bool setHighlighted) {
    highlighted = setHighlighted;
}

void ofxScrollView::begin() {
    
    if (!_parent) {
        ofEnableAlphaBlending();
    }
    
    if (!hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        
        if (shouldRasterize){
            
            if (!raster.isAllocated()) {
                raster.allocate(frame.width, frame.height);
            }
            raster.begin();
            
        }
        
        if (bgImage.isAllocated()) {
            bgImage.draw(frame);
        }
        
        else if (bgColor[3] != 0){
            
            ofFill();
            ofSetColorf(bgColor);
            ofRect(frame);
            
        }
        
        if (drawsName) {
            
            sharedFont->drawString(displayName, frame.x + frame.width - sharedFont->stringWidth(displayName), frame.y + sharedFont->stringHeight(displayName));
            
        }
        
        
        
    }
    
}

void ofxScrollView::end() {
    
    
    if (!hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        
        for(int i = 0; i < children.size(); i++)
        {
            children[i]->draw(getChildRect(children[i]));
        }
        
        if (drawsBorder) {
            ofNoFill();
            
            ofSetColor(255,255,255,200);
            ofSetLineWidth(2);
            
            ofRect(frame);
        }
        
        if (shouldRasterize) {
            
            raster.end();
            raster.draw(frame.x, frame.y);
            
        }
        
        dirty = false;
        fdirty = false;
    }
    
    
    
}

void     ofxScrollView::draw(ofRectangle rect)
{
    begin();
    // CUSTOM DRAW CODE
    end();
    
    // SUBCLASS LOOKS LIKE
    // ofxScrollView::begin();
    // custom code
    // ofxScrollView::end();
}

bool     ofxScrollView::containsPoint(int x, int y) //check to see if mouse is within boundaries of object.
{
    bool withinArea = false;
    if ( x > frame.x && x < frame.x + frame.width && y > frame.y && y < frame.y + frame.height)
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
                children[i]->highlighted = true;
                children[i]->touchDown(x, y, touchId);
            }
            else
            {
                children[i]->highlighted = false;
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
                NSLog(@"Scroll started %f, %f", scrollVel, counterVel);
                
            }
            
            else if (fabs(counterVel) > fabs(scrollVel) + (restitution)){
                NSLog(@"FAILED %f, %f", counterVel, scrollVel);
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
                    children[i]->highlighted = true;
                    children[i]->touchDown(x, y, touchId);
                }
                else
                {
                    children[i]->highlighted = false;
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
        
        if (scrollPhase == ScrollPhaseFailed || scrollPhase == ScrollPhaseBegan) {
            
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
                
                if ( children[i]->containsPoint(x,y) == true)
                {
                    children[i]->touchUp(x, y, touchId);
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



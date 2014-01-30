#include "ofxScrollView.h"
#include "ofxTableView.h"

#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include <Foundation/Foundation.h>

ofxScrollView:: ofxScrollView()//constructor
{
}

ofxScrollView::~ ofxScrollView()//destructor
{
    
    
}



#pragma mark - INIT + Children

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

ofxScrollView* ofxScrollView::getRoot(){
    
    if (_modalParent){
        return this;
    }
    
    if (_parent) {
        return _parent->getRoot();
    }
    
    return this;
    
}

ofxScrollView* ofxScrollView::getParent(){
    
    if (_parent) {
        return _parent;
    }
    
    return this;
    
}

#pragma mark - Animation

void ofxScrollView::pushModalView(ofxScrollView *child, TransitionStyle style, float durationSec){
    
    _modalChild = child;
    child->_modalParent = this;
    
    // Create My Transition Object
    
    
    ofxScrollViewAnimation* currentAnimation = new ofxScrollViewAnimation;
    
    currentAnimation->completed = false;
    currentAnimation->completion = 0.0f;
    currentAnimation->duration = durationSec * 1000;
    currentAnimation->startTime = ofGetElapsedTimeMillis();
    currentAnimation->style = style;
    currentAnimation->sourceFrame = getFrame();
    
    
    // Create Child Transition Object
    
    ofxScrollViewAnimation* childAnimation = new ofxScrollViewAnimation;
    
    childAnimation->completed = false;
    childAnimation->completion = 0.0f;
    childAnimation->duration = durationSec * 1000;
    childAnimation->startTime = ofGetElapsedTimeMillis();
    childAnimation->style = style;
    childAnimation->sourceFrame = ofRectangle(frame.x+frame.width, frame.y, frame.width, frame.height);
    
    switch (style) {
        case TransitionStyleNone:
            
            break;
            
        case TransitionStyleExitToLeft:
            
            currentAnimation->destFrame = ofRectangle(frame.x-frame.width, frame.y, frame.width, frame.height);
            childAnimation->style = TransitionStyleEnterFromRight;
            childAnimation->destFrame = getFrame();
            
            child->hidden = false;
            
            break;
            
        case TransitionStyleExitToRight:
            
            currentAnimation->destFrame = ofRectangle(frame.x+frame.width, frame.y, frame.width, frame.height);
            childAnimation->style = TransitionStyleEnterFromLeft;
            childAnimation->destFrame = getFrame();
            
            child->hidden = false;
            
            break;
            
            
        default:
            break;
    }
    
    NSLog(@"Starting Animation");
    NSLog(@"target frame: %f %f %f %f", currentAnimation->destFrame.x, currentAnimation->destFrame.y,currentAnimation->destFrame.width,currentAnimation->destFrame.height);
    NSLog(@"child target frame: %f %f %f %f", childAnimation->destFrame.x, childAnimation->destFrame.y,childAnimation->destFrame.width,childAnimation->destFrame.height);
    
    animations.push_back(currentAnimation);
    child->animations.push_back(childAnimation);
    
}

void ofxScrollView::popModalView(TransitionStyle style,float durationSec){
    
    ofxScrollView *child = _modalChild;
    
    // Create My Transition Object
    
    ofxScrollViewAnimation* currentAnimation = new ofxScrollViewAnimation;
    
    currentAnimation->completed = false;
    currentAnimation->completion = 0.0f;
    currentAnimation->duration = durationSec * 1000;
    currentAnimation->startTime = ofGetElapsedTimeMillis();
    currentAnimation->style = style;
    currentAnimation->sourceFrame = getFrame();
    
    
    // Create Child Transition Object
    
    ofxScrollViewAnimation* childAnimation = new ofxScrollViewAnimation;
    
    childAnimation->completed = false;
    childAnimation->completion = 0.0f;
    childAnimation->duration = durationSec * 1000;
    childAnimation->startTime = ofGetElapsedTimeMillis();
    childAnimation->style = style;
    childAnimation->sourceFrame = child->getFrame();
    
    switch (style) {
        case TransitionStyleNone:
            
            break;
            
        case TransitionStyleEnterFromLeft:
            
            currentAnimation->destFrame = ofRectangle(frame.x+frame.width, frame.y, frame.width, frame.height);
            
            childAnimation->style = TransitionStyleExitToRight;
            
            childAnimation->destFrame = ofRectangle(child->getFrame().x+child->getFrame().width, child->getFrame().y, child->getFrame().width, child->getFrame().height);
            
            hidden=false;
            
            break;
            
        case TransitionStyleEnterFromRight:
            
            currentAnimation->destFrame = ofRectangle(frame.x-frame.width, frame.y, frame.width, frame.height);
            
            childAnimation->style = TransitionStyleExitToLeft;
            
            childAnimation->destFrame = ofRectangle(child->getFrame().x-child->getFrame().width, child->getFrame().y, child->getFrame().width, child->getFrame().height);
            
            hidden=false;
            
            break;
            
        default:
            break;
    }
    
    NSLog(@"Starting Animation");
    NSLog(@"target frame: %f %f %f %f", currentAnimation->destFrame.x, currentAnimation->destFrame.y,currentAnimation->destFrame.width,currentAnimation->destFrame.height);
    NSLog(@"child target frame: %f %f %f %f", childAnimation->destFrame.x, childAnimation->destFrame.y,childAnimation->destFrame.width,childAnimation->destFrame.height);
    
    
    animations.push_back(currentAnimation);
    child->animations.push_back(childAnimation);
    
}

inline float weightedAverage (float src, float dst, float d){
    
    return src == dst ? src : ((src * (1.-d) + dst * d));
    
}

inline float logAverage (float src, float dst, float d){
    
    return src == dst ? src : ((src * (1.- d*d) + dst * d * d));
    
}

inline ofRectangle getTweenFrame(ofRectangle src, ofRectangle dst, float d){
    
    return ofRectangle(weightedAverage(src.x, dst.x, d),
                       weightedAverage(src.y, dst.y, d),
                       weightedAverage(src.width, dst.width, d),
                       weightedAverage(src.height, dst.height, d));
    
}

void ofxScrollView::updateAnimation(ofxScrollViewAnimation *anim) {
    
    
    anim->completion = ((float)(ofGetElapsedTimeMillis() - anim->startTime) / (anim->duration));
    
    //NSLog(@"update %f completion", anim->completion);
    
    switch (anim->style) {
        case TransitionStyleNone:
            
            break;
            
        case TransitionStyleEnterFromRight: case TransitionStyleEnterFromLeft: case TransitionStyleExitToLeft: case TransitionStyleExitToRight:
            
            setFrame(getTweenFrame(anim->sourceFrame, anim->destFrame, anim->completion));
            
            break;
            
        case TransitionStyleFade:
            alpha = weightedAverage(anim->srcAlpha, anim->dstAlpha, anim->completion);
            
        default:
            break;
    }
    
    if (anim->completion >= 1.){
        
        setFrame(anim->destFrame);
        
        if (anim->style == TransitionStyleExitToLeft || anim->style == TransitionStyleExitToRight) {
            hidden = true;
        }
        
        if (anim->style == TransitionStyleEnterFromLeft || anim->style == TransitionStyleEnterFromRight) {
            if (_modalChild) {
                
                _modalChild->hidden = true;
                
                _modalChild->_modalParent = NULL;
                _modalChild = NULL;
                
            }
        }
        
        delete anim;
        
        animations.erase(animations.begin());
        
        NSLog(@"animation compelted after %llu seconds", (ofGetElapsedTimeMillis() - anim->startTime));
        
//        if (_modalChild) {
//                 popModalView(TransitionStyleEnterFromLeft, 1.);
//        }
        
        
    }
    

    
}



#pragma mark - ofx UPDATE

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
    
    if (animations.size()) {
        updateAnimation(animations[0]);
    }
    
    for(int i = 0; i < children.size(); i++)
    {
        children[i]->update();
    }
    
    
    
    
}

#pragma mark - ofx DRAW

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

void ofxScrollView::end(ofRectangle rect) {
    
    
    if (!hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        
        for(int i = 0; i < children.size(); i++)
        {
            
            if (getRoot()->_modalChild) {
                if (getRoot()->_modalChild != children[i]) {
                    children[i]->draw(getChildRect(children[i]));
                }
            }
            else {
                children[i]->draw(getChildRect(children[i]));
            }
            
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
    
    if (_modalChild) {
        ((ofxTableView*)_modalChild)->draw();
    }
    
}

#pragma mark - Geometry

float ofxScrollView::getScreenScale(){
    
    if (((ofAppiOSWindow*)ofGetWindowPtr())->isRetinaEnabled()){
        return 2.0f;
    }
    return 1.0f;
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

void ofxScrollView::setScrollPostion(int offset, bool animated){
    
    if (scrollPosition != offset) {
        scrollPosition = offset;
        fdirty = true;
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
    
    return ofRectangle(frame);
    
}

void ofxScrollView::setFrame(ofRectangle nframe){
    
    if (frame.height != nframe.height || frame.width != nframe.width) { // SCALED, refresh content size
        cdirty = true;
    }
    
    fdirty = true;
    
    frame = ofRectangle(nframe);
    bounds = ofRectangle(0, 0, nframe.width, nframe.height);

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

#pragma mark - UI STATE

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

#pragma mark - TOUCH / HID

//------------MOUSE-and KEYBOARD-------------------------------------------------
//-------------------------------------------------------------------------------

bool     ofxScrollView::touchDown(float x , float y, int touchId)
{
    
    if (_modalChild){
        _modalChild->touchDown(x, y, touchId);
        return false;
    }
    
    bool hit = true;
    
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
            if  (!children[i]->hidden){
                if ( children[i]->containsPoint(x,y) == true)
                {
                    children[i]->setHighlighted(true);
                    children[i]->touchDown(x, y, touchId);
                    hit = false;
                }
                
                else
                {
                    children[i]->setHighlighted(false);
                }
            }
        }
    }
    
    return hit;
    
}

bool     ofxScrollView::touchMoved(float x, float y, int touchId)
{
    
    
    if (_modalChild){
        _modalChild->touchMoved(x, y, touchId);
        return false;
    }
    
    bool hit = true;
    
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
                if  (!children[i]->hidden){
                    if ( children[i]->containsPoint(x,y) == true)
                    {
                        children[i]->setHighlighted(true);
                        children[i]->touchDown(x, y, touchId);
                        hit = false;
                    }
                    else
                    {
                        children[i]->setHighlighted(false);
                    }
                }
            }
            
            scrollPhase = ScrollPhaseFailed;
            
        }
        
        else if (scrollPhase == ScrollPhaseFailed) {
            
            for (int i = 0; i < children.size(); i++ )
            {
                if  (!children[i]->hidden){
                    
                    if ( children[i]->containsPoint(x,y) == true)
                    {
                        
                        children[i]->touchMoved(x, y, touchId);
                        hit = false;
                        
                    }
                }
            }
            
        }
        
    }
    
    else {
        for (int i = 0; i < children.size(); i++ )
        {
            if  (!children[i]->hidden){
                
                if ( children[i]->containsPoint(x,y) == true){
                    children[i]->touchMoved(x, y, touchId);
                    hit = false;
                }
            }
            
        }
        
    }
    
    return hit;
    
}

bool     ofxScrollView::touchUp(float x, float y, int touchId)
{
    
    bool hit = true;
    
    if (_modalChild){
        _modalChild->touchUp(x, y, touchId);
        return 0;
    }
    
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
                    
                    hit = false;
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
                hit = false;
            }
            
        }
        
        
    }
    
    return hit;
    
    
}

bool ofxScrollView::touchDoubleTap(float x, float y, int touchId){
    
    return 1;
    
}



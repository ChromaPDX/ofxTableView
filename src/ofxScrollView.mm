#include "ofxScrollView.h"
#include "ofxTableView.h"

#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include <Foundation/Foundation.h>

@implementation ScrollViewAction

static inline frame3d getTweenFrame(frame3d src, frame3d dst, float d){
    
    return frame3d(weightedAverage(src.x, dst.x, d),
                   weightedAverage(src.y, dst.y, d),
                   weightedAverage(src.z, dst.z, d),
                   weightedAverage(src.w, dst.w, d),
                   weightedAverage(src.h, dst.h, d));
    
}

+(ScrollViewAction*)TransitionWithStyle:(TransitionStyle) style Duration:(NSTimeInterval)duration {
    
    ScrollViewAction* action = [[ScrollViewAction alloc] init];
    
    action.style = style;
    action.duration = duration;
    
    action.actionBlock = (ActionBlock)^(ofNode* node, float completion){
        
        //NSLog(@"start of block");
        
        switch (action.style) {
                
            case TransitionStyleNone:
                
                break;
                
            case TransitionStyleEnterFromRight: case TransitionStyleEnterFromLeft: case TransitionStyleExitToLeft: case TransitionStyleExitToRight:
                
                ((ofxScrollView*)action.node)->setFrame(getTweenFrame(action.sourceFrame, action.destFrame, completion));
                
                break;
                
            case TransitionStyleZoomIn: case TransitionStyleZoomOut:
                
                ((ofxScrollView*)action.node)->setFrame(getTweenFrame(action.sourceFrame, action.destFrame, completion));
                
                break;
                
            case TransitionStyleFade:
                ((ofxScrollView*)action.node)->alpha = weightedAverage(action.srcAlpha, action.dstAlpha, completion);
                
            default:
                break;
        }
        
        if (completion == 1){
            
            ((ofxScrollView*)action.node)->setFrame(action.destFrame);
            
            if (action.style == TransitionStyleExitToLeft || action.style == TransitionStyleExitToRight || action.style == TransitionStyleZoomIn) {
                ((ofxScrollView*)action.node)->hidden = true;
            }
            
            if (action.style == TransitionStyleEnterFromLeft || action.style == TransitionStyleEnterFromRight || action.style == TransitionStyleZoomOut) {
                if (((ofxScrollView*)action.node)->_modalChild) {
                    
                    ((ofxScrollView*)action.node)->_modalChild->setOrientation(((ofxScrollView*)action.node)->_modalChild->cachedOrientation);
                    ((ofxScrollView*)action.node)->_modalChild->setParent(((ofxScrollView*)action.node)->_modalChild->_parent);
                    
                    ((ofxScrollView*)action.node)->_modalChild->_modalParent = NULL;
                    ((ofxScrollView*)action.node)->_modalChild = NULL;
                    
                }
            }
            
            NSLog(@"animation compelted after %f seconds", action.progress);
            
            NSLog(@"end of block");
            
            
        }

        
    };
    
    NSLog(@"create trans action");
    return action;
    
}


@end

ofxScrollView:: ofxScrollView()//constructor
{
    animationHandler = [[NodeAnimationHandler alloc] initWithNode:this];
}

ofxScrollView::~ ofxScrollView()//destructor
{
    
    
}


#pragma mark - INIT + Children


void ofxScrollView::initWithParent(ofxScrollView *parent, frame3d frame){
    
    setFrame(frame);
    
    if (parent){
        
        setParent(parent);
        
        horizontalPadding = 20;
        verticalPadding = 0;
        
        setFgColor(parent->fgColor);
        
        sharedTint = &parent->localTint;
        sharedFont = parent->sharedFont;
        
        parent->cdirty = true;
        
        ofNode *recur2 = this;
        
        int nump = 0;
        
        while (recur2->getParent()) {
            
            recur2 = recur2->getParent();
            
            nump++;
        }
        
        NSLog(@"node level: %d", nump);
        
    }
    
    else {
        
        
        
        localTint = 1.;
        sharedTint = &localTint;
        
        if (!localFont.loadFont(DEFAULT_FONT_STRING, DEFAULT_FONT_SIZE * getScreenScale())){
            
        }
        
        sharedFont = &localFont;
        
        setFgColor(ofColor(255));
        
        float nbgColor[4] = {rand()%255/255., rand()%255/255.,rand()%255/255.,1.};
        
        setBgColor(nbgColor);
        
        _xRootOffset = getX();
        _yRootOffset = getY();
        
        xTouchOffset = &_xRootOffset;
        yTouchOffset = &_yRootOffset;
        
    }
    
    restitution = 3;
    drag = 1.5;
    
    
}

void ofxScrollView::addChild(ofxScrollView *child){
    
    if (!hasChild(child)) {
        
        child->referenceId = children.size();
        child->displayId = child->referenceId;
        child->hidden = false;
        
        cdirty = true;
        
        children.push_back(child);
        
    }
    
}

void ofxScrollView::insertChild(ofxScrollView *child){
    
    
    if (!hasChild(child)) {
        
        vector<ofxScrollView*>::iterator it;
        
        for ( it = children.begin(); it != children.end(); ){
            (*it)->referenceId++;
            (*it)->displayId++;
        }
        
        child->referenceId = children.size();
        child->displayId = child->referenceId;
        child->hidden = false;
        
        cdirty = true;
        
        children.insert(children.begin(), child);
        
    }
    
}

void ofxScrollView::removeChild(ofxScrollView* child){
    
    vector<ofxScrollView*>::iterator it;
    
    for ( it = children.begin(); it != children.end(); ){
        if( (*it)==child ){
            it = children.erase(it);
        }
        else {
            ++it;
        }
    }
    
    
}

bool ofxScrollView::hasChild(ofxScrollView* child){
    
    
    vector<ofxScrollView*>::iterator it;
    
    for ( it = children.begin(); it != children.end(); ){
        if( (*it)==child ){
            // it = children.erase(it);
            return true;
        }
        else {
            ++it;
        }
    }
    
    return false;
    
}



void ofxScrollView::setParent(ofxScrollView *parent){
    
    if (!parent) {
        if (_parent) {
            _parent->removeChild(this);
        }
    }
    
    _parent = parent;
    
    if (parent) {
        
        ofNode::setParent(*_parent, true);
    }
    
    else {
        ofNode::clearParent();
    }
    
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

ofNode* ofxScrollView::getParent(){
    
    return ofNode::getParent();
    
}

#pragma mark - Animation

void ofxScrollView::pushModalView(ofxScrollView *child, TransitionStyle style, float durationSec){
    
    _modalChild = child;
    
    child->_modalParent = this;
    child->cachedOrientation = ofQuaternion(child->getOrientationQuat());
    
    // Create My Transition Object
    
    ScrollViewAction *action = [ScrollViewAction TransitionWithStyle:style Duration:durationSec*1000];
    
    action.sourceFrame = getFrame();
    
    // Create Child Transition Object
    
    ScrollViewAction *action2 = [ScrollViewAction TransitionWithStyle:style Duration:durationSec*1000];
    
    action2.destFrame = getFrame();
    
    child->hidden = false;
    
    
    switch (style) {
            
        case TransitionStyleNone:
            
            break;
            
        case TransitionStyleExitToLeft:
            
            action2.sourceFrame = frame3d(myFrame.x+myFrame.w, myFrame.y, 0, myFrame.w, myFrame.h);
            
            action.destFrame = frame3d(myFrame.x-myFrame.w, myFrame.y,getZ(), myFrame.w, myFrame.h);
            
            action2.style = TransitionStyleEnterFromRight;
            
            
            
            child->hidden = false;
            
            break;
            
        case TransitionStyleExitToRight:
            
            
            action2.sourceFrame = frame3d(myFrame.x-myFrame.w, myFrame.y, 0, myFrame.w, myFrame.h);
            
            action.destFrame = frame3d(myFrame.x+myFrame.w, myFrame.y, getZ(), myFrame.w, myFrame.h);
            action2.style = TransitionStyleEnterFromLeft;
            
            
            break;
            
        case TransitionStyleZoomIn:
            
            child->hidden = false;
            
            action2.sourceFrame = frame3d(child->getGlobalPosition(), child->getFrame().getSize());
            
            //logFrame(child->getGlobalFrame());
            
            _modalChild->cachedFrame = action2.sourceFrame;
            
            action.destFrame = frame3d(getX(), getY(), getZ()+1000, myFrame.w,myFrame.h);
            
            action2.style = TransitionStyleZoomOut;
            
            break;
            
            
            
        default:
            break;
    }
    
    child->clearParent();
    
    [animationHandler runAction:action];
    [child->animationHandler runAction:action2];
    
    NSLog(@"Starting Animation");
    
    logFrame(action.destFrame);
    logFrame(action2.destFrame);
    
}

void ofxScrollView::popModalView(TransitionStyle style,float durationSec){
    
    ofxScrollView *child = _modalChild;
    
    _modalChild->_modalParent = NULL;
    
    // Create My Transition Object
    
    ScrollViewAction *action = [ScrollViewAction TransitionWithStyle:style Duration:durationSec*1000];
    
    action.sourceFrame = getFrame();
    
    
    // Create Child Transition Object
    
    ScrollViewAction *action2 = [ScrollViewAction TransitionWithStyle:style Duration:durationSec*1000];
    
    action2.sourceFrame = child->getFrame();
    
    child->hidden = false;
    
    switch (style) {
        case TransitionStyleNone:
            
            break;
            
        case TransitionStyleEnterFromLeft:
            
            action.destFrame = frame3d(getX()+myFrame.w, getY(), getZ(), myFrame.w, myFrame.h);
            
            
            action2.style = TransitionStyleExitToRight;
            
            action2.destFrame = frame3d(child->getX()+child->getWidth(), child->getY(), child->getZ(), child->getWidth(), child->getHeight());
            
            hidden=false;
            
            break;
            
        case TransitionStyleEnterFromRight:
            
            action.destFrame = frame3d(getX()-myFrame.w, getY(), getZ(), myFrame.w, myFrame.h);
            
            action2.style = TransitionStyleExitToLeft;
            
            action2.destFrame = frame3d(child->getX()-child->getWidth(), child->getY(), child->getZ(), child->getWidth(), child->getHeight());
            
            hidden=false;
            
            break;
            
        case TransitionStyleZoomOut:
            
            hidden=false;
            
            //_modalChild->cachedFrame = _modalChild->getFrame();
            
            action.destFrame = frame3d(getX(), getY(), 0, myFrame.w,myFrame.h);
            
            action2.destFrame = _modalChild->cachedFrame;
            
            action2.style = TransitionStyleEnterFromLeft;
            
            break;
            
        default:
            break;
    }
    
    [animationHandler runAction:action];
    [child->animationHandler runAction:action2];
    
    NSLog(@"Starting Animation");
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
    
    double time = ofGetElapsedTimeMillis();
    
    if (lastTime != 0) {
    [animationHandler updateWithTimeSinceLast:time - lastTime];
    }
    
    lastTime = time;
    
    for(int i = 0; i < children.size(); i++)
    {
        children[i]->update();
    }
    
    
    
    
}

#pragma mark - ofx DRAW

void ofxScrollView::begin() {
    
    if  (debugUI){
        ofSetColor(255,0,0,255);
        ofDrawSphere(getPosition(), 10);
    }
    
    if (!parent) {
        
        // I AM ROOT DO SOME CONFIG
        ofEnableDepthTest();
        ofEnableAlphaBlending();
        
    }
    
    if (!hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        
        ofRectangle d = getDrawFrame();
        
        if (shouldRasterize){
            
            if (!raster.isAllocated()) {
                raster.allocate(myFrame.w, myFrame.h);
            }
            raster.begin();
            
        }
        
        else {
            ofPushMatrix();
            ofMultMatrix( getLocalTransformMatrix() );
        }
        
        if (bgImage.isAllocated() || bgColor[3] > 0) {
            
            ofFill();
            ofSetColorf(bgColor);
            
            ofRect(d.x, d.y, d.width, d.height);
            
            if (bgImage.isAllocated()) {
                
                ofSetColor(255);
                
                bgImage.draw(d.x, d.y, d.width, d.height);
                
            }
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
}

void     ofxScrollView::draw()
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

void ofxScrollView::end() {
    
    
    
    if (!hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        
        ofRectangle d = getDrawFrame();
        
        for(int i = 0; i < children.size(); i++)
        {
            
            setChildFrame(children[i]);
            if (!children[i]->hidden) {
                children[i]->draw();
            }
            
            
        }
        
        if (drawsBorder) {
            ofNoFill();
            
            ofSetColorf(fgColor);
            ofSetLineWidth(2*getScreenScale());
            
            ofRect(d);
        }
        
        
        if (shouldRasterize) {
            
            raster.end();
            
            ofPushMatrix();
            ofMultMatrix( getLocalTransformMatrix() );
            
            raster.draw(d.x, d.y);
            
        }
        
        
        
        if (highlighted) {
            ofEnableBlendMode(OF_BLENDMODE_ADD);
            ofFill();
            ofSetColor(255,255,255,100);
            ofRect(d);
            ofEnableBlendMode(OF_BLENDMODE_ALPHA);
        }
        
        dirty = false;
        fdirty = false;
        
        ofPopMatrix();
        
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
            
            if (getContentSize() > myFrame.h) {
                
                int diff = scrollPosition + getContentSize() - myFrame.h;
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
            
            if (getContentSize() > myFrame.w) {
                
                int diff = scrollPosition + getContentSize() - myFrame.w;
                
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
            
            ofRectangle d = _parent->getDrawFrame();
            
            if (_parent->scrollDirectionVertical && (getY() + myFrame.h/2. < d.y || getY() - myFrame.h/2. > d.y + _parent->getHeight())) {
                return true;
            }
            
            else if (getX() + myFrame.w/2. < d.x || getX() - myFrame.w/2. > d.x + d.width) {
                return true;
            }
            
        }
        
    }
    
    return false;
}

ofVec3f ofxScrollView::getCenter(){
    
    return ofVec3f(getX()-myFrame.w/2., getY()-myFrame.h/2., getZ());
    
}

int  ofxScrollView::getHeight() {
    return myFrame.h;
}

int  ofxScrollView::getWidth() {
    return myFrame.w;
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



void ofxScrollView::setChildFrame(ofxScrollView *v){
    
    if (fdirty) {
        
        
        if (scrollDirectionVertical){
            
            int tempSize = 0;
            for(int i = 0; i < v->referenceId; i++)
            {
                int temp = children[i]->getHeight();
                tempSize += temp + verticalPadding;
            }
            
            float childSize = myFrame.h * v->autoSizePct;
            
            v->setFrame(frame3d((horizontalPadding / 2.),
                                tempSize + scrollPosition + childSize/2. - myFrame.h/2.,
                                1,
                                myFrame.w-(horizontalPadding),
                                childSize
                                ));
            
        }
        
        else {
            
            int tempSize = 0;
            
            for(int i = 0; i < v->referenceId; i++)
            {
                int temp = children[i]->getWidth();
                tempSize += temp + horizontalPadding;
            }
            
            float childSize = myFrame.w * v->autoSizePct;
            
            v->setFrame(frame3d(tempSize + scrollPosition + childSize/2. - myFrame.w/2.,
                                (verticalPadding/2.),
                                1,
                                childSize,
                                myFrame.h - verticalPadding));
        }
        
        
        v->hidden = v->scrollShouldCull();
        
        
    }
    
}

frame3d ofxScrollView::getFrame() {
    
    return frame3d(getPosition(), myFrame.getSize());
    
}

frame3d ofxScrollView::getGlobalFrame() {
    
    return frame3d(getGlobalPosition(), myFrame.getSize());
    
}

ofRectangle ofxScrollView::getDrawFrame(){
    return ofRectangle(-getWidth()/2, -getHeight()/2., getWidth(), getHeight());
}


void ofxScrollView::setFrame(frame3d frame){
    
    if (myFrame.h != frame.h || myFrame.w != frame.w || getZ() != frame.z) { // SCALED, refresh content size
        cdirty = true;
    }

    setPosition(frame.getPosition());
    
    //NSLog(@"moving %f", frame.getPosition().x - myFrame.getPosition().x);
    
    myFrame = frame;
    
    fdirty = true;
    
}




void ofxScrollView::scaleFrame(float scale){
    
    // setScale(scale, scale, scale);
    
    //    if (_scale != scale){
    //
    //        fdirty = true;
    //        cdirty = true;
    //
    //        float dScale = (scale - _scale);
    //
    //        float rScale = 1 + dScale;
    //
    //        myFrame = ofRectangle(0,0,myFrame.w * rScale,myFrame.h * rScale);
    //
    //        setFrame(ofRectangle(myFrame.x, myFrame.y, myFrame.w, myFrame.h));
    //
    //        _xRootOffset = myFrame.x;
    //        _yRootOffset = myFrame.y;
    //
    //        _scale += dScale;
    //
    //        raster.allocate(myFrame.w, myFrame.h);
    //
    //        NSLog(@"new: %f, delta : %f, scale %f",scale, dScale, _scale);
    //
    //    }
    
}

ofRectangle     ofxScrollView::getWorldFrame(){
    
    ofPoint g = getGlobalPosition();
    
    return ofRectangle(g.x - myFrame.w/2.,g.y-myFrame.h/2., myFrame.w, myFrame.h);
    
}

bool     ofxScrollView::containsPoint(int x, int y) //check to see if mouse is within boundaries of object.
{
    
    
    ofRectangle d = getWorldFrame();
    
    float lx = x - ofGetWidth()/2.;
    
    float ly = y - ofGetHeight()/2.;
    
    // NSLog(@"contains point ? %f %f", lx, ly);
    
    bool withinArea = false;
    if ( lx > d.x && lx < d.x + d.width && ly > d.y && ly < d.y + d.height)
    {
        
        //   NSLog(@"in rect %f %f %f %f",d.x-myFrame.w/2.,d.y-myFrame.h/2., myFrame.w, myFrame.h);
        withinArea = true;
    }
    return withinArea;
}

#pragma mark - UI STATE

void ofxScrollView::setHighlighted(bool setHighlighted) {
    
    //if (highlighted != setHighlighted) {
    
    if (children.size()) {
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
    
    // }
    
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
                    children[i]->touchDown(x, y, touchId);
                    hit = false;
                }
                
                else
                {
                    children[i]->setHighlighted(false);
                }
            }
        }
        
        if (hit) {
            setHighlighted(true);
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
                        children[i]->touchDown(x, y, touchId);
                        hit = false;
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
    
    for (int i = 0; i < children.size(); i++ )
    {
        if  (!children[i]->hidden){
            
            if (! children[i]->containsPoint(x,y) == true)
            {
                children[i]->setHighlighted(false);
            }
        }
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
                
                //children[i]->setHighlighted(false);
                
                if ( children[i]->containsPoint(x,y) == true)
                {
                    children[i]->touchUp(x, y, touchId);
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
            else {
                children[i]->setHighlighted(false);
            }
            
        }
        
        
    }
    
    if (hit) {
        setHighlighted(true);
    }
    
    return hit;
    
    
}

bool ofxScrollView::touchDoubleTap(float x, float y, int touchId){
    
    return 1;
    
}



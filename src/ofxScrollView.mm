#include "ofxScrollView.h"
#include "ofxTableView.h"

#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include <Foundation/Foundation.h>

@implementation ScrollViewAction


inline float weightedAverage (float src, float dst, float d){
    
    return src == dst ? src : ((src * (1.-d) + dst * d));
    
}

inline float logAverage (float src, float dst, float d){
    
    return src == dst ? src : ((src * (1.- d*d) + dst * d * d));
    
}


inline frame3d getTweenFrame(frame3d src, frame3d dst, float d){
    
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
    
    action.actionBlock = (ActionBlock)^(float completion){
        
        switch (action.style) {
                
            case TransitionStyleNone:
                
                break;
                
            case TransitionStyleEnterFromRight: case TransitionStyleEnterFromLeft: case TransitionStyleExitToLeft: case TransitionStyleExitToRight:
                
                action.cellRef->setFrame(getTweenFrame(action.sourceFrame, action.destFrame, completion));
                
                break;
                
            case TransitionStyleZoomIn: case TransitionStyleZoomOut:
                
                action.cellRef->setFrame(getTweenFrame(action.sourceFrame, action.destFrame, completion));
                
                break;
                
            case TransitionStyleFade:
                action.cellRef->alpha = weightedAverage(action.srcAlpha, action.dstAlpha, completion);
                
            default:
                break;
        }
        
        if (completion > 1.){
        
            action.cellRef->setFrame(action.destFrame);
            
            if (action.style == TransitionStyleExitToLeft || action.style == TransitionStyleExitToRight || action.style == TransitionStyleZoomIn) {
                action.cellRef->hidden = true;
            }
            
            if (action.style == TransitionStyleEnterFromLeft || action.style == TransitionStyleEnterFromRight || action.style == TransitionStyleZoomOut) {
                if (action.cellRef->_modalChild) {
                    
                    action.cellRef->_modalChild->setOrientation(action.cellRef->_modalChild->cachedOrientation);
                    action.cellRef->_modalChild->setParent(action.cellRef->_modalChild->_parent);
                    
                    action.cellRef->_modalChild->_modalParent = NULL;
                    action.cellRef->_modalChild = NULL;
                    
                    
                    
                }
            }
            
            return 0;
        
        }
        
        return 1;

        NSLog(@"animation compelted after %f seconds", action.progress);
        
    };


return action;

}


@end

ofxScrollView:: ofxScrollView()//constructor
{
    animationHandler = [[NodeAnimationHandler alloc] init];
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
        
        parent->addChild(this);
        
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
    
    action2.sourceFrame = getFrame();
    
    child->hidden = false;
    
    
    switch (style) {
            
        case TransitionStyleNone:
            
            break;
            
        case TransitionStyleExitToLeft:
            
            action2.sourceFrame = frame3d(bounds.x+bounds.width, bounds.y, 0, bounds.width, bounds.height);
            
            action.destFrame = frame3d(bounds.x-bounds.width, bounds.y,getZ(), bounds.width, bounds.height);
            action2.style = TransitionStyleEnterFromRight;
            
            
            child->hidden = false;

            break;
            
        case TransitionStyleExitToRight:
            
            action2.sourceFrame = frame3d(bounds.x-bounds.width, bounds.y, 0, bounds.width, bounds.height);
            
            action.destFrame = frame3d(bounds.x+bounds.width, bounds.y, getZ(), bounds.width, bounds.height);
            action2.style = TransitionStyleEnterFromLeft;

            break;
            
        case TransitionStyleZoomIn:
            
            child->hidden = false;
            
            action2.sourceFrame = frame3d(child->getGlobalPosition(), child->bounds);
            
           // logFrame(frame3d(child->getFrame()));
           // logFrame(frame3d(child->getGlobalPosition(), child->bounds));
            
            _modalChild->cachedFrame = action2.sourceFrame;
            
            action.destFrame = frame3d(getX(), getY(), getZ()+1000, bounds.width,bounds.height);
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
            
            action.destFrame = frame3d(getX()+bounds.width, getY(), getZ(), bounds.width, bounds.height);
            
            action2.style = TransitionStyleExitToRight;
            
            action2.destFrame = frame3d(child->getX()+child->getWidth(), child->getY(), child->getZ(), child->getWidth(), child->getHeight());
            
            hidden=false;
            
            break;
            
        case TransitionStyleEnterFromRight:
            
            action.destFrame = frame3d(getX()-bounds.width, getY(), getZ(), bounds.width, bounds.height);
            
            action2.style = TransitionStyleExitToLeft;
            
            action2.destFrame = frame3d(child->getX()-child->getWidth(), child->getY(), child->getZ(), child->getWidth(), child->getHeight());
            
            hidden=false;
            
            break;
            
        case TransitionStyleZoomOut:
            
            hidden=false;
            
            //_modalChild->cachedFrame = _modalChild->getFrame();
            
            action.destFrame = frame3d(getX(), getY(), 0, bounds.width,bounds.height);
            
            action2.destFrame = _modalChild->cachedFrame;
            
            action2.style = TransitionStyleEnterFromLeft;
            
            break;
            
        default:
            break;
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
    
    [animationHandler updateWithTimeSinceLast:.02];
    
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

    if (!hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        

        ofRectangle d = getDrawFrame();
        
        
        
        if (shouldRasterize){
            
            if (!raster.isAllocated()) {
                raster.allocate(bounds.width, bounds.height);
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
            
            if (getRoot()->_modalChild) {
                if (getRoot()->_modalChild != children[i]) {
                    setChildFrame(children[i]);
                    if (!children[i]->hidden) {
                    children[i]->draw();
                    }
                }
            }
            
            else {
                setChildFrame(children[i]);
                if (!children[i]->hidden) {
                    children[i]->draw();
                }
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
            
            if (getContentSize() > bounds.height) {
                
                int diff = scrollPosition + getContentSize() - bounds.height;
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
            
            if (getContentSize() > bounds.width) {
                
                int diff = scrollPosition + getContentSize() - bounds.width;
                
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
            
            if (_parent->scrollDirectionVertical && (getY() + bounds.height/2. < _parent->getDrawFrame().y || getY() - bounds.height/2. > _parent->getDrawFrame().y + _parent->getHeight())) {
                return true;
            }
            
            else if (getX() + bounds.width < _parent->getDrawFrame().x || getX() > _parent->getDrawFrame().x + _parent->getWidth()) {
                return true;
            }

        }
        
    }
    
    return false;
}

ofVec3f ofxScrollView::getCenter(){

    return ofVec3f(getX()-bounds.width/2., getY()-bounds.height/2., getZ());
    
}

int  ofxScrollView::getHeight() {
    return bounds.height;
}

int  ofxScrollView::getWidth() {
    return bounds.width;
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
            
            float childSize = bounds.height * v->autoSizePct;
            
            v->setFrame(frame3d((horizontalPadding / 2.),
                                -bounds.height/2. + tempSize + scrollPosition + childSize/2.,
                                1,
                                bounds.width-(horizontalPadding),
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
            
            float childSize = bounds.width * v->autoSizePct;
            
            v->setFrame(frame3d(-bounds.width/2. + tempSize + scrollPosition + childSize/2.,
                                (verticalPadding/2.),
                                1,
                                childSize,
                                bounds.height - verticalPadding));
        }
        
        
        v->hidden = v->scrollShouldCull();

        
    }

    
    
    
    
    
}

frame3d ofxScrollView::getFrame() {
    
    return frame3d(getPosition(), bounds);
    
}

frame3d ofxScrollView::getGlobalFrame() {
    
    return frame3d(getGlobalPosition(), bounds);
    
}

ofRectangle ofxScrollView::getDrawFrame(){
    return ofRectangle(-getWidth()/2, -getHeight()/2., getWidth(), getHeight());
}


void ofxScrollView::setFrame(frame3d frame){
    
    if (bounds.height != frame.h || bounds.width != frame.w || getZ() != frame.z) { // SCALED, refresh content size
        cdirty = true;
    }
    
    setPosition(frame.x, frame.y, frame.z);
    
    bounds = frame.getBounds();
    
    fdirty = true;
    
    //setPosition(nbounds.x + nbounds.width/2., nbounds.y+nbounds.height/2, getZ());
    
   

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
//        bounds = ofRectangle(0,0,bounds.width * rScale,bounds.height * rScale);
//        
//        setFrame(ofRectangle(bounds.x, bounds.y, bounds.width, bounds.height));
//        
//        _xRootOffset = bounds.x;
//        _yRootOffset = bounds.y;
//        
//        _scale += dScale;
//        
//        raster.allocate(bounds.width, bounds.height);
//        
//        NSLog(@"new: %f, delta : %f, scale %f",scale, dScale, _scale);
//        
//    }
    
}

ofRectangle     ofxScrollView::getWorldFrame(){
    
    ofPoint g = getGlobalPosition();

    return ofRectangle(g.x - bounds.width/2.,g.y-bounds.height/2., bounds.width, bounds.height);
        
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
        
     //   NSLog(@"in rect %f %f %f %f",d.x-bounds.width/2.,d.y-bounds.height/2., bounds.width, bounds.height);
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



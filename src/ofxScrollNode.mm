//
//  ofxTableNode.m
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/18/14.
//
//

#import "ofxNodeKit.h"

@implementation ofxScrollNode


#pragma ADD Cells




-(instancetype) initWithColor:(UIColor *)color size:(CGSize)size {
    

    self = [super initWithColor:color size:size];
    
    if (self) {

        _sharedFont = new ofTrueTypeFont;
        
        if (!_sharedFont->loadFont(DEFAULT_FONT_STRING, DEFAULT_FONT_SIZE * getScreenScale())){
            
        }
        
        _scrollDirectionVertical = true;
        scrollingEnabled = true;
        verticalPadding = 10;
        _fdirty = true;
        
        self.userInteractionEnabled = true;
        //float nbgColor[4] = {rand()%255/255., rand()%255/255.,rand()%255/255.,1.};
        
//        setBgColor(nbgColor);
//        
//        _xRootOffset = getX();
//        _yRootOffset = getY();
//        
//        xTouchOffset = &_xRootOffset;
//        yTouchOffset = &_yRootOffset;
        
        restitution = 3;
        drag = 1.5;
        
    }
    
    return self;
}

-(instancetype) initWithParent:(ofxScrollNode *)parent autoSizePct:(float)autoSizePct {
    
    if (!parent){
        return nil;
    }
    
    CGSize size;
    if (parent.scrollDirectionVertical) {
        size = CGSizeMake(parent.size.width, parent.size.height*autoSizePct);
    }
    else {
        size = CGSizeMake(parent.size.width*autoSizePct,parent.size.height);
    }
    
    self = [super initWithColor:parent.color size:size];
    
    if (self) {

       
        _autoSizePct = autoSizePct;
        
        horizontalPadding = 20;
        verticalPadding = 20;
        
        
        self.color = [UIColor redColor];
        
        parent->cdirty = true;
        parent.fdirty = true;
        
        restitution = 3;
        drag = 1.5;
        
        [parent addChild:self];
        
        self.userInteractionEnabled = true;
    }

    return self;

}

#pragma DRAW etc.


-(void)setHighlighted:(bool)highlighted {
    
_highlighted = highlighted;
    
//    bool shouldHighlight = true;
//    
//    if (children){
//        if (!_highlighted) {
//            for (ofxNode *child in children) {
//                if ([child isKindOfClass:ofxScrollNode.class]){
//                    shouldHighlight = false;
//                    [(ofxScrollNode*)child setHighlighted:false];
//                }
//            }
// 
//        }
//    }
//    
//    if (shouldHighlight) {
//        NSLog(@"higlighting %d", highlighted);
//        _highlighted = highlighted;
//    }
    
    // }
    
}

#pragma mark - Scroll

-(float)contentSize {
    if (cdirty) {
        
        int tempSize = 0;
        
        for(int i = 0; i < children.count; i++)
        {
            ofxScrollNode *child = children[i];
            
            if (_scrollDirectionVertical) {
                int temp = child.size.height;
                
                tempSize += temp + verticalPadding;
            }
            else {
                int temp = child.size.width;
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

-(float)outOfBounds {

    if (_scrollDirectionVertical) {
        
        if (_scrollPosition > verticalPadding) {
            return _scrollPosition - verticalPadding;
        }
        
        else {
            
            if (self.contentSize > self.size.height) {
                
                int diff = _scrollPosition + self.contentSize - self.size.height;
                if (diff < 0){
                    
                    return diff;
                    
                }
                
            }
            else {
                if (_scrollPosition < verticalPadding) {
                    return _scrollPosition - verticalPadding;
                }
            }
            
        }
        
    }
    
    else {
        
        if (_scrollPosition > horizontalPadding) {
            return _scrollPosition - horizontalPadding;
        }
        
        else {
            
            if (self.contentSize > self.size.width) {
                
                int diff = _scrollPosition + self.contentSize - self.size.width;
                
                if (diff < 0){
                    
                    return diff;
                    
                }
                
            }
            else {
                if (_scrollPosition < horizontalPadding) {
                    return _scrollPosition - horizontalPadding;
                }
            }
            
        }
        
        
    }
    
    return 0;
    
}

-(void) setChildFrame:(ofxScrollNode *)child{
    
    if (_fdirty) {
        
        if (_scrollDirectionVertical){
            
            int tempSize = 0;
            for(int i = 0; i < [children indexOfObject:child]; i++)
            {
                int temp = child.size.height;
                tempSize += temp + verticalPadding;
            }
            
            float childSize = self.size.height * child.autoSizePct;
            
            [child set3dPosition:ofPoint((horizontalPadding / 2.),
                                        tempSize + _scrollPosition + childSize/2. - self.size.height/2.,
                                         1)];
            [child setSize:CGSizeMake(self.size.width-(horizontalPadding),
             childSize)];
            
        }
        
        else {
            
            int tempSize = 0;
            
            for(int i = 0; i < [children indexOfObject:child]; i++)
            {
                int temp = child.size.width;
                tempSize += temp + horizontalPadding;
            }
            
            float childSize = self.size.width * child.autoSizePct;
            
            
            [child set3dPosition:ofPoint(tempSize + _scrollPosition + childSize/2. - self.size.width/2.,
                                         (verticalPadding/2.),
                                         1)];
            
            [child setSize:CGSizeMake(
                                      childSize, self.size.height-(verticalPadding))];
        }
        
        child.hidden = [child scrollShouldCull];
        
        
        
    }
    
}

-(bool)scrollShouldCull {
 
     return false;
    
            ofRectangle d = [self.parent getDrawFrame];
            
            if ([(ofxScrollNode*)self.parent scrollDirectionVertical] && (self.node->getY() + self.size.height/2. < d.y ||
                                                                  self.node->getY() - self.node->getY()/2. > d.y + self.parent.size.height)) {
                return true;
            }
            
            else if (self.node->getX() + self.size.width/2. < d.x || self.node->getX() - self.size.width/2. > d.x + d.width) {
                return true;
            }

   
    
}

-(void)setScrollPosition:(float)scrollPosition {
    [self setScrollPostion:scrollPosition animated:false];
}

-(void)setScrollPostion:(int)offset animated:(bool)animated {
    
    if (_scrollPosition != offset) {
        _scrollPosition = offset;
        _fdirty = true;
    }
    
}

#pragma mark - update / draw

-(void)updateWithTimeSinceLast:(NSTimeInterval)dt {
    
    [super updateWithTimeSinceLast:dt];
    
    if  (scrollingEnabled){
        
        
        if (_scrollPhase != ScrollPhaseNil) {
            
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
        
        if (_scrollPhase == ScrollPhaseEnded) {
            
            drag = 1.04;
            
            if (scrollVel != 0 && !self.outOfBounds) {
                [self setScrollPosition:_scrollPosition + scrollVel];
            }
            
            else {
                _scrollPhase = ScrollPhaseRestitution;
                easeIn = 20;
                easeOut = false;
                //NSLog(@"start restitution");
            }
            
        }
        
        if (_scrollPhase == ScrollPhaseRestitution) {
            
            scrollVel = 0;
            
            if (!easeOut) {
                if (easeIn > 5) easeIn--;
                else easeOut = true;
            }
            else {
                if (easeIn < 20) easeIn++;
            }
            
            float dir = self.outOfBounds;
            
            if (dir != 0) {
                [self setScrollPosition:_scrollPosition - dir / easeIn];
            }
            
            else {
                //NSLog(@"scroll stopped");
                _scrollPhase = ScrollPhaseNil;
            }
            
        }
        
    }
    
    if (scrollingEnabled){
        if (_fdirty || cdirty) {
            for (ofxScrollNode *child in children) {
                [self setChildFrame:child];
                child.fdirty = true;
            }
            
            _fdirty = false;
            cdirty = false;
        }
    }
    
}

-(void)customDraw {
   
    
    if (_highlighted) {
            ofRectangle rect = [self getDrawFrame];
        
            ofSetColor(255,255,255,100);
            ofFill();
            ofRect(rect);
            //ofRect(0, 0, 400, 400);
       // NSLog(@"draw highlight");
        
    }
    
     [super customDraw];
    
}
#pragma mark - Touch Handling

// TOUCH HANDLING

-(bool) touchDown:(CGPoint)location id:(int) touchId
{
    
    //    if (_modalChild){
    //        _modalChild->touchDown(x, y, touchId);
    //        return false;
    //    }
    
    bool hit = true;
    
    if (scrollingEnabled) {
        
        _scrollPhase = ScrollPhaseBegan;
        
        xOrigin = location.x;
        yOrigin = location.y;
        
        counterVel = 0;
        scrollVel = 0;
        
        drag = 1.5;

    }
    
    else {
        
        for (ofxNode *child in children) {
            if  (!child.isHidden){
                if ([child containsPoint:location])
                {
                    [child touchDown:location id:touchId ];
                    hit = false;
                }
                else
                {
                    if ([child isKindOfClass:ofxScrollNode.class]){
                        [(ofxScrollNode*)child setHighlighted:false];
                    }
                }
            }
        }
        
        if (hit) {
            self.highlighted = true;
        }
        
    }
    
    
    
    return hit;
    
}

-(bool)touchMoved:(CGPoint)location id:(int)touchId {

    
//    if (_modalChild){
//        _modalChild->touchMoved(x, y, touchId);
//        return false;
//    }
    
    bool hit = true;
    
    if  (scrollingEnabled) {
        
        int sDt;
        int cDt;
        
        if (_scrollDirectionVertical) {
            sDt = (location.y - yOrigin);
            cDt = (location.x - xOrigin);
        }
        else {
            sDt = (location.x - xOrigin);
            cDt = (location.y - yOrigin);
        }
        
        xOrigin = location.x;
        yOrigin = location.y;
        
        scrollVel += sDt;
        counterVel += cDt;
        
        if (_scrollPhase <= ScrollPhaseBegan){
            
            if (fabs(scrollVel) > fabs(counterVel) + (restitution * 2.)){
                _scrollPhase = ScrollPhaseRecognized;
                NSLog(@"Scroll started %f, %f", scrollVel, counterVel);
                
            }
            
            else if (fabs(counterVel) > fabs(scrollVel) + (restitution)){
                 NSLog(@"FAILED %f, %f", counterVel, scrollVel);
                _scrollPhase = ScrollPhaseBeginFail;
            }
            
        }
        
        else if (_scrollPhase == ScrollPhaseRecognized){
            
            [self setScrollPostion:_scrollPosition + sDt animated:false];

            
        }
        
        else if (_scrollPhase == ScrollPhaseBeginFail) {
            
            for (ofxNode *child in children) {
                if  (!child.isHidden){
                    if ([child containsPoint:location])
                    {
                        [child touchDown:location id:touchId ];
                        hit = false;
                    }
                }
            }
            
            _scrollPhase = ScrollPhaseFailed;
            
        }
        
        else if (_scrollPhase == ScrollPhaseFailed) {
            
            for (ofxNode *child in children) {
                if  (!child.isHidden){
                    if ([child containsPoint:location])
                    {
                        [child touchMoved:location id:touchId ];
                        hit = false;
                    }
                }
            }
            
        }
        
    }
    
    else {
        for (ofxNode *child in children) {
            if  (!child.isHidden){
                if ([child containsPoint:location])
                {
                    [child touchMoved:location id:touchId ];
                    hit = false;
                }
            }
        }
        
    }
    
    return hit;
    
}

-(bool)touchUp:(CGPoint)location id:(int)touchId    {
    
    bool hit = true;
    
//    if (_modalChild){
//        _modalChild->touchUp(x, y, touchId);
//        return 0;
//    }
    
    for (ofxNode *child in children) {
        if  (child.userInteractionEnabled && !child.isHidden){
            if (![child containsPoint:location])
            {
                if ([child isKindOfClass:ofxScrollNode.class]){
                    [(ofxScrollNode*)child setHighlighted:false];
                }
            }
        }
    }
    
    if (scrollingEnabled) {
        
        if (_scrollPhase == ScrollPhaseFailed || _scrollPhase == ScrollPhaseBegan || _scrollPhase == ScrollPhaseNil) {
            
            for (ofxNode *child in children) {
                
                if (child.userInteractionEnabled){
                    
                    
                    if ([child containsPoint:location])
                    {
                        [child touchUp:location id:touchId ];
                        hit = false;
                    }
                    
                    else if ([child isKindOfClass:ofxScrollNode.class]){
                        if ([(ofxScrollNode*)child scrollPhase] != ScrollPhaseNil) [child touchUp:location id:touchId ];
                    }
                }
                
                
            }
            
            _scrollPhase = ScrollPhaseNil;
            
        }
        
        else {
            
            hit = false;
            _scrollPhase = ScrollPhaseEnded;
        }
        
    }
    
    else {
        
        
        for (ofxNode *child in children) {
            
            if  (child.userInteractionEnabled && !child.isHidden){
                
                if ([child containsPoint:location])
                {
                    [child touchUp:location id:touchId ];
                    hit = false;
                }
                else
                {
                    if ([child isKindOfClass:ofxScrollNode.class]){
                        [(ofxScrollNode*)child setHighlighted:false];
                    }
                }
            }
            
        }
        
        
    }
    
    if (hit) {
        NSLog(@"highlight yes!");
        [self setHighlighted:true];
    }
    
    return hit;
    
    
}



@end

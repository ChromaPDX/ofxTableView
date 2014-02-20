//
//  ofxTableNode.m
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/18/14.
//
//

#import "ofxNodeKit.h"

@implementation ofxScrollNode

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
    
 for (ofxNode *child in children) {
     [child updateWithTimeSinceLast:dt];
    }
    
    
    
}

#pragma DRAW etc.


-(void)setHighlighted:(bool)highlighted {
    
    //if (highlighted != setHighlighted) {
    
    if (children){
        if (!_highlighted) {
            for (ofxNode *child in children) {
                if ([child isKindOfClass:ofxScrollNode.class]){
                    [(ofxScrollNode*)child setHighlighted:false];
                }
            }
 
        }
    }
    
    else {
        _highlighted = highlighted;
    }
    
    // }
    
}

#pragma mark - Scroll

-(float)contentSize {
    if (cdirty) {
        
        int tempSize = 0;
        
        for(int i = 0; i < children.count; i++)
        {
            ofxScrollNode *child = children[i];
            
            if (scrollDirectionVertical) {
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

    if (scrollDirectionVertical) {
        
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

-(void)setScrollPosition:(float)scrollPosition {
    [self setScrollPostion:scrollPosition animated:false];
}

-(void)setScrollPostion:(int)offset animated:(bool)animated {
    
    if (_scrollPosition != offset) {
        _scrollPosition = offset;
        fdirty = true;
    }
    
}

#pragma mark - draw 

-(void)draw {
    
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
        
        if (scrollDirectionVertical) {
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
                //NSLog(@"Scroll started %f, %f", scrollVel, counterVel);
                
            }
            
            else if (fabs(counterVel) > fabs(scrollVel) + (restitution)){
                // NSLog(@"FAILED %f, %f", counterVel, scrollVel);
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
    
    NSLog(@"touch up scroll");
    bool hit = true;
    
//    if (_modalChild){
//        _modalChild->touchUp(x, y, touchId);
//        return 0;
//    }
    
    for (ofxNode *child in children) {
        if  (!child.isHidden){
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

                    if ([child containsPoint:location])
                    {
                        [child touchUp:location id:touchId ];
                        hit = false;
                    }
                
                    else if ([child isKindOfClass:ofxScrollNode.class]){
                        if ([(ofxScrollNode*)child scrollPhase] != ScrollPhaseNil) [child touchUp:location id:touchId ];
                    }
                
                
            }
            
            _scrollPhase = ScrollPhaseNil;
            
        }
        
        else {

            // NSLog(@"scroll ended on %s %f", displayName.c_str(), scrollVel);
            
            _scrollPhase = ScrollPhaseEnded;
        }
        
    }
    
    else {
        
        
        for (ofxNode *child in children) {

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
    
    if (hit) {
        [self setHighlighted:true];
    }
    
    return hit;
    
    
}



@end

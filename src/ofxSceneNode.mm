//
//  ofxSceneNode.m
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/17/14.
//
//

#import "ofxSceneNode.h"

@implementation ofxSceneNode

@synthesize hidden;
@synthesize shouldRasterize;
@synthesize blendMode;

-(void) begin {

    if (!self.parent) {
        
        // I AM ROOT DO SOME CONFIG
        ofEnableDepthTest();
        ofEnableAlphaBlending();
        
    }
    
    if (!self.hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        
        ofRectangle d = [self getDrawFrame];
        
        if (shouldRasterize){
            
            if (!fbo) {
                fbo = new ofFbo;
                fbo->allocate(_size.width,_size.height);
            }
            fbo->begin();
            
        }
        
        else {
            ofPushMatrix();
            ofMultMatrix(node.getLocalTransformMatrix() );
        }
        
        if (blendMode) {
            ofEnableBlendMode(blendMode);
        }
        if (_backgroundColor) {
            ofFill();

            ofSetColor(ofColorWithUIColor(_backgroundColor));
                
            ofRect(d);
        }

    }
    
}

-(ofRectangle) getDrawFrame{
    return ofRectangle(_size.width/2, -_size.height/2, _size.width, _size.height);
}

-(void)draw {
    
    for (ofxNode *child in children) {
        
        if (!child.isHidden) {
            [child draw];
        }
        
        
    }
    
}
    


-(void)end {
    
    if (!hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        
        ofRectangle d = [self getDrawFrame];

        if (_borderColor) {
            ofNoFill();
            
            ofSetColor(ofColorWithUIColor(_borderColor));
            
            ofSetLineWidth(2);
            
            ofRect(d);
        }
        
        
        if (shouldRasterize) {
            
            fbo->end();
            dirty = false;
            
        }
        else {
              ofPopMatrix();
        }
        
    }
    
    else if (shouldRasterize && !dirty) {
        
        ofRectangle d = [self getDrawFrame];
        
        ofPushMatrix();
        ofMultMatrix( node.getLocalTransformMatrix() );
        
        fbo->draw(d.x, d.y);
        
        ofPopMatrix();
    }
    
    
}

-(void)dealloc {
    if (fbo) {
        delete fbo;
    }
}

@end

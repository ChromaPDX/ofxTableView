//
//  ofxSceneNode.m
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/17/14.
//
//

#import "ofxNodeKit.h"

@implementation ofxSceneNode


-(instancetype)initWithSize:(CGSize)size {
    self = [super init];
    
    if (self){
        
        self.size = size;
        self.backgroundColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1.];
        self.shouldRasterize = false;
        
        _camera = [[ofxCameraNode alloc] init];
        
        NSLog(@"init scene with size");
        [self logCoords];
        

        
    }
    
    return self;
}

-(void)updateWithTimeSinceLast:(NSTimeInterval)dt {
    
    fps = (int)(1000./dt);
    
    [super updateWithTimeSinceLast:dt];
    [_camera updateWithTimeSinceLast:dt];
    
}
-(void) begin {

    
    if (!self.parent) {
        
        // I AM ROOT DO SOME CONFIG
        ofEnableDepthTest();
        //ofEnableAlphaBlending();
       // ofEnableBlendMode(OF_BLENDMODE_ADD);
        
        ofClear(ofColorWithUIColor(_backgroundColor));
        
        ((ofCamera*)_camera.node)->begin();
    
    }

    if (!self.hidden && (!_shouldRasterize || (_shouldRasterize && dirty)))
    {
        
        ofRectangle d = [self getDrawFrame];
        
        if (_shouldRasterize){
            
            if (!fbo) {
                fbo = new ofFbo;
                fbo->allocate(self.size.width,self.size.height);
            }
            fbo->begin();
            
        }
        
        else {
            ofPushMatrix();
            ofMultMatrix(self.node->getGlobalTransformMatrix());
         //   self.node->transformGL();
            
        }
        
//        if (self.blendMode) {
//            ofEnableBlendMode(self.blendMode);
//        }


    }
    
}

-(void)draw {
    
   
    
    [self begin];
    
    if  (debugUI){
        
        ofRectangle d = [self getDrawFrame];
        
        ofNoFill();
        
        ofSetColor(ofColorWithUIColor([UIColor orangeColor]));
        
        ofSetLineWidth(2);
        
        ofRect(d);
    }
    
    if (_borderColor) {
        
        ofRectangle d = [self getDrawFrame];
        
        ofNoFill();
        
        ofSetColor(ofColorWithUIColor(_borderColor));
        
        ofSetLineWidth(2);
        
        ofRect(d);
    }
    
    for (ofxNode *child in children) {
        if (!child.isHidden) {
            [child draw];
        }
    }
    
    [self end];
    
}
    


-(void)end {
    
    if (!self.isHidden && (!_shouldRasterize || (_shouldRasterize && dirty)))
    {
        
        if (_shouldRasterize) {
            
            if (!self.parent) {
                ((ofCamera*)_camera.node)->end();
            }
            
            fbo->end();
            dirty = false;
            
        }
        
        else {
            ofPopMatrix();
            //self.node->restoreTransformGL();
            
            if (!self.parent) {
                ((ofCamera*)_camera.node)->end();
            }
         
        }
        
    }
    
    else if (_shouldRasterize && !dirty) {
        
        ofRectangle d = [self getDrawFrame];
        
        ofPushMatrix();
        ofMultMatrix( self.node->getLocalTransformMatrix() );
        
        fbo->draw(d.x, d.y);
        
        ofPopMatrix();
    }
    
    if  (debugUI){
        string stats = "nodes :" + ofToString([self numNodes]) + " draws: " + ofToString([self numVisibleNodes]) + " fps: " + ofToString(fps);
        ofDrawBitmapStringHighlight(stats, ofPoint(ofGetWidth() - 230, ofGetHeight()- 7, _camera.get3dPosition.z));
    }
    
    
}


-(bool)touchDown:(CGPoint)location id:(int)touchId {
    // OVERRIDE
    
    CGPoint p = [_camera screenToWorld:location];
    
    for (ofxNode *child in children) {
        
        if ([child containsPoint:p])
        {
            [child touchDown:p id:touchId ];
        }
        
    }
    return 0;
}

-(bool)touchUp:(CGPoint)location id:(int)touchId {
    // OVERRIDE
    
    bool hit = false;
    
    CGPoint p = [_camera screenToWorld:location];
    
    for (ofxNode *child in children) {
        
        if ([child containsPoint:p])
        {
            [child touchUp:p id:touchId ];
            hit = true;
        }

    }
    if (!hit) {
        NSLog(@"touch up scene %f, %f", location.x, location.y);
    }
    
    return hit;
}

-(bool)touchMoved:(CGPoint)location id:(int)touchId {
    // OVERRIDE
    CGPoint p = [_camera screenToWorld:location];
    
    for (ofxNode *child in children) {
        
        if ([child containsPoint:p])
        {
            [child touchMoved:p id:touchId ];
        }
        
    }
    return 0;
}

@end

@implementation ofxCameraNode

-(instancetype)init {
    
    self = [super init];
    if (self){

        self.node = new ofCamera;
        
        animationHandler = [[NodeAnimationHandler alloc]initWithNode:self.node];
        
        // CAMERA init
        
        ((ofCamera*)self.node)->setNearClip(.1);
        ((ofCamera*)self.node)->setFarClip(2000);
        
        ((ofCamera*)self.node)->setPosition(0., 0., 1000);
        //((ofCamera*)self.node)->setAspectRatio(9./16.);
    }
    return self;
}

-(CGPoint)screenToWorld:(CGPoint)p {
    ofVec3f p2 = ((ofCamera*)self.node)->screenToWorld(ofVec3f(p.x, p.y, 0));
    //NSLog(@"screen i: %f %f o:%f %f", p.x, p.y, p2.x * 5000, p2.y * 5000);
    return CGPointMake(p2.x * 5000, p2.y * 5000);
}

@end

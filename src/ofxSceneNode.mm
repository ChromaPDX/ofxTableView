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
        self.anchorPoint = CGPointMake(.5, .5);
        self.backgroundColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:0];
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
        ofEnableAlphaBlending();
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
            ofMultMatrix(self.node->getLocalTransformMatrix());
            
        }
        
        if (self.blendMode) {
            ofEnableBlendMode(self.blendMode);
        }
        if (_backgroundColor) {
            ofFill();

            ofSetColor(ofColorWithUIColor(_backgroundColor));
                
            ofRect(d);
        }

    }
    
}

-(void)draw {
    
    [self begin];
    
    if  (debugUI){
        ofSetColor(255,0,0,255);
        ofDrawSphere(self.node->getPosition(), 10);
        
        ofRectangle d = [self getDrawFrame];
        
        ofNoFill();
        
        ofSetColor(ofColorWithUIColor([UIColor orangeColor]));
        
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

        if (_borderColor) {
            
            ofRectangle d = [self getDrawFrame];
            
            ofNoFill();
            
            ofSetColor(ofColorWithUIColor(_borderColor));
            
            ofSetLineWidth(2);
            
            ofRect(d);
        }
        
        if  (debugUI){
            
            ofDisableDepthTest();
            string stats = "nodes :" + ofToString(children.count) + " fps: " + ofToString(fps);
            
            ofRectangle d = [self getDrawFrame];
            ofDrawBitmapStringHighlight(stats, (d.x + d.width) - 135, (d.y + d.height) - 7);
            ofDisableDepthTest();
        }
        
        
        if (_shouldRasterize) {
            
            fbo->end();
            dirty = false;
            
        }
        
        else {
            ((ofCamera*)_camera.node)->end();
              ofPopMatrix();
        }
        
    }
    
    else if (_shouldRasterize && !dirty) {
        
        ofRectangle d = [self getDrawFrame];
        
        ofPushMatrix();
        ofMultMatrix( self.node->getLocalTransformMatrix() );
        
        fbo->draw(d.x, d.y);
        
        ofPopMatrix();
    }
    
    
}

-(void)dealloc {
    if (fbo) {
        delete fbo;
    }
}


-(bool)touchDown:(CGPoint)location id:(int)touchId {
    // OVERRIDE
    for (ofxNode *child in children) {
        
        if ([child containsPoint:location])
        {
            [child touchDown:location id:touchId ];
        }
        
    }
    return 0;
}

-(bool)touchUp:(CGPoint)location id:(int)touchId {
    // OVERRIDE
    
    bool hit = false;
    
    for (ofxNode *child in children) {
        
        if ([child containsPoint:location])
        {
            [child touchUp:location id:touchId ];
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
    for (ofxNode *child in children) {
        
        if ([child containsPoint:location])
        {
            [child touchMoved:location id:touchId ];
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
        
        ((ofCamera*)self.node)->setPosition(0, 0., 1000);
        
    }
    return self;
}

@end

//
//  ofxMeshNode.m
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/20/14.
//
//

#import "ofxNodeKit.h"

@implementation ofxPrimitiveNode

-(instancetype) initWith3dPrimitive:(of3dPrimitive*)primitive fillColor:(UIColor*)color{
    
    self = [super init];
    
    if (self) {
        self.node = primitive;
        animationHandler.node = self.node;
        _fillColor = color;
    }
    
    return self;
}

-(void)customDraw {
    if (_fillColor){
        ofSetColor(ofColorWithUIColor(_fillColor));
        ofGetCurrentRenderer()->draw(*((of3dPrimitive *)self.node), OF_MESH_FILL);
    }
    
    if (_wireFrameColor) {
        ofSetColor(ofColorWithUIColor(_wireFrameColor));
        ofGetCurrentRenderer()->draw(*((of3dPrimitive *)self.node), OF_MESH_WIREFRAME);
    }
}

@end

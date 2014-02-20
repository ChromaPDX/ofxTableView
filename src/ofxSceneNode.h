//
//  ofxSceneNode.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/17/14.
//
//

#import "ofxNode.h"

@class ofxCameraNode;

@interface ofxSceneNode : ofxNode

{
    int fps;
    
}

@property (nonatomic) BOOL shouldRasterize;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIColor *borderColor;
@property (nonatomic, strong) ofxCameraNode *camera;

-(instancetype) initWithSize:(CGSize)size;


@end

@interface ofxCameraNode : ofxNode

@end
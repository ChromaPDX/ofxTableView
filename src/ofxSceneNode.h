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

- (void)draw;
// encompasses 3 states
-(void)begin;
-(void)customDraw;
-(void)end;

@end

@interface ofxCameraNode : ofxNode

-(CGPoint)screenToWorld:(CGPoint)p;

@end
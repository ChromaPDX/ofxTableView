//
//  ofxMeshNode.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/20/14.
//
//

#import "ofxNode.h"

@interface ofxPrimitiveNode : ofxNode

-(instancetype) initWith3dPrimitive:(of3dPrimitive*)primitive fillColor:(UIColor*)color;

@property (nonatomic) UIColor* wireFrameColor;
@property (nonatomic) UIColor* fillColor;

@end

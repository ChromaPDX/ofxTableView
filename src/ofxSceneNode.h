//
//  ofxSceneNode.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/17/14.
//
//

#import "ofxNode.h"

@interface ofxSceneNode : ofxNode

@property (nonatomic) BOOL shouldRasterize;
@property (nonatomic) CGSize size;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIColor *borderColor;


@end

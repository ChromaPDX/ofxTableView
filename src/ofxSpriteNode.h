//
//  ofxGameNode.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/13/14.
//
//

#import "ofxNode.h"

@interface ofxSpriteNode : ofxNode

@property (nonatomic) ofPlanePrimitive spriteNode;

// INIT

+ (instancetype)spriteNodeWithTexture:(ofTexture)texture size:(CGSize)size;
+ (instancetype)spriteNodeWithTexture:(ofTexture)texture;
+ (instancetype)spriteNodeWithImageNamed:(NSString *)name;
+ (instancetype)spriteNodeWithColor:(ofColor)color size:(CGSize)size;

- (instancetype)initWithTexture:(ofTexture)texture color:(ofColor)color size:(CGSize)size;
- (instancetype)initWithTexture:(ofTexture)texture;
- (instancetype)initWithImageNamed:(NSString *)name;
- (instancetype)initWithColor:(ofColor)color size:(CGSize)size;

// ACTIONS



@property (nonatomic) ofTexture texture;
@property (nonatomic) ofRectangle centerRect;
@property (nonatomic) float colorBlendFactor;
@property (nonatomic) ofColor color;
@property (nonatomic) ofPoint anchorPoint;
@property (nonatomic) CGSize size;

@end

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

+ (instancetype)spriteNodeWithTexture:(ofTexture*)texture size:(CGSize)size;
+ (instancetype)spriteNodeWithTexture:(ofTexture*)texture;
+ (instancetype)spriteNodeWithImageNamed:(NSString *)name;
+ (instancetype)spriteNodeWithColor:(UIColor *)color size:(CGSize)size;

- (instancetype)initWithTexture:(ofTexture*)texture color:(UIColor *)color size:(CGSize)size;
- (instancetype)initWithTexture:(ofTexture*)texture;
- (instancetype)initWithImageNamed:(NSString *)name;
- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size;

// ACTIONS



@property (nonatomic) ofTexture *texture;
@property (nonatomic) ofRectangle centerRect;
@property (nonatomic) float colorBlendFactor;
@property (nonatomic) UIColor* color;


@end

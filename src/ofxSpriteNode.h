//
//  ofxGameNode.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/13/14.
//
//

#import <Foundation/Foundation.h>
#import "ofMain.h"

@class NodeAnimationHandler;

@interface ofxSpriteNode : NSObject

@property (nonatomic) ofPlanePrimitive sprite;
@property (nonatomic, strong) NodeAnimationHandler *animationHandler;

+ (instancetype)spriteNodeWithTexture:(ofTexture)texture size:(CGSize)size;
+ (instancetype)spriteNodeWithTexture:(ofTexture)texture;
+ (instancetype)spriteNodeWithImageNamed:(NSString *)name;
+ (instancetype)spriteNodeWithColor:(ofColor)color size:(CGSize)size;

- (instancetype)initWithTexture:(ofTexture)texture color:(ofColor)color size:(CGSize)size;
- (instancetype)initWithTexture:(ofTexture)texture;
- (instancetype)initWithImageNamed:(NSString *)name;
- (instancetype)initWithColor:(ofColor)color size:(CGSize)size;

@property (nonatomic) ofTexture texture;
@property (nonatomic) ofRectangle centerRect;
@property (nonatomic) float colorBlendFactor;
@property (nonatomic) ofColor color;
@property (nonatomic) ofBlendMode blendMode;
@property (nonatomic) ofPoint anchorPoint;
@property (nonatomic) CGSize size;

@end

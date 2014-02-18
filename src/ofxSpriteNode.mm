//
//  ofxGameNode.m
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/13/14.
//
//

#import "ofxSpriteNode.h"
#import "ofxNodeAnimationHandler.h"

@implementation ofxSpriteNode

+ (instancetype)spriteNodeWithTexture:(ofTexture)texture size:(CGSize)size {
    ofxSpriteNode *node = [[ofxSpriteNode alloc] initWithTexture:texture color:ofColor(255) size:size];
    return node;
}

+ (instancetype)spriteNodeWithTexture:(ofTexture)texture {
    ofxSpriteNode *node = [[ofxSpriteNode alloc] initWithTexture:texture];
    return node;
}

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name {
    ofxSpriteNode *node = [[ofxSpriteNode alloc] initWithImageNamed:name];
    return node;
}

+ (instancetype)spriteNodeWithColor:(ofColor)color size:(CGSize)size {
    ofxSpriteNode *node = [[ofxSpriteNode alloc] initWithColor:color size:size];
    return node;
}

- (instancetype)initWithTexture:(ofTexture)texture color:(ofColor)color size:(CGSize)size {
    self = [super init];
    if (self) {
        _texture = texture;
        animationHandler = [[NodeAnimationHandler alloc] init];
        _size = size;
        _color = color;
    }
    return self;
}

- (instancetype)initWithTexture:(ofTexture)texture {
    return [self initWithTexture:texture color:ofColor(255) size:CGSizeMake(texture.getWidth(),texture.getHeight())];
}

- (instancetype)initWithImageNamed:(NSString *)name {
    ofImage image;
    image.loadImage(string(name.cString));

    self = [self initWithTexture:image.getTextureReference() color:ofColor(255) size:CGSizeMake(image.getWidth(),image.getHeight())];
    return self;
}

- (instancetype)initWithColor:(ofColor)color size:(CGSize)size {
    return [self initWithTexture:ofTexture() color:color size:CGSizeMake(_texture.getWidth(),_texture.getHeight())];
}

// DRAW

- (void)updateWithTimeSinceLast:(NSTimeInterval) dt {
    
}

-(void)draw {

}

@end

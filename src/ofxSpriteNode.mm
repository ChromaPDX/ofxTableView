//
//  ofxGameNode.m
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/13/14.
//
//

#import "ofxNodeKit.h"

@implementation ofxSpriteNode

+ (instancetype)spriteNodeWithTexture:(ofTexture*)texture size:(CGSize)size {
    ofxSpriteNode *node = [[ofxSpriteNode alloc] initWithTexture:texture color:[UIColor colorWithWhite:1. alpha:1.] size:size];
    return node;
}

+ (instancetype)spriteNodeWithTexture:(ofTexture*)texture {
    ofxSpriteNode *node = [[ofxSpriteNode alloc] initWithTexture:texture];
    return node;
}

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name {
    ofxSpriteNode *node = [[ofxSpriteNode alloc] initWithImageNamed:name];
    return node;
}

+ (instancetype)spriteNodeWithColor:(UIColor*)color size:(CGSize)size {
    ofxSpriteNode *node = [[ofxSpriteNode alloc] initWithColor:color size:size];
    return node;
}

- (instancetype)initWithTexture:(ofTexture*)texture color:(UIColor*)color size:(CGSize)size {
    
    self = [super init];
    
    if (self) {
        _texture = texture;
        self.size = size;
        _color = color;
    }
    return self;
}

- (instancetype)initWithTexture:(ofTexture*)texture {
    return [self initWithTexture:texture color:[UIColor colorWithWhite:1. alpha:1.] size:CGSizeMake(texture->getWidth(),texture->getHeight())];
}

- (instancetype)initWithImageNamed:(NSString *)name {
    ofImage image;
    image.loadImage(string(name.cString));

    return [self initWithTexture:&image.getTextureReference() color:[UIColor colorWithWhite:1. alpha:1.] size:CGSizeMake(image.getWidth(),image.getHeight())];
}

- (instancetype)initWithColor:(UIColor*)color size:(CGSize)size {
    return [self initWithTexture:nil color:color size:size];
}

// DRAW

- (void)updateWithTimeSinceLast:(NSTimeInterval) dt {
    [super updateWithTimeSinceLast:dt];
}

-(void)customDraw {

    ofRectangle rect = [self getDrawFrame];
    
    if (_color) {
        ofSetColor(ofColorWithUIColor(_color));
        ofFill();
        ofRect(rect);
    }
    
}

-(void)dealloc {
    delete _texture;
}

@end

//
//  ofxNode.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/17/14.
//
//

#import <Foundation/Foundation.h>
#import "ofMain.h"

@class NodeAction;
@class NodeAnimationHandler;
@class ofxSceneNode;

static inline ofColor ofColorWithUIColor(UIColor* color){
    float c[4];
    [color getRed:&c[0] green:&c[1] blue:&c[2] alpha:&c[3]];
    return ofColor(c[0]*255, c[1]*255, c[2]*255, c[3]*255);
}



@interface ofxNode : NSObject
{
    NSMutableArray *children;
    NSMutableSet *touches;
    // of internals

    ofFbo *fbo;
    bool dirty;
    
    NodeAnimationHandler *animationHandler;
    
}

@property (nonatomic) ofNode *node;


@property (nonatomic) bool userInteractionEnabled;

- (instancetype) init;
- (void)updateWithTimeSinceLast:(NSTimeInterval) dt;

- (void)draw;
// encompasses 3 states
-(void)begin;
-(void)customDraw;
-(void)end;

-(int)numVisibleNodes;
-(int)numNodes;

@property (nonatomic) ofBlendMode blendMode;
// WISH LIST TO FOLLOW

///**
// Controls whether or not the node's actions is updated or paused.
// */
@property (nonatomic, getter = isPaused) BOOL paused;
//
///**
// Controls whether or not the node and its children are rendered.
// */
@property (nonatomic, getter = isHidden) BOOL hidden;
//
///**
// Controls whether or not the node receives touch events
// */
//@property(getter=isUserInteractionEnabled) BOOL userInteractionEnabled;
//
///**
// The parent of the node.
// 
// If this is nil the node has not been added to another group and is thus the root node of its own graph.
// */
@property (nonatomic, readonly) ofxNode *parent;
//
//
///**
// The children of this node.
// 
// */
//@property (nonatomic, readonly) NSArray *children;
//
//
///**
// The client assignable name.
// 
// In general, this should be unique among peers in the scene graph.
// */
//@property (nonatomic, copy) NSString *name;
//
///**
// The scene that the node is currently in.
// */
@property (nonatomic, weak) ofxSceneNode* scene;
//
//@property (nonatomic, retain) SKPhysicsBody *physicsBody;
//
///**
// An optional dictionary that can be used to hold user data pretaining to the node. Defaults to nil.
// */
//@property (nonatomic, retain) NSMutableDictionary *userData;
//
///**
// Sets both the x & y scale
// 
// @param scale the uniform scale to set.
// */
//- (void)setScale:(CGFloat)scale;
//
///**
// Adds a node as a child node of this node
// 
// The added node must not have a parent.
// 
// @param node the child node to add.
// */
- (void)addChild:(ofxNode *)node;
//
- (void)insertChild:(ofxNode *)node atIndex:(NSInteger)index;
//
- (void)removeChildrenInArray:(NSArray *)nodes;
- (void)removeAllChildren;
//
- (void)removeFromParent;


// ofNode Position / Rotation

- (void)setPosition:(CGPoint)position;
- (void)set3dPosition:(ofPoint)position;

- (CGPoint)getPosition;
- (ofPoint)get3dPosition;


//
//- (ofxNode *)childNodeWithName:(NSString *)name;
//- (void)enumerateChildNodesWithName:(NSString *)name usingBlock:(void (^)(ofxNode *node, BOOL *stop))block;
//
///* Returns true if the specified parent is in this node's chain of parents */
//
//- (BOOL)inParentHierarchy:(ofxNode *)parent;
//
- (void)runAction:(NodeAction *)action;
- (void)runAction:(NodeAction *)action completion:(void (^)())block;
//- (void)runAction:(SKAction *)action withKey:(NSString *)key;
//
//- (BOOL)hasActions;
//- (SKAction *)actionForKey:(NSString *)key;
//
//- (void)removeActionForKey:(NSString *)key;
//- (void)removeAllActions;
//
//- (BOOL)containsPoint:(CGPoint)p;
//- (ofxNode *)nodeAtPoint:(CGPoint)p;
//- (NSArray *)nodesAtPoint:(CGPoint)p;
//
//- (CGPoint)convertPoint:(CGPoint)point fromNode:(ofxNode *)node;
//- (CGPoint)convertPoint:(CGPoint)point toNode:(ofxNode *)node;
//
///* Returns true if the bounds of this node intersects with the transformed bounds of the other node, otherwise false */
//
//- (BOOL)intersectsNode:(ofxNode *)node;

#pragma mark - GEOMETRTY

-(bool)containsPoint:(CGPoint) location;

@property (nonatomic) CGSize size;
@property (nonatomic) ofPoint anchorPoint;

-(ofRectangle)getDrawFrame;

#pragma mark - TOUCH

-(bool) touchDown:(CGPoint)location id:(int) touchId;
-(bool) touchMoved:(CGPoint)location id:(int) touchId;
-(bool) touchUp:(CGPoint)location id:(int) touchId;


// UTIL

-(void)logCoords;

@end


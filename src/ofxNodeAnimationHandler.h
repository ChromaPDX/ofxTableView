//
//  ofxNodeAnimationHandler.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/11/14.
//
//



#import <Foundation/Foundation.h>
#include "ofMain.h"

@class NodeAction;

typedef NS_ENUM(NSInteger, NodeActionTimingMode) {
    NodeActionTimingLinear,
    NodeActionTimingEaseIn,
    NodeActionTimingEaseOut,
    NodeActionTimingEaseInEaseOut
} NS_ENUM_AVAILABLE(10_9, 7_0);

//typedef bool (^ActionBlock)(NodeAction *action, float completion);
typedef bool (^ActionBlock)(float completion);

@interface NodeAction : NSObject

@property (nonatomic) ofNode *node;

@property (nonatomic) NodeActionTimingMode timingMode;
@property (nonatomic) CGFloat speed;
@property (nonatomic, copy) ActionBlock actionBlock;
@property (nonatomic, copy) void (^completionBlock)(void);
@property (nonatomic) NSTimeInterval progress;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSInteger repeats;
@property (nonatomic) bool serial;

@property (nonatomic, weak) NodeAction *parentAction;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSMutableArray *actions;

- (NodeAction *)reversedAction;

- (void) runCompletion;

- (bool)updateWithTimeSinceLast:(NSTimeInterval) dt;

// WISH LIST

//+ (NodeAction *)moveByX:(CGFloat)deltaX y:(CGFloat)deltaY duration:(NSTimeInterval)sec;
//
//+ (NodeAction *)moveByX:(CGFloat)deltaX y:(CGFloat)deltaY duration:(NSTimeInterval)sec;
//+ (NodeAction *)moveBy:(CGVector)delta duration:(NSTimeInterval)sec;
//+ (NodeAction *)moveTo:(CGPoint)location duration:(NSTimeInterval)sec;
//+ (NodeAction *)moveToX:(CGFloat)x duration:(NSTimeInterval)sec;
//+ (NodeAction *)moveToY:(CGFloat)y duration:(NSTimeInterval)sec;
//
//+ (NodeAction *)rotateByAngle:(CGFloat)radians duration:(NSTimeInterval)sec;
//+ (NodeAction *)rotateToAngle:(CGFloat)radians duration:(NSTimeInterval)sec;
//+ (NodeAction *)rotateToAngle:(CGFloat)radians duration:(NSTimeInterval)sec shortestUnitArc:(BOOL)shortestUnitArc;
//
//+ (NodeAction *)resizeByWidth:(CGFloat)width height:(CGFloat)height duration:(NSTimeInterval)duration;
//+ (NodeAction *)resizeToWidth:(CGFloat)width height:(CGFloat)height duration:(NSTimeInterval)duration;
//
//+ (NodeAction *)resizeToWidth:(CGFloat)width duration:(NSTimeInterval)duration;
//+ (NodeAction *)resizeToHeight:(CGFloat)height duration:(NSTimeInterval)duration;
//
//+ (NodeAction *)scaleBy:(CGFloat)scale duration:(NSTimeInterval)sec;
//+ (NodeAction *)scaleXBy:(CGFloat)xScale y:(CGFloat)yScale duration:(NSTimeInterval)sec;
//+ (NodeAction *)scaleTo:(CGFloat)scale duration:(NSTimeInterval)sec;
//+ (NodeAction *)scaleXTo:(CGFloat)xScale y:(CGFloat)yScale duration:(NSTimeInterval)sec;
//+ (NodeAction *)scaleXTo:(CGFloat)scale duration:(NSTimeInterval)sec;
//+ (NodeAction *)scaleYTo:(CGFloat)scale duration:(NSTimeInterval)sec;

+ (NodeAction *)sequence:(NSArray *)actions;

+ (NodeAction *)group:(NSArray *)actions;


//+ (NodeAction *)repeatAction:(NodeAction *)action count:(NSUInteger)count;
//+ (NodeAction *)repeatActionForever:(NodeAction *)action;
//
//+ (NodeAction *)fadeInWithDuration:(NSTimeInterval)sec;
//+ (NodeAction *)fadeOutWithDuration:(NSTimeInterval)sec;
//+ (NodeAction *)fadeAlphaBy:(CGFloat)factor duration:(NSTimeInterval)sec;
//+ (NodeAction *)fadeAlphaTo:(CGFloat)alpha duration:(NSTimeInterval)sec;
//
//+ (NodeAction *)setTexture:(ofTexture *)texture;
//+ (NodeAction *)animateWithTextures:(NSArray *)textures timePerFrame:(NSTimeInterval)sec;
//+ (NodeAction *)animateWithTextures:(NSArray *)textures timePerFrame:(NSTimeInterval)sec resize:(BOOL)resize restore:(BOOL)restore;
//
///* name must be the name or path of a file of a platform supported audio file format. Use a LinearPCM format audio file with 8 or 16 bits per channel for best performance */
//+ (NodeAction *)playSoundFileNamed:(NSString*)soundFile waitForCompletion:(BOOL)wait;
//
//+ (NodeAction *)colorizeWithColor:(UIColor *)color colorBlendFactor:(CGFloat)colorBlendFactor duration:(NSTimeInterval)sec;
//+ (NodeAction *)colorizeWithColorBlendFactor:(CGFloat)colorBlendFactor duration:(NSTimeInterval)sec;
//
//+ (NodeAction *)followPath:(CGPathRef)path duration:(NSTimeInterval)sec;
//+ (NodeAction *)followPath:(CGPathRef)path asOffset:(BOOL)offset orientToPath:(BOOL)orient duration:(NSTimeInterval)sec;
//
//+ (NodeAction *)speedBy:(CGFloat)speed duration:(NSTimeInterval)sec;
//+ (NodeAction *)speedTo:(CGFloat)speed duration:(NSTimeInterval)sec;
//
//+ (NodeAction *)waitForDuration:(NSTimeInterval)sec;
//+ (NodeAction *)waitForDuration:(NSTimeInterval)sec withRange:(NSTimeInterval)durationRange;
//
//+ (NodeAction *)removeFromParent;
//
//+ (NodeAction *)performSelector:(SEL)selector onTarget:(id)target;
//
//+ (NodeAction *)runBlock:(dispatch_block_t)block;
//+ (NodeAction *)runBlock:(dispatch_block_t)block queue:(dispatch_queue_t)queue;
//
//+ (NodeAction *)runAction:(NodeAction *)action onChildWithName:(NSString*)name;
//
//+ (NodeAction *)customActionWithDuration:(NSTimeInterval)seconds actionBlock:(void (^)(ofNode *node, NSTimeInterval dt))block;

@end


@interface NodeActionGroup : NSArray
@end


@interface NodeAnimationHandler : NSObject

{
    
    NSMutableArray *actions;


}

@property (nonatomic) ofNode *node;

- (instancetype) initWithNode:(ofNode*)node;

- (void)updateWithTimeSinceLast:(NSTimeInterval) dt;

- (void)runAction:(NodeAction *)action;
- (void)runAction:(NodeAction *)action completion:(void (^)())block;
- (void)runAction:(NodeAction *)action withKey:(NSString *)key;

- (BOOL)hasActions;
- (NodeAction *)actionForKey:(NSString *)key;

- (void)removeActionForKey:(NSString *)key;
- (void)removeAllActions;

@end


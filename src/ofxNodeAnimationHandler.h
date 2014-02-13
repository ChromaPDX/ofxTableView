/***********************************************************************
 * Written by Leif Shackelford
 * Copyright (c) 2014 Chroma Games
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Chroma Games nor the names of its contributors
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ***********************************************************************/


#import <Foundation/Foundation.h>
#include "ofMain.h"

@class NodeAction;

typedef NS_ENUM(NSInteger, NodeActionTimingMode) {
    NodeActionTimingLinear,
    NodeActionTimingEaseIn,
    NodeActionTimingEaseOut,
    NodeActionTimingEaseInEaseOut
} NS_ENUM_AVAILABLE(10_9, 7_0);

inline float weightedAverage (float src, float dst, float d);
static inline float logAverage (float src, float dst, float d);
static inline ofPoint getTweenPoint(ofPoint src, ofPoint dst, float d);

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

@property (nonatomic) ofPoint startPos;
@property (nonatomic) ofPoint endPos;

@property (nonatomic) bool reset;


- (NodeAction *)reversedAction;

- (void) runCompletion;

- (bool)updateWithTimeSinceLast:(NSTimeInterval) dt;

// WISH LIST

+ (NodeAction *)moveByX:(CGFloat)deltaX y:(CGFloat)deltaY duration:(NSTimeInterval)sec;
+ (NodeAction *)moveBy:(CGVector)delta duration:(NSTimeInterval)sec;

+ (NodeAction *)moveToX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)sec;

+ (NodeAction *)moveTo:(CGPoint)location duration:(NSTimeInterval)sec;
+ (NodeAction *)moveToX:(CGFloat)x duration:(NSTimeInterval)sec;
+ (NodeAction *)moveToY:(CGFloat)y duration:(NSTimeInterval)sec;
//
+ (NodeAction *)rotateByAngle:(CGFloat)radians duration:(NSTimeInterval)sec;
+ (NodeAction *)rotateToAngle:(CGFloat)radians duration:(NSTimeInterval)sec;
+ (NodeAction *)rotateToAngle:(CGFloat)radians duration:(NSTimeInterval)sec shortestUnitArc:(BOOL)shortestUnitArc;
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


+ (NodeAction *)repeatAction:(NodeAction *)action count:(NSUInteger)count;
+ (NodeAction *)repeatActionForever:(NodeAction *)action;
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


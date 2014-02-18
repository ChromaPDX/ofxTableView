//
//  ofxNode.m
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/17/14.
//
//

#import "ofxNode.h"
#import "ofxNodeAnimationHandler.h"

@implementation ofxNode

#pragma mark - Node Hierarchy

- (void)addChild:(ofxNode *)node {
    [children addObject:node];
}

- (void)insertChild:(ofxNode *)node atIndex:(NSInteger)index{
    [children insertObject:node atIndex:index];
}

- (void)removeChildrenInArray:(NSArray *)nodes{
    [children removeObjectsInArray:nodes];
}

- (void)removeAllChildren{
    [children removeAllObjects];
}

- (void)removeFromParent{
    [_parent removeChildrenInArray:@[self]];
}

#pragma mark - Actions

- (void)runAction:(NodeAction*)action {
    [animationHandler runAction:action];
}
- (void)runAction:(NodeAction *)action completion:(void (^)())block {
    [animationHandler runAction:action completion:block];
}

#pragma mark - UPDATE / DRAW

- (void)updateWithTimeSinceLast:(NSTimeInterval) dt {
    // OVERRIDE, CALL SUPER
    
}



-(void)draw {
    // OVERRIDE THIS
}

-(void)baseDraw {
    [self begin];
    [self draw];
    [self end];
}

-(void)begin {
    // OVERRIDE
    if  (debugUI){
        ofSetColor(255,0,0,255);
        ofDrawSphere(node.getPosition(), 10);
    }
}
-(void)end {
    
}
@end

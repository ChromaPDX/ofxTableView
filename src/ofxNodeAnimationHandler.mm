//
//  ofxBlockAnimationHandler.cpp
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/11/14.
//
//

#import "ofxNodeAnimationHandler.h"

@implementation NodeAction

-(instancetype) init {
    
    self = [super init];
    if(self){
        _progress = 0;
        _speed = 1.;
        _repeats = 0;
    }
    return self;
}

+ (NodeAction *)group:(NSArray *)actions {
    
    NodeAction * action = [[NodeAction alloc] init];
    action.children = [actions mutableCopy];
    return action;
    
}

+ (NodeAction *)sequence:(NSArray *)actions {
    
    NodeAction * action = [NodeAction group:actions];
    action.serial = true;
    return action;
    
}

+ (NodeAction *)moveByX:(CGFloat)deltaX y:(CGFloat)deltaY duration:(NSTimeInterval)sec {
    
    NodeAction * action = [[NodeAction alloc] init];
    return action;
    
}

- (bool)updateWithTimeSinceLast:(NSTimeInterval) dt{
    
    _progress += dt;
    float completion = _progress / _duration;
  //  __weak NodeAction *weakSelf = self;
    
    if (_actionBlock){
        NSLog(@"running block %f", completion);
        //return _actionBlock(weakSelf, completion);
        return _actionBlock(completion);
    }
    
    return 1;
}

- (void)runCompletion {
    if (_completionBlock){
        _completionBlock();
    }
}


@end


@implementation NodeAnimationHandler

- (instancetype) initWithNode:(ofNode*)node {
    
    self = [super init];
    
    if (self){
    
        _node = node;
        actions = [[NSMutableArray alloc]init];
        
    }
    
    return self;
    
}



- (void)updateWithTimeSinceLast:(NSTimeInterval) dt{
    
    if (actions.count) {
        [self executeAction:actions[0] dt:dt];
    }
    
}

-(void)executeAction:(NodeAction *)action dt:(NSTimeInterval) dt{
    
    if (action.children) { // GROUPS
        if (action.children.count) {
            if (action.serial) {
                [self executeAction:action.actions[0] dt:dt];
            }
            
            else { // paralell
                for (NodeAction* ac in action.children) {
                    [self executeAction:ac dt:dt];
                }
            }
        }
    }
    
    else {
        
        bool complete = [action updateWithTimeSinceLast:dt];
        
        if (complete){
            if (action.repeats == 0) {
                [action runCompletion];
                [action.parentAction.actions removeObject:action];
            }
            
            else if (action.repeats > 0){
                action.repeats -= 1;
                action.actions = [action.children mutableCopy];
            }
        }
        
    }
    
}

- (void)runAction:(NodeAction *)action {
    
    action.node = _node;
    [actions addObject:action];
    
}

- (void)runAction:(NodeAction *)action repeat:(int)repeats {
    
    if (repeats != 0) action.repeats = repeats;
    else action.repeats = -1;
    [self runAction:action];
    
}

- (void)runAction:(NodeAction *)action completion:(void (^)())block {
    
    action.completionBlock = block;
    [self runAction:action];
    
}

- (void)runAction:(NodeAction *)action withKey:(NSString *)key {
    
    
}

- (BOOL)hasActions {
    return actions.count;
}

@end

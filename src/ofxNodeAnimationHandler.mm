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
        
    }
    return self;
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
    
    if (actions.count){
        NSLog(@"has actions");
        bool complete = [(NodeAction*)(actions[0]) updateWithTimeSinceLast:dt];
        if (complete){
            [actions[0] runCompletion];
            [actions removeObject:actions[0]];
        }
    }
    
}

- (void)runAction:(NodeAction *)action {
    
    action.node = _node;
    [actions addObject:action];
    
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

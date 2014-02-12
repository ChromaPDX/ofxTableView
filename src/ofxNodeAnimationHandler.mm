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
    if (_actionBlock){
        return _actionBlock(dt);
    }
    return 0;
}

- (void)runCompletion {
    if (_completionBlock){
        _completionBlock();
    }
}


@end


@implementation NodeAnimationHandler

- (instancetype) init {
    
    self = [super init];
    
    if (self){
    
        actions = [[NSMutableArray alloc]init];
        
    }
    
    return self;
    
}

- (void)updateWithTimeSinceLast:(NSTimeInterval) dt{
    
    if (actions.count){
        if (![(NodeAction*)actions[0] updateWithTimeSinceLast:dt]){
            [actions[0] runCompletion];
            [actions removeObject:actions[0]];
        }
    }
    
}

- (void)runAction:(NodeAction *)action {
    
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

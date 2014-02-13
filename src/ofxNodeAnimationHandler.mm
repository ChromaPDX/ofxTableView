//
//  ofxBlockAnimationHandler.cpp
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/11/14.
//
//

#import "ofxNodeAnimationHandler.h"

@implementation NodeAction

inline float weightedAverage (float src, float dst, float d){
    
    return src == dst ? src : ((src * (1.-d) + dst * d));
    
}

static inline float logAverage (float src, float dst, float d){
    
    return src == dst ? src : ((src * (1.- d*d) + dst * d * d));
    
}

static inline ofPoint getTweenPoint(ofPoint src, ofPoint dst, float d){
    return ofPoint(weightedAverage(src.x, dst.x, d),
                   weightedAverage(src.y, dst.y, d),
                   weightedAverage(src.z, dst.z, d));
}

-(instancetype) initWithDuration:(NSTimeInterval)duration {
    
    self = [super init];
    if(self){
        _progress = 0;
        _speed = 1.;
        _repeats = 0;
        _duration = duration;
    }
    return self;
}

#pragma mark - INIT / REMOVE / GROUP

-(void)removeAction:(NodeAction*)action {
    
    if (_actions.count) {
        
        [_actions removeObject:action];
        
        
        if (!_actions.count) {
            
            [self complete];
            
        }
        
    }
    
}

-(void)complete {
    
    if (_repeats == 0) {
        
        if (_completionBlock) {
            _completionBlock();
        }
        
        [_parentAction removeAction:self];
        
    }
    
    else if (_repeats > 0){
        _repeats -= 1;
        
        if (_children.count) {
            _actions = [_children mutableCopy];
            for (NodeAction *c in _actions) {
                c.reset = true;
            }
        }
    }
    
}

+ (NodeAction *)group:(NSArray *)actions {
    
    NodeAction * action = [[NodeAction alloc] init];
    action.children = [actions mutableCopy];
    
    for (NodeAction *a in action.children) {
        a.parentAction = action;
    }
    
    return action;
    
}

+ (NodeAction *)sequence:(NSArray *)actions {
    
    NodeAction * action = [NodeAction group:actions];
    action.serial = true;
    return action;
    
}

+ (NodeAction *)repeatAction:(NodeAction *)action count:(NSUInteger)count{
    
    action.repeats = count;
    return action;
    
}

+ (NodeAction *)repeatActionForever:(NodeAction *)action {
    action.repeats = -1;
    return action;
}


#pragma mark - MOVE

+ (NodeAction *)moveByX:(CGFloat)deltaX y:(CGFloat)deltaY duration:(NSTimeInterval)sec {
    
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(float completion){
        
        if (action.reset) {
            action.startPos = action.node->getPosition();
            ofPoint p = action.node->getPosition();
            action.endPos = ofPoint(p.x + deltaX, p.y+deltaY, p.z);
            action.reset = false;
        }
        
        action.node->setPosition(getTweenPoint(action.startPos, action.endPos, completion));
        
    };
    
    return action;
    
}

+ (NodeAction *)moveBy:(CGVector)delta duration:(NSTimeInterval)sec {
    
    return [NodeAction moveByX:delta.dx y:delta.dy duration:sec];
    
}

+ (NodeAction *)moveToX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)sec {
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(float completion){
        
        if (action.reset) {
            action.startPos = action.node->getPosition();
            ofPoint p = action.node->getPosition();
            action.endPos = ofPoint(x, y, p.z);
            action.reset = false;
        }
        
        action.node->setPosition(getTweenPoint(action.startPos, action.endPos, completion));
        
    };
    
    return action;
}

+ (NodeAction *)moveTo:(CGPoint)location duration:(NSTimeInterval)sec {
    
    return [NodeAction moveToX:location.x y:location.y duration:sec];
    
}

+ (NodeAction *)moveToX:(CGFloat)x duration:(NSTimeInterval)sec {
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(float completion){
        
        if (action.reset) {
            action.startPos = action.node->getPosition();
            ofPoint p = action.node->getPosition();
            action.endPos = ofPoint(x, p.y, p.z);
            action.reset = false;
        }
        
        action.node->setPosition(getTweenPoint(action.startPos, action.endPos, completion));
        
    };
    
    return action;
}

+ (NodeAction *)moveToY:(CGFloat)y duration:(NSTimeInterval)sec {
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(float completion){
        
        if (action.reset) {
            action.startPos = action.node->getPosition();
            ofPoint p = action.node->getPosition();
            action.endPos = ofPoint(p.x, y, p.z);
            action.reset = false;
        }
        
        action.node->setPosition(getTweenPoint(action.startPos, action.endPos, completion));
        
    };
    
    return action;
    
}


#pragma mark - ROTATE

+(NodeAction *)rotateByAngle:(CGFloat)radians duration:(NSTimeInterval)sec {
    
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(float completion){
        
        if (action.reset) {
            ofPoint p = action.node->getOrientationEuler();
            action.startPos = p;
            action.endPos = ofPoint(p.x, p.y, p.z + radians);
            action.reset = false;
        }
        
        action.node->setOrientation(getTweenPoint(action.startPos, action.endPos, completion));
        
    };
    
    return action;
    
}

+ (NodeAction *)rotateToAngle:(CGFloat)radians duration:(NSTimeInterval)sec {
    
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(float completion){
        
        if (action.reset) {
            ofPoint p = action.node->getOrientationEuler();
            action.startPos = p;
            action.endPos = ofPoint(p.x, p.y, radians);
            action.reset = false;
        }
        
        action.node->setOrientation(getTweenPoint(action.startPos, action.endPos, completion));
        
    };
    
    return action;
    
}

#pragma mark - UPDATE

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
            
            [action complete];
            
        }
        
    }
    
}

-(void)removeAction:(NodeAction*)action {
    
    if (actions.count) {
        
        [actions removeObject:action];
        
    }
    
}

- (void)runAction:(NodeAction *)action { // MASTER
    
    action.node = _node;
    action.parentAction = (NodeAction*)self;
    action.reset = true;
    
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

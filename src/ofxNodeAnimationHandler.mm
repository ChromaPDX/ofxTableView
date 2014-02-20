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
        _duration = duration * 1000;
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

-(void)sharedReset {

    _progress = 0;
    _reset = true;
    
    if (_children.count) {
        _actions = [_children mutableCopy];
        for (NodeAction *c in _actions) {
            [c sharedReset];
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
    
    else {
        
        [self sharedReset];
            if (_repeats > 0){
                _repeats -= 1;
        }
    }
    
}

+ (NodeAction *)group:(NSArray *)actions {
    
    NodeAction * action = [[NodeAction alloc] init];
    
    action.children = [actions mutableCopy];
    
    for (NodeAction *a in action.children) {
        a.parentAction = action;
        a.reset = true;
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


#pragma mark - MOVE BY

+ (NodeAction *)moveByX:(CGFloat)deltaX y:(CGFloat)deltaY duration:(NSTimeInterval)sec {
    
    return [NodeAction move3dByX:deltaX Y:deltaY Z:0 duration:sec];
    
}

+ (NodeAction *)moveBy:(CGVector)delta duration:(NSTimeInterval)sec {
    
    return [NodeAction moveByX:delta.dx y:delta.dy duration:sec];
    
}

+ (NodeAction *)move3dBy:(ofVec3f)delta duration:(NSTimeInterval)sec {
    
    return [NodeAction move3dByX:delta.x Y:delta.y Z:delta.z duration:sec];
    
}

+ (NodeAction *)move3dByX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z duration:(NSTimeInterval)sec {
    
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(ofNode *node, float completion){
        
        if (action.reset) {
            action.startPos = action.node->getPosition();
            ofPoint p = action.node->getPosition();
            action.endPos = ofPoint(p.x + x, p.y+y, p.z + z);
            action.reset = false;
        }

        action.node->setPosition(getTweenPoint(action.startPos, action.endPos, completion));
        
    };
    
    return action;
    
}

#pragma mark - MOVE TO

+ (NodeAction *)moveToX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)sec {
    
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(ofNode *node, float completion){
        
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
    
    action.actionBlock = (ActionBlock)^(ofNode *node, float completion){
        
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
    
    action.actionBlock = (ActionBlock)^(ofNode *node, float completion){
        
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

+(NodeAction *)rotate3dByAngle:(ofVec3f)angles duration:(NSTimeInterval)sec {
    
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(ofNode *node, float completion){
        
        if (action.reset) {
            action.reset = false;
            ofQuaternion start = action.node->getOrientationQuat();
            action.startOrientation = start;
            ofQuaternion xRot = ofQuaternion(angles.x, ofVec3f(1,0,0));
            ofQuaternion yRot = ofQuaternion(angles.y, ofVec3f(0,1,0));
            ofQuaternion zRot = ofQuaternion(angles.z, ofVec3f(0,0,1));
            action.endOrientation = start*xRot*yRot*zRot;
        }
        
        ofQuaternion x;
        x.slerp(completion, action.startOrientation, action.endOrientation);
        action.node->setOrientation(x);
        
        
    };
    
    return action;
    
}

+(NodeAction *)rotateXByAngle:(CGFloat)radians duration:(NSTimeInterval)sec {
    
    return [NodeAction rotateAxis:ofVec3f(1,0,0) byAngle:radians duration:sec];
    
}

+(NodeAction *)rotateYByAngle:(CGFloat)radians duration:(NSTimeInterval)sec {
    
    return [NodeAction rotateAxis:ofVec3f(0,1,0) byAngle:radians duration:sec];
    
}


+(NodeAction *)rotateByAngle:(CGFloat)radians duration:(NSTimeInterval)sec {
    
    return [NodeAction rotateAxis:ofVec3f(0,0,1) byAngle:radians duration:sec];
    
}

+(NodeAction *)rotateAxis:(ofVec3f)axis byAngle:(CGFloat)radians duration:(NSTimeInterval)sec {
    
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(ofNode *node, float completion){
        
        if (action.reset) {
            action.reset = false;
            ofQuaternion start = action.node->getOrientationQuat();
            action.startOrientation = start;
            ofQuaternion rot = ofQuaternion(radians, axis);
            action.endOrientation = start*rot;
        }
        
        ofQuaternion x;
        x.slerp(completion, action.startOrientation, action.endOrientation);
        action.node->setOrientation(x);
        
        
    };
    
    return action;
    
}

+ (NodeAction *)rotateToAngle:(CGFloat)radians duration:(NSTimeInterval)sec {
    
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(ofNode *node, float completion){
        
        if (action.reset) {

            action.reset = false;
            ofQuaternion start = action.node->getOrientationQuat();
            action.startOrientation = start;
            ofQuaternion zRot = ofQuaternion(radians, ofVec3f(0,0,1));
            action.endOrientation = zRot;

        }
        
        ofQuaternion x;
        x.slerp(completion, action.startOrientation, action.endOrientation);
        action.node->setOrientation(x);
        
    };
    
    return action;
    
}

#pragma mark - SCALE

+(NodeAction *)scaleBy:(CGFloat)scale duration:(NSTimeInterval)sec {
    
    NodeAction * action = [[NodeAction alloc] initWithDuration:sec];
    
    action.actionBlock = (ActionBlock)^(ofNode *node, float completion){
        
        if (action.reset) {
            action.reset = false;
            action.startPos = node->getScale();
            action.endPos = ofPoint(action.startPos.x * scale, action.startPos.y * scale, action.startPos.z * scale);
        }
        
      
        action.node->setScale(getTweenPoint(action.startPos, action.endPos, completion));
        
    };
    
    return action;
    
}


#pragma mark - CUSTOM ACTIONS

+(NodeAction*)customActionWithDuration:(NSTimeInterval)seconds actionBlock:(void (^)(ofNode *, CGFloat))block {
    
    NodeAction * action = [[NodeAction alloc] initWithDuration:seconds];
    
    action.actionBlock = block;
    
    return action;
    
    
}

#pragma mark - UPDATE

- (bool)updateWithTimeSinceLast:(NSTimeInterval) dt{

    float completion = _progress / _duration;
    
    if (completion < 1.) {
        
        if (_actionBlock){
            _actionBlock(_node, completion);
        }
        
        _progress += dt;
        
        return 0;
        
    }
    else {
        _actionBlock(_node, 1);
        return 1;
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
            
            if (action.reset) {
                action.actions = [action.children mutableCopy];
                
                for (NodeAction *a in action.actions) {
                    a.reset = true;
                    a.node = _node;
                }
                
                action.reset = false;
                
            }
            
            if (action.serial) {
                [self executeAction:action.actions[0] dt:dt];
            }
            
            else { // parallel
                for (NodeAction* ac in action.children) {
                    [self executeAction:ac dt:dt];
                }
            }
            
            if (!action.actions.count) {
                [action complete];
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
    
    [action sharedReset];
    
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

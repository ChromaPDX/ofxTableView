//
//  ofxNode.m
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/17/14.
//
//

#import "ofxNodeKit.h"

@implementation ofxNode
@synthesize node;

#pragma mark - init

-(instancetype)init {
    self = [super init];
    if (self){
        node = new ofNode;
        
        _anchorPoint = ofPoint(.5, .5, 0);
        _hidden = false;
        _size = CGSizeMake(2, 2);
        
        animationHandler = [[NodeAnimationHandler alloc]initWithNode:node];
        
        _userInteractionEnabled = false;
    }
    return self;
}

#pragma mark - Node Hierarchy

- (void)addChild:(ofxNode *)child {
    
    if (!children) {
        children = [[NSMutableArray alloc]init];
    }

    [children addObject:child];
    [child setParent:self];
    [child set3dPosition:ofPoint(0,0,3)];
    
}

-(int)numNodes {
    
    int count = 0;
    
    for (ofxNode* child in children) {
        count += [child numNodes];
        count++;
    }
    
    return count;
    
}

-(int)numVisibleNodes {
    
    int count = 0;
    
    for (ofxNode* child in children) {
        if (!child.isHidden) {
            count += [child numVisibleNodes];
            count++;
        }
    }
    
    return count;
    
}

-(void)setParent:(ofxNode *)parent {
    
    if (!parent.parent){
        _scene = (ofxSceneNode*)parent;
    }
    else {
        _scene = parent.scene;
    }
    
    _parent = parent;
    
    node->setParent(*parent.node);
}

- (void)insertChild:(ofxNode *)child atIndex:(NSInteger)index{
    if (!children) {
        children = [[NSMutableArray alloc]init];
    }
    [children insertObject:child atIndex:index];
}

- (void)removeChildrenInArray:(NSArray *)nodes{
    NSMutableArray *childMut = [children mutableCopy];
    [childMut removeObjectsInArray:nodes];
    children = childMut;
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
    // IF OVERRIDE, CALL SUPER
    
    [animationHandler updateWithTimeSinceLast:dt];
    
    for (ofxNode *child in children) {
        [child updateWithTimeSinceLast:dt];
    }
}


-(void)begin {
   ofPushMatrix();
    ofMultMatrix(self.node->getLocalTransformMatrix());
   
    for (ofxNode *child in children) {
        if (!child.isHidden) {
            [child draw];
        }
    }
}

-(void)draw {
    [self begin];

    [self customDraw];

    [self end];
}

-(void)customDraw {
    if (debugUI) {
        ofSetColor(255,0,0,255);
        ofDrawSphere(node->getPosition(), 10);
    }
}

-(void)end {
    

    
    ofPopMatrix();
}

#pragma mark - GEOMETRY

-(bool)containsPoint:(CGPoint)location {
    
    CGPoint p = location;
    
    //NSLog(@"world coords: %f %f %f", p.x, p.y, p.z);
    
    ofRectangle d = [self getWorldFrame];
    
    //bool withinArea = false;
    if ( p.x > d.x && p.x < d.x + d.width && p.y > d.y && p.y < d.y + d.height)
    {
       // [self logCoords];
        return true;
    }
    return false;
    
}

-(ofRectangle)getWorldFrame{
    ofPoint g = node->getGlobalPosition();
    return ofRectangle(g.x - _size.width * _anchorPoint.x, g.y - _size.height *_anchorPoint.y, _size.width, _size.height);
}


-(ofRectangle)getDrawFrame {
    //[self logCoords];
    //ofPoint g = node->getPosition();
    //return ofRectangle(g.x - _size.width * _anchorPoint.x, g.y - _size.height *_anchorPoint.y, _size.width, _size.height);
    return ofRectangle(-_size.width * _anchorPoint.x, -_size.height *_anchorPoint.y, _size.width, _size.height);
}

-(void)logCoords{
    ofPoint p = node->getPosition();
    NSLog(@"node pos %f, %f, %f :: size %f %f", p.x, p.y, p.z, _size.width, _size.height);
}


-(void)setPosition:(CGPoint)position {
    [self set3dPosition:ofPoint(position.x, position.y, node->getZ())];
}
                              
-(void)set3dPosition:(ofPoint)position {
    node->setPosition(position);
}

-(ofPoint)get3dPosition {
    return node->getPosition();
}

-(CGPoint)getPosition {
    ofPoint p = node->getPosition();
    return CGPointMake(p.x, p.y);
}
                              
#pragma mark - TOUCH

-(bool)touchDown:(CGPoint)location id:(int)touchId {
    // OVERRIDE
    return 0;
}

-(bool)touchUp:(CGPoint)location id:(int)touchId {
    // OVERRIDE
    return 0;
}

-(bool)touchMoved:(CGPoint)location id:(int)touchId {
    // OVERRIDE
    return 0;
}

-(void)dealloc {
    delete node;
    delete fbo;
}

@end

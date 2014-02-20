#include "nodeTest.h"


// HERE IS AN EXAMPLE SUBCLASS OF A TABLE VIEW CELL


//--------------------------------------------------------------

void nodeTest::setup(){
    lastTime = CFAbsoluteTimeGetCurrent();
    
    scene = [[ofxSceneNode alloc]initWithSize:CGSizeMake(ofGetWidth(), ofGetHeight())];
    
    [scene setPosition:CGPointMake(0, 0)];
    
    
    ofxScrollNode *table = [[ofxScrollNode alloc] initWithColor:nil size:scene.size];
    
    [scene addChild:table];

    for (int i = 0; i < 4; i++){
        ofxScrollNode *cell = [[ofxScrollNode alloc] initWithParent:table autoSizePct:.25];
        cell.color = [UIColor colorWithRed:0. green:0.8 blue:0.8 alpha:.1];
        
        ofxNode *pivot = [[ofxNode alloc]init];
        
        [cell addChild:pivot];
        
        [pivot runAction:[NodeAction repeatActionForever:[NodeAction rotate3dByAngle:ofVec3f(0,90,0) duration:1.]]];
        
//        ofxSpriteNode *label = [[ofxSpriteNode alloc]initWithColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:.8] size:CGSizeMake(cell.size.width, cell.size.height/2.)];
//        [pivot addChild:label];
//        ofxSpriteNode *label2 = [[ofxSpriteNode alloc]initWithColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:.8] size:CGSizeMake(cell.size.width, cell.size.height/2.)];
//        [pivot addChild:label2];
//        [label2 runAction:[NodeAction rotate3dByAngle:ofVec3f(45,0,0) duration:0]];
//        
//       
//        [label runAction:[NodeAction repeatActionForever:[NodeAction rotate3dByAngle:ofVec3f(90,0,0) duration:.2]]];
//        [label2 runAction:[NodeAction repeatActionForever:[NodeAction rotate3dByAngle:ofVec3f(85,0,0) duration:.2]]];
//
//        ofxPrimitiveNode *sphere = [[ofxPrimitiveNode alloc]initWith3dPrimitive:new ofSpherePrimitive(100,10) fillColor:nil];
//        sphere.wireFrameColor = [UIColor colorWithRed:1. green:.5 blue:2. alpha:.4];
//        
//        [label2 addChild:sphere];
//        
//        [sphere runAction:[NodeAction repeatActionForever:[NodeAction sequence:@[[NodeAction moveByX:cell.size.width*.5 y:0 duration:.5],
//                                                                                 [NodeAction moveByX:-cell.size.width y:0 duration:1.],
//                                                                                 [NodeAction moveByX:cell.size.width*.5 y:0 duration:.5]
//                                                                                 ]]]];
        
    }
    
    setupCM();
   

}

void nodeTest::setupCM(){
 
    lastAttitude = ofMatrix3x3(1,0,0,  0,1,0,  0,0,1);
    
    if (!motionManager) {
        
        motionManager = [[CMMotionManager alloc] init];
        
        ofLogNotice("CORE_MOTION") << "INIT CORE MOTION";
    }
    if (motionManager){
        
        if(motionManager.isDeviceMotionAvailable){
            
            ofLogNotice("CORE_MOTION") << "MOTION MANAGER IS AVAILABLE";
            
            motionManager.deviceMotionUpdateInterval = 1.0/45.0;
            
            [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
                
                CMRotationMatrix a = deviceMotion.attitude.rotationMatrix;
                
                attitude =
                ofMatrix3x3(a.m11, a.m21, a.m31,
                            a.m12, a.m22, a.m32,
                            a.m13, a.m23, a.m33);
                
                normalized = attitude * lastAttitude;  // results in the identity matrix plus perturbations between polling cycles
                //correctNormalization();  // if near 0 or 1, force into 0 and 1
                
                //agent.updateOrientation(attitude, normalized);  // send data to game controller
                CMQuaternion cm = deviceMotion.attitude.quaternion;
                
                lastAttitude = attitude;   // store last polling cycle to compare next time around
                lastAttitude.transpose(); //getInverse(attitude);  // transpose is the same as inverse for orthogonal matrices. and much easier
                
                //ofVec3f euler = ofVec3f(deviceMotion.attitude.pitch, deviceMotion.attitude.yaw, deviceMotion.attitude.roll);
                
                scene.node->setOrientation(ofQuaternion(cm.x*-1., cm.y*.0, cm.z*0, cm.w));
                
                
                //scene.node->setOrientation(euler);
                
            }];
        }
    }
    else {
        ofLogError("MOTION NOT AVAILABLE");
    }
    
}
//--------------------------------------------------------------
void nodeTest::update(){
    ofxPrimitiveNode *sphere = [[ofxPrimitiveNode alloc]initWith3dPrimitive:new ofSpherePrimitive(100,10) fillColor:nil];
    
    sphere.wireFrameColor = [UIColor colorWithRed:1. green:.5 blue:rand()%100 / 100. alpha:.4];
    
    [scene addChild:sphere];
    

    [sphere runAction:[NodeAction group:@[[NodeAction move3dBy:ofVec3f(rand()%2000 - 1000, rand()%2000 - 1000, rand()%1000+500) duration:rand()%1000/1000.],
                                          [NodeAction rotateYByAngle:90 duration:1.]
                                          ]
                                        ]
                                        completion:^{
        [sphere removeFromParent];
    }];

    
    int dt = (CFAbsoluteTimeGetCurrent() - lastTime) * 1000.;
    [scene updateWithTimeSinceLast:dt];
    lastTime = CFAbsoluteTimeGetCurrent();
    
}

//--------------------------------------------------------------
void nodeTest::draw(){

    [scene draw];

}

//--------------------------------------------------------------
void nodeTest::exit(){
    
}

//--------------------------------------------------------------
void nodeTest::touchDown(ofTouchEventArgs & touch){
    [scene touchDown:CGPointMake(touch.x, touch.y) id:touch.id];
}

//--------------------------------------------------------------
void nodeTest::touchMoved(ofTouchEventArgs & touch){
    [scene touchMoved:CGPointMake(touch.x, touch.y) id:touch.id];
}

//--------------------------------------------------------------
void nodeTest::touchUp(ofTouchEventArgs & touch){
    [scene touchUp:CGPointMake(touch.x, touch.y) id:touch.id];
}

//--------------------------------------------------------------
void nodeTest::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void nodeTest::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void nodeTest::lostFocus(){
    
}

//--------------------------------------------------------------
void nodeTest::gotFocus(){
    
}

//--------------------------------------------------------------
void nodeTest::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void nodeTest::deviceOrientationChanged(int newOrientation){
    
}

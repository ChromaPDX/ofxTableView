#include "nodeTest.h"


// HERE IS AN EXAMPLE SUBCLASS OF A TABLE VIEW CELL


//--------------------------------------------------------------

void nodeTest::setup(){
    lastTime = CFAbsoluteTimeGetCurrent();

    scene = [[ofxSceneNode alloc]initWithSize:CGSizeMake(ofGetWidth()-100, ofGetHeight()-100)];
    
    [scene setPosition:CGPointMake(0, 0)];
    
    [scene runAction:[NodeAction repeatActionForever:[NodeAction sequence:@[[NodeAction moveByX:25 y:25 duration:.5],
                                                                            [NodeAction moveByX:-50 y:-50 duration:1.],
                                                                            [NodeAction moveByX:25 y:25 duration:.5]
                                                                            ]]]];
    
    [scene.camera runAction:[NodeAction repeatActionForever:[NodeAction rotateByAngle:20 duration:1.]]];

//    ofxScrollNode *table = [[ofxScrollNode alloc] initWithSize:scene.size];
//    
//    [scene addChild:table];
    
}


//--------------------------------------------------------------
void nodeTest::update(){
    
    if (dir){
        if (rot < 30) rot+=.1; else dir=0;
    }
    else {
        if (rot > -30) rot-=.1; else dir=1;
    }

    spin < 360 ? spin ++ : spin = 0;

    int dt = (CFAbsoluteTimeGetCurrent() - lastTime) * 1000.;
    [scene updateWithTimeSinceLast:dt];
    lastTime = CFAbsoluteTimeGetCurrent();
    
}

//--------------------------------------------------------------
void nodeTest::draw(){
    
 //   ofPushMatrix();
    
//    ofTranslate(ofGetWidth()/2., ofGetHeight()/2.);
//    glRotatef(rot, 0, 1, 0);

    [scene draw];
    
//    ofPopMatrix();
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

#include "testApp.h"
#include "ofxTableView.h"

class myCustomCell : public ofxTableViewCell {
    
public:
    
    float xspin = 0;
    
    void draw(ofRectangle rect){
        
        ofxScrollView::draw(rect);
        
        ofPushMatrix();
        
        ofTranslate(rect.x + rect.width/2., rect.y + rect.height/2.);
        
        ofRotate(xspin, 1, 0, 0);
        
        ofDrawCone(0,0, rect.height/2., rect.height);
        
        ofPopMatrix();
    }
    
    void update(){
        NSLog(@"spin %f", xspin);
        xspin < 360 ? xspin++ : xspin = 0;
    }
    
};


// VARIABLES

ofxTableViewController *vc;
ofxTableView *tbv;
myCustomCell myCell;
float rot;
float spin;

//--------------------------------------------------------------
void testApp::setup(){	

    
    vc = new ofxTableViewController;
    
    tbv = vc->addTableView(0,0,ofGetWidth(),ofGetHeight());
    
    tbv->setFgColor(ofColor(0,100,10,255));
    tbv->setBgColor(ofColor(0,100,200,100));
    
    for (int i = 0; i < 10; i++){
        
        tbv->addCell(ofxTableViewCellStyleText, .125);
        
        ofxTableViewCell *scroller = tbv->addCell(ofxTableViewCellStyleScroll, .25);
        
        for (int i = 0; i < random()%20 + 1; i++) {
            ofxTableViewCell *picture = scroller->addCell(ofxTableViewCellStylePicture, .25);
            
            picture->setBgColor(ofColor(random()%255,random()%255,random()%255,200 ));
            
            
        }
        
        myCustomCell *newCell = new myCustomCell;
        
        newCell->initWithParent(scroller, ofxTableViewCellStyleCustom, .5);
        
        newCell->setBgColor(ofColor(0,0,0,255));
        
        scroller->addChild(newCell);
        
        
        for (int i = 0; i < random()%20 + 1; i++) {
            ofxTableViewCell *picture = scroller->addCell(ofxTableViewCellStylePicture, .25);
            
            picture->setBgColor(ofColor(random()%255,random()%255,random()%255,200 ));
            
            
        }

        
    }

    
}

//--------------------------------------------------------------
void testApp::update(){
    
    vc->update();
    
}

//--------------------------------------------------------------
void testApp::draw(){
	
    vc->draw();
    
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

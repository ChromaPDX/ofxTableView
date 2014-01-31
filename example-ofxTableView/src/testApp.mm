#include "testApp.h"

class myCustomCell : public ofxTableViewCell {
    
public:
    
    float xspin = 0;
    
    void draw(){
        
            ofxScrollView::begin();
            
            ofSetColorf(fgColor);
            
            ofFill();
            ofDrawCone(0,0, getWidth()/2., getHeight());
            
            float stroke[4] = {0,0,0,.8};
            
            ofSetColorf(stroke);
            ofNoFill();
            
            ofDrawCone(0,0, getWidth()/2., getHeight());
        
            
            ofxScrollView::end();

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
int dir;

//--------------------------------------------------------------
void testApp::setup(){	


    glEnable(GL_DEPTH_TEST);
    
    
    vc = new ofxTableViewController;
    
    tbv = vc->addTableView(frame3d(0,0,0,ofGetWidth(), ofGetHeight()));
    
    tbv->delegate = this;
    
    tbv->setFgColor(ofColor(255));
    tbv->setBgColor(ofColor(0,100,200,100));
    

    
    ofxTableViewCell *scroller = tbv->addCell(ofxTableViewCellStyleScroll, .25);
    
    ofxTableViewCell *image = scroller->addCell(ofxTableViewCellStylePicture, .5);
    
    image->setImageFromDisk("Icon@2x.png");
    
    ofxTableViewCell *header = scroller->addCell(ofxTableViewCellStyleText, .5);
    
    header->setString(string("HELLO !!!"));

    
    for (int i = 0; i < 10; i++){
        
        float scale = random() %2 + 1;
        
        if (scale > 1){
        ofxTableViewCell *text = tbv->addCell(ofxTableViewCellStyleText, .125);
        text->setString("OFX TABLE VIEW !!!");
        }
        
        ofxTableViewCell *scroller = tbv->addCell(ofxTableViewCellStyleScroll, .25 * scale);
        
        for (int i = 0; i < random()%20 + 1; i++) {
            
            ofxTableViewCell *picture = scroller->addCell(ofxTableViewCellStylePicture, .25 * scale);
            
            picture->setBgColor(ofColor(random()%255,random()%255,random()%255,200 ));
            
            picture->setImageFromDisk("Icon@2x.png");
            
            myCustomCell *newCell = new myCustomCell;
            
            
            scroller->addCustomCell(newCell, .33);
            
            newCell->drawsBorder = false;
            
            
        }

        
    }

    
}

void testApp::cellWasSelected(ofxTableViewCell *cell){
    
    ofLogNotice("tableView") << "selected section: " + ofToString(cell->getIndexPath()[0]) + " index: " + ofToString(cell->getIndexPath()[1]);
    
}

//--------------------------------------------------------------
void testApp::update(){
    
    if (dir){
        if (rot < 30) rot+=.1; else dir=0;
    }
    else {
        if (rot > -30) rot-=.1; else dir=1;
    }
    
    
    
    spin < 360 ? spin ++ : spin = 0;
   
    
    vc->update();
    
}

//--------------------------------------------------------------
void testApp::draw(){
    ofPushMatrix();
    
        ofTranslate(ofGetWidth()/2., ofGetHeight()/2.);
        glRotatef(rot, 0, 1, 0);
    
    vc->draw();
    
    ofPopMatrix();
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

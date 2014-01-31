#include "testApp.h"


// HERE IS AN EXAMPLE SUBCLASS OF A TABLE VIEW CELL

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

//--------------------------------------------------------------
void testApp::setup(){	

    
    // INIT VIEW CONTROLLER, HANDLES TOUCHES
    
    vc = new ofxTableViewController;
    
    // add a tableview
    
    tbv = vc->addTableView();  // or vc->addTableView(x,y,z,w,h);
    
    // SET testApp as Delegate to receive cell callbacks
    
    tbv->delegate = this;
    
    // SET color scheme, root draws bg color, cells inherit fgcolor
    
    tbv->setFgColor(ofColor(255));
    tbv->setBgColor(ofColor(0,100,200,100));
    
    // CELLS
    
    // 1 // SIMPLE HEADER
    
    ofxTableViewCell *header = tbv->addCell(ofxTableViewCellStyleText, .125);
    header->setString("ofxTableView Header");
    
    // 2 // CONTAINER CELL FOR HORIZONTAL SPLIT
    
    ofxTableViewCell *containerCell = tbv->addCell(ofxTableViewCellStyleContainer, .25);
    
    ofxTableViewCell *label = containerCell->addCell(ofxTableViewCellStyleText, .5);
    
    label->setString(string("Split view"));
    
    ofxTableViewCell *image = containerCell->addCell(ofxTableViewCellStylePicture, .5);
    
    image->setImageFromDisk("Icon@2x.png");
    
    // 3 // NESTED TABLE

    ofxTableViewCell *text = tbv->addCell(ofxTableViewCellStyleText, .125);
    text->setString("NESTED TABLE");
    
    ofxTableView *nestedTable = tbv->addTable(.5);
    
    for (int i = 0; i < 10 + 1; i++) {
        
        ofxTableViewCell *picture = nestedTable->addCell(ofxTableViewCellStylePicture, .25);
        
        picture->setBgColor(ofColor(random()%255,random()%255,random()%255,200 ));
        
        picture->setImageFromDisk("Icon@2x.png");
        
        // 4 // CUSTOM CELL SUBCLASS
        
        myCustomCell *newCell = new myCustomCell;
        
        nestedTable->addCustomCell(newCell, .25);
        
        newCell->initWithParent(nestedTable, ofxTableViewCellStyleCustom, .25);

        newCell->drawsBorder = false;
    }
    
    // 5 // MODAL TABLE
    
    

    
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

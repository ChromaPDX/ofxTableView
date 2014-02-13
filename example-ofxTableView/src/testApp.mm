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
    
    tbv->addCellWithLabel("ofxTableView Header", .125);
    
    // 2 // CONTAINER CELL FOR HORIZONTAL SPLIT
    
    ofxTableViewCell *containerCell = tbv->addCellWithStyle(ofxTableViewCellStyleContainer, .25);
    
    ofxTableViewCell *label = containerCell->addCellWithStyle(ofxTableViewCellStyleText, .5);
    
    label->setString(string("Split view"));
    
    ofxTableViewCell *image = containerCell->addCellWithStyle(ofxTableViewCellStylePicture, .5);
    
    image->setImageFromDisk("Icon@2x.png");
    
    // 3 // NESTED TABLE

    ofxTableViewCell *text = tbv->addCellWithStyle(ofxTableViewCellStyleText, .125);
    text->setString("NESTED TABLE");
    
    ofxTableView *nestedTable = tbv->addTable(.5);
    
    for (int i = 0; i < 10; i++) {
        
        ofxTableViewCell *picture = nestedTable->addCellWithStyle(ofxTableViewCellStylePicture, .33);
        
        picture->setBgColor(ofColor(random()%255,random()%255,random()%255,200 ));
        
        picture->setImageFromDisk("Icon@2x.png");
        
        // DO SOME ANIMATION

        [picture->animationHandler runAction:[NodeAction repeatActionForever:
                                              [NodeAction sequence:@[[NodeAction group:@[
                                                                                         [NodeAction rotateByAngle:110 duration:.6],
                                                                                         [NodeAction moveByX:80 y:0 duration:.4],
                                                                                         [NodeAction moveByX:0 y:-90 duration:.4]]],
                                                                     [NodeAction group:@[
                                                                                         [NodeAction rotateByAngle:-30 duration:.2],
                                                                                         [NodeAction moveByX:-160 y:0 duration:.4],
                                                                                         [NodeAction moveByX:80 y:0 duration:.4],
                                                                                         [NodeAction moveByX:0 y:90 duration:.4]]]
                                                                     ]]
                                              ]];
        
        // 4 // CUSTOM CELL SUBCLASS
        
        myCustomCell *newCell = new myCustomCell;
        
        nestedTable->addCustomCell(newCell, .25);
        
        newCell->drawsBorder = false;
    }
    
    // 5 // MODAL TABLE
    
    ofxTableViewCell *modal = tbv->addCellWithStyle(ofxTableViewCellStyleModal, .25);
    
    modal->addCellWithLabel("MODAL TABLE", 1.);
    
    modal->transitionStyle = TransitionStyleZoomIn;
    modal->transitionTime = 1.5;
    
    // add table first
    
    modalTable = new ofxTableView;
    
    modalTable->initWithParent(modal, modal->getFrame());
    modalTable->isModal = true;
    modal->addChild(modalTable);
    
    ofxTableViewCell *back = modalTable->addCellWithStyle(ofxTableViewCellStyleModal, .25);
    
    back->addCellWithLabel("BACK", 1.);
    
    back->transitionStyle = TransitionStyleZoomOut;
    back->transitionTime = 1.;
    
    // Create back button
    
    for (int i = 0; i < 10 + 1; i++) {
     
        modalTable->addCellWithLabel("table cell " + ofToString(i), .25);
        
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

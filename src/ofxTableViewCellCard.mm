/*---------------------------------------------------
 Open Frameworks 0.05
 graphical user interface - Dennis Rosenfeld-2008
 *///--------------------------------

#include "ofxTableViewCellCard.h"

void ofxTableViewCellCard::begin(){
    ofxTableViewCell::begin();
    loaded = true;
	sequence.loadSequence("images.bundle/card.", "png", 1, 1, 4);
    sequence.preloadAllFrames();	//this way there is no stutter when loading frames
	sequence.setFrameRate(4);
  //  sequence.scale = .5;
    
	
	//playing = false; //controls if playing automatically, or controlled by the mouse
}

void ofxTableViewCellCard::draw(){
    ofxScrollView::begin();

    //sequence.getFrameForTime(ofGetElapsedTimef())->draw(0-getWidth()/2, 0-getHeight()/2, getWidth(), getHeight());
   // if(shouldRasterize){
   //     raster.begin();
   // }

    if(!loaded){
        begin();
    }
    
    
   // ofxTableViewCell::draw();
    //ofLog(OF_LOG_NOTICE, "in ofxTableViewCellCard::draw");

    //ofxScrollView::setHighlighted(false);
    
    //ofPushMatrix();


    
    if(highlighted){
        //NSLog(@"ofxTableViewCellCard::draw highlighted");
        glRotatef(30, 0, 1, 0);
        glTranslatef(-80, 0.0, 150);
      
    }


  
    ofTexture *texture = sequence.getFrame(1);
    
    ofEnableDepthTest();

   // texture->setUseExternalTextureID(raster.getFbo());
    texture->draw(0-getWidth()/2, 0-getHeight()/2, getWidth(), getHeight());
    
    ofDisableDepthTest();

    //if(shouldRasterize){
    //    raster.end();
    //}
    
    
  // ofPopMatrix();
   // sequence.getFrameForTime(ofGetElapsedTimef())->draw(0,0, getWidth(), getHeight());
   // sequence.getFrameForTime(1)->draw(0,0);
    
    //sequence.getFrame(1)->draw(0, 0, getWidth(), getHeight());
    
    
    
    ofxScrollView::end();
    
}



void ofxTableViewCellCard::update(){
       NSLog(@"ofxTableViewCellCard::update()");
      //  xspin < 360 ? xspin++ : xspin = 0;
}


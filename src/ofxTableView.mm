/*---------------------------------------------------
 Open Frameworks 0.05
 graphical user interface - Dennis Rosenfeld-2008
 *///--------------------------------


#include "ofxTableView.h"
#include "ofxTableViewCell.h"


ofxTableView::ofxTableView()//constructor
{
}

ofxTableView::~ofxTableView()//destructor
{
}

#pragma mark - @OVERRIDE

void ofxTableView::initWithParent(ofxScrollView *nparent, ofRectangle frame) {
    
    ofxScrollView::initWithParent(nparent, frame);

    hidden = false;
    drawsBorder = true;
    scrollingEnabled = true;
    scrollDirectionVertical = true;
    horizontalPadding = 0;
    verticalPadding = 20;
    
}

ofxTableViewCell*    ofxTableView::addCell(ofxTableViewCellStyle ncellStyle, float nheightPct)
{
    
    ofxTableViewCell *newCell = new ofxTableViewCell;
    
    newCell->initWithParent(this, ncellStyle, nheightPct);
    
    addChild(newCell);
    
    return newCell;

}

void ofxTableView::draw(){
    
    
    ofxScrollView::draw(frame);
    
    
}


    
    

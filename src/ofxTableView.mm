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

    dictionary.init_array();
    
    hidden = false;
    drawsBorder = true;
    scrollingEnabled = true;
    scrollDirectionVertical = true;
    horizontalPadding = 0;
    verticalPadding = 5*getScreenScale();
    
}

ofxTableViewCell*    ofxTableView::addCell(ofxTableViewCellStyle ncellStyle, float nheightPct)
{
    
    ofxTableViewCell *newCell = new ofxTableViewCell;
    
    newCell->initWithParent(this, ncellStyle, nheightPct);
    
    addChild(newCell);
    
    addDataSourceForCell(newCell);
    
    return newCell;

}

bool     ofxTableView::containsPoint(int x, int y) //check to see if mouse is within boundaries of object.
{
    
    int lx = x;
    int ly = y;
    
    bool withinArea = false;
    if ( lx > frame.x && lx < frame.x + frame.width && ly > frame.y && ly < frame.y + frame.height)
    {
        withinArea = true;
    }
    return withinArea;
}

ofRectangle  ofxTableView::getChildRect(ofxScrollView *v){
    
    if (fdirty) {

            
            int tempSize = 0;
            for(int i = 0; i < v->referenceId; i++)
            {
                int temp = children[i]->getHeight();
                tempSize += temp + verticalPadding;
            }
            
            
            v->setFrame(ofRectangle((horizontalPadding / 2.),
                                   tempSize + scrollPosition,
                                   bounds.width-(horizontalPadding),
                                   bounds.height * v->heightPct
                                    ));
            
            v->hidden = v->scrollShouldCull();
            
          
            return v->getFrame();
        
    }
    
    else {
        return v->getFrame();
    }
    
    
}


void ofxTableView::addDataSourceForCell(ofxTableViewCell *cell){
    
    if (cell->cellStyle == ofxTableViewCellStyleText) {
        
        dictionary[cell->referenceId]["text"] = "default";
        
        cell->dataSource = &dictionary[cell->referenceId]["text"];

    }
    
    else if (cell->cellStyle == ofxTableViewCellStyleGraph) {
        
        dictionary[cell->referenceId]["array"].init_array();
        
        cell->dataSource = &dictionary[cell->referenceId]["array"];

    }
    
    else if (cell->cellStyle == ofxTableViewCellStyleScroll) {
        
        dictionary[cell->referenceId]["array"].init_array();
        
        cell->dataSource = &dictionary[cell->referenceId]["array"];
        
    }
    
    else {
        
        dictionary[cell->referenceId]["text"] = "default";
        
        cell->dataSource = &dictionary[cell->referenceId]["text"];
        
    }
    
}

void ofxTableView::draw(){
    
  
    if (!raster.isAllocated()) {
        raster.allocate(bounds.width, bounds.height);
    }
    
    ofEnableAlphaBlending();
    
    if (clipToBounds) {
        
        raster.begin();
        
        ofClear(0,0,0,255);
        
        if (!hidden) {
            
            ofxScrollView::begin(bounds);
            
            // CUSTOM DRAW CODE
            
            ofxScrollView::end(bounds);
            
        }
        
        raster.end();
        
        raster.draw(frame.x, frame.y);
        
    }
    
    else {
        
        if (!hidden) {
            
            ofxScrollView::begin(bounds);
            
            // CUSTOM DRAW CODE
            
            ofxScrollView::end(bounds);
            
        }
        
    }
    
//    glDisable(GL_BLEND);
//    glColorMask(0, 0, 0, 1);
//    glColor4f(1,1,1,1.0f);
//    
//    ofRect(frame);
//    
//    glColorMask(1,1,1,0);
//    
//    glEnable(GL_BLEND);
//    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    
    
    
    
}


    
    

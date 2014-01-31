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

void ofxTableView::initWithParent(ofxScrollView *nparent, frame3d frame) {
    
    ofxScrollView::initWithParent(nparent, frame);

    dictionary.init_array();


    displayName = "TABLE VIEW";
    
    hidden = false;
    drawsBorder = true;
    scrollingEnabled = true;
    scrollDirectionVertical = true;
    horizontalPadding = 0;
    verticalPadding = 5*getScreenScale();
    
}

ofxTableViewCell*    ofxTableView::addCell(ofxTableViewCellStyle ncellStyle, float nautoSizePct)
{
    
    ofxTableViewCell *newCell = new ofxTableViewCell;
    
    newCell->initWithParent(this, ncellStyle, nautoSizePct);
    
    addDataSourceForCell(newCell);
    
    return newCell;

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
        
        
        ofxScrollView::begin();
        
        // CUSTOM DRAW CODE
        
        ofxScrollView::end();
        
        
        raster.end();
        
        raster.draw(bounds.x, bounds.y);
        
    }
    
    else {
        
            
            ofxScrollView::begin();
        

        
            // CUSTOM DRAW CODE
        
            //NSLog(@"drawLocation: P: %f %f %f S: %f %f", getX(), getY(),getZ(),getWidth(),getHeight());
        
            
            ofxScrollView::end();
            
        
    }

    
    if (_modalChild) {
        _modalChild->setOrientation(getOrientationQuat());
        
        ((ofxTableView*)_modalChild)->draw();
    }

    


    
//    glDisable(GL_BLEND);
//    glColorMask(0, 0, 0, 1);
//    glColor4f(1,1,1,1.0f);
//    
//    ofRect(bounds);
//    
//    glColorMask(1,1,1,0);
//    
//    glEnable(GL_BLEND);
//    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    
    
    
    
}


    
    

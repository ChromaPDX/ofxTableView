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

void ofxTableView::initWithParent(ofxScrollView* parent, float nautoSizePct){
    
    initWithParent(parent,frame3d(0, 0, 0, parent->getWidth(), parent->getHeight() * nautoSizePct));
    autoSizePct = nautoSizePct;
    
}

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

void  ofxTableView::addCustomCell(ofxTableViewCell *newCell, float autoSizePct){
    
    newCell->initWithParent(this, ofxTableViewCellStyleCustom, autoSizePct);
    
    addDataSourceForCell(newCell);
    
}

ofxTableView*    ofxTableView::addTable(float nautoSizePct)
{
    
    ofxTableView *nestedTable = new ofxTableView;
    
    nestedTable->initWithParent(this, nautoSizePct);
    
    dictionary[nestedTable->referenceId] = nestedTable->dictionary;
    
    nestedTable->scrollDirectionVertical = false;
    
    return nestedTable;
    
}


void ofxTableView::addDataSourceForCell(ofxTableViewCell *cell){
    
    if (cell->cellStyle == ofxTableViewCellStyleText) {
        
        dictionary[cell->referenceId]["text"] = "default";
        
        cell->dataSource = &dictionary[cell->referenceId]["text"];
        

    }
    
    else if (cell->cellStyle == ofxTableViewCellStyleGraph || cell->cellStyle == ofxTableViewCellStyleScroll || cell->cellStyle == ofxTableViewCellStyleContainer) {
        
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
        raster.allocate(myFrame.w, myFrame.h);
    }
    
  
    if (clipToBounds) {
        
        raster.begin();
        
        ofClear(0,0,0,255);
        
        
        ofxScrollView::begin();
        
        // CUSTOM DRAW CODE
        
        ofxScrollView::end();
        
        
        raster.end();
        
        raster.draw(getDrawFrame().x, getDrawFrame().y);
        
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

    
    
}


    
    

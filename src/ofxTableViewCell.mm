/*---------------------------------------------------
Open Frameworks 0.05
graphical user interface - Dennis Rosenfeld-2008
*///--------------------------------


#include "ofxTableViewCell.h"
#include "ofxTableView.h"


ofxTableViewCell::ofxTableViewCell()//constructor
{
}

ofxTableViewCell::~ofxTableViewCell()//destructor
{
}

void ofxTableViewCell::initWithParent(ofxTableView *nparent, ofxTableViewCellStyle ncellStyle, float nheightPct){
    
    ofxScrollView::initWithParent(nparent,ofRectangle(0, 0, nparent->getWidth(), nparent->getHeight()*nheightPct));
    
    cellStyle = ncellStyle;
    heightPct = nheightPct;

    scrollingEnabled = false;
    scrollDirectionVertical = false;
    horizontalPadding = 20;
    verticalPadding = 0;
    
    drawsBorder = true;
    drawsName = true;
    
    initStyle(cellStyle);
                                  
}

void ofxTableViewCell::initWithParent(ofxTableViewCell *nparent, ofxTableViewCellStyle ncellStyle, float nwidthPct){
    
    ofxScrollView::initWithParent(nparent,ofRectangle(0, 0, nwidthPct * nparent->getWidth(), nparent->getHeight()));
    
    cellStyle = ncellStyle;
    widthPct = nwidthPct;

    scrollingEnabled = false;
    scrollDirectionVertical = false;
    horizontalPadding = 0;
    verticalPadding = 0;
    
    drawsBorder = true;
    drawsName = true;
    
    initStyle(cellStyle);
    
}

ofxTableViewCell*    ofxTableViewCell::addCell(ofxTableViewCellStyle ncellStyle, float nWidthPct)
{
    ofxTableViewCell *newCell = new ofxTableViewCell;
    
    newCell->initWithParent(this, ncellStyle, nWidthPct);
    
    addChild(newCell);
    
    return newCell;
    
}

void    ofxTableViewCell::initStyle(ofxTableViewCellStyle style)
{
    cellStyle = style;
    
    if (style == ofxTableViewCellStyleDefault){
      
    }
    
    else if (style == ofxTableViewCellStyleText){
        
        displayName = "Text Cell";
        
    }
    
    else if (style == ofxTableViewCellStylePicture){
        
        displayName = "Picture Cell";
        
    }
    
    else if (style == ofxTableViewCellStyleSlider){
        
        displayName = "Slider Cell";
        
        minValue = 0;
        maxValue = 100;
        floatValue = minValue / maxValue;
        
    }
    
    else if (style == ofxTableViewCellStyleScroll){
        
        displayName = "Scroll Cell";
        
        scrollDirectionVertical = false;
        scrollingEnabled = true;
        
        
    }
    
    else if (style == ofxTableViewCellStyleCustom){
        displayName = "Custom Cell";
        
    }
    
    else if (style == ofxTableViewCellStyleRadio){
        
        
    }


}


void    ofxTableViewCell::draw(ofRectangle rect)
{

    if  (!hidden){
        
        ofxScrollView::draw(rect);
        
        if (customDrawFunction) {
            customDrawFunction(rect, customDrawData);
        }
        
    }
    
//    if (cellStyle == ofxTableViewCellStyleSlider) {
//        drawSlider(rect);
//    }
    
}


void ofxTableViewCell::drawSlider(ofRectangle rect){
    
    float percent = ((floatValue - minValue) / (maxValue - minValue));
    
    int slideWidth = int(percent*(float)rect.width);
    
    ofFill();
    
    ofSetColorf(fgColor);
    
//    if (fgColor != 0) ofSetColor(fgColor);
//    else ofSetColor(parent->fgColor);

    ofRect(rect.x, rect.y, slideWidth, rect.height);
    
}





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
    horizontalPadding = 5*getScreenScale();
    verticalPadding = 0;
    
    drawsBorder = true;
    drawsName = false;
    
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
    drawsName = false;
    
    initStyle(cellStyle);
    
}

ofxTableViewCell*    ofxTableViewCell::addCell(ofxTableViewCellStyle ncellStyle, float nWidthPct)
{
    ofxTableViewCell *newCell = new ofxTableViewCell;
    
    newCell->initWithParent(this, ncellStyle, nWidthPct);
    
    addChild(newCell);
    
    addDataSourceForCell(newCell);
    
    return newCell;
    
}

void ofxTableViewCell::addCustomCell(ofxTableViewCell* custom, float nWidthPct)
{

    custom->initWithParent(this, ofxTableViewCellStyleCustom, nWidthPct);
    
    addChild(custom);
    
    addDataSourceForCell(custom);

    
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
        drawsBorder = false;
        
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

ofRectangle  ofxTableViewCell::getChildRect(ofxScrollView *v){
    
    if (fdirty) {

        //   NSLog(@"rasterizing!!");
        if (cellStyle == ofxTableViewCellStyleRadialPicker){
            return v->getFrame();
        }
        
        else return ofxScrollView::getChildRect(v);
        
    }
    
    else {
        return v->getFrame();
    }
    
}

void ofxTableViewCell::addDataSourceForCell(ofxTableViewCell *cell){
  
    UniversalContainer dictionary = *dataSource;
    
    if (cell->cellStyle == ofxTableViewCellStyleText) {
        
        dictionary[cell->referenceId]["text"] = "default";
        
        cell->dataSource = &dictionary[cell->referenceId]["text"];
        
    }
    
    else if (cell->cellStyle == ofxTableViewCellStyleGraph) {
        
        dictionary[cell->referenceId]["array"].init_array();
        
        cell->dataSource = &dictionary[cell->referenceId]["array"];
        
    }
    
    else if (cell->cellStyle == ofxTableViewCellStyleScroll) {
        
        NSLog(@"no duplicate nesting of scrollers!!!!");
        
    }
    
    else {
        
        dictionary[cell->referenceId]["text"] = "default";
        
        cell->dataSource = &dictionary[cell->referenceId]["text"];

    }
    
}


void    ofxTableViewCell::draw(ofRectangle rect)
{
    
    if (!hidden) {
        
        ofxScrollView::begin(rect);
        
        if (cellStyle == ofxTableViewCellStyleText) {
            
            ofSetColorf(fgColor);
            
            sharedFont->drawString((string)*dataSource, rect.x + rect.width/2. - (sharedFont->stringWidth((string)*dataSource)/2.), rect.y + rect.height/2. + (sharedFont->stringHeight((string)*dataSource)/2.));
            
        }
        
        else if (cellStyle == ofxTableViewCellStyleGraph){
            
            if (dataSource) {

                if (dataSource->get_type() == uc_Array){
                    
                    ofFill();
                    ofSetColorf(fgColor);
                    ofPath path;
                    
                    path.moveTo(0, rect.height);
                    
                    int max = 0;
                    for(int i = 0; i < dataSource->size(); i++){
                        if (max < (int)(*dataSource)[i]) max = (*dataSource)[i];
                    }
                    float yscale = (float)rect.height / max;
                    float xscale = (rect.width/dataSource->size());
                    
                    for(int i = 0; i < dataSource->size(); i++){
                        
                        path.lineTo(i*xscale, (int)(*dataSource)[i] * yscale);
                        
                    }
                    
                    path.lineTo(rect.width, rect.height);

                    
                    path.draw(rect.x, rect.y);

                }

                
            }

        }
        
        else if (cellStyle == ofxTableViewCellStylePicture) {
            
            ofSetColorf(fgColor);
            
            if (!_image.isAllocated() && dataSource && dataSource->length() != 0) {
                _image.loadImage(*dataSource);
            }


            float scale = MIN(rect.height / _image.height, rect.width / _image.width);
            _image.draw(rect.x + ((rect.width - _image.width*scale) / 2.),rect.y+((rect.height - _image.height*scale) / 2.),_image.width*scale, _image.height*scale);

            
        }
        
        else if (cellStyle == ofxTableViewCellStyleSlider) {
            drawSlider(rect);
        }
        
        if (customDrawFunction) {
            customDrawFunction(rect, customDrawData);
        }
        
        
        ofxScrollView::end(rect);
        
    }
    
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

void ofxTableViewCell::setString(string s){
    
    if (dataSource->get_type() == uc_String || dataSource->get_type() == uc_Null) {
        
    *dataSource = s;
    
    NSLog(@"set string %s for cell %d " , ((string)*dataSource).c_str(), referenceId);
        
    }
    
    else NSLog(@"UC _ SET _ TYPE _ CONFLICT : EXPECTED STRING");
    
}


void ofxTableViewCell::setImage(ofImage image){
    _image = image;
}

void ofxTableViewCell::setImageFromDisk(string filename){
    
    if (dataSource->get_type() == uc_String || dataSource->get_type() == uc_Null) {
        
        *dataSource = filename;
        
        NSLog(@"set image %s for cell %d " , ((string)*dataSource).c_str(), referenceId);
        
        
    }
    
    else NSLog(@"UC _ SET _ TYPE _ CONFLICT : EXPECTED STRING");
    
}



void ofxTableViewCell::setArray(vector<int> array){
    
    if (dataSource->get_type() == uc_Array || dataSource->get_type() == uc_Null) {
        
        for (int i = 0; i < array.size(); i++) {
            (*dataSource)[i] = (array)[i];
        }
        NSLog(@"set array sized: %lu for cell %d",dataSource->get_vector()->size(), referenceId);
    }
    
    else NSLog(@"UC _ SET _ TYPE _ CONFLICT : EXPECTED ARRAY");
    
    
}





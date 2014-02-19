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

void ofxTableViewCell::initWithParent(ofxTableView *nparent, ofxTableViewCellStyle ncellStyle, float nautoSizePct){
    
    ofxScrollView::initWithParent(nparent,frame3d(0, 0, 0, nparent->getWidth(), nparent->getHeight()*nautoSizePct));
    
    cellStyle = ncellStyle;
    autoSizePct = nautoSizePct;
    
    scrollingEnabled = false;
    scrollDirectionVertical = false;
    horizontalPadding = 5*getScreenScale();
    verticalPadding = 0;
    
    drawsBorder = true;
    drawsName = false;
    
    initStyle(cellStyle);
    
}

void ofxTableViewCell::initWithParent(ofxTableViewCell *nparent, ofxTableViewCellStyle ncellStyle, float nautoSizePct){
    
    ofxScrollView::initWithParent(nparent,frame3d(0, 0, 0, nautoSizePct * nparent->getWidth(), nparent->getHeight()));
    
    cellStyle = ncellStyle;
    autoSizePct = nautoSizePct;
    
    scrollingEnabled = false;
    scrollDirectionVertical = false;
    horizontalPadding = 0;
    verticalPadding = 0;
    
    drawsBorder = true;
    drawsName = false;
    
    initStyle(cellStyle);
    
}

ofxTableViewCell*    ofxTableViewCell::addCellWithStyle(ofxTableViewCellStyle ncellStyle, float nautoSizePct)
{
    ofxTableViewCell *newCell = new ofxTableViewCell;
    
    newCell->initWithParent(this, ncellStyle, nautoSizePct);
    
    addChild(newCell);
    
    addDataSourceForCell(newCell);
    
    return newCell;
    
}

ofxTableViewCell*    ofxTableViewCell::addCellWithLabel(string label, float autoSizePct)
{
    
    ofxTableViewCell *newCell = addCellWithStyle(ofxTableViewCellStyleText, autoSizePct);
    
    addChild(newCell);
    
    newCell->setString(label);
    
    return newCell;
    
}

void  ofxTableViewCell::addCustomCell(ofxTableViewCell *newCell, float autoSizePct){
    
    newCell->initWithParent(this, ofxTableViewCellStyleCustom, autoSizePct);
    
    addChild(newCell);
    
    addDataSourceForCell(newCell);
    
}

ofxTableView*    ofxTableViewCell::addTable(float nautoSizePct)
{
    
    ofxTableView *nestedTable = new ofxTableView;
    
    nestedTable->initWithParent(this, nautoSizePct);
    
    addChild(nestedTable);
    
    (*dataSource)[nestedTable->referenceId] = nestedTable->dictionary;
    
    return nestedTable;
    
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
    
    else if (style == ofxTableViewCellStyleContainer){
        scrollDirectionVertical = false;
        scrollingEnabled = false;
        horizontalPadding = 0;
        verticalPadding = 0;
    }
    
    else if (style == ofxTableViewCellStyleModal){
        
        displayName = "Nested Table";
        
        scrollDirectionVertical = false;
        scrollingEnabled = false;
        
        
    }
    
    else if (style == ofxTableViewCellStyleCustom){
        displayName = "Custom Cell";
        
    }
    
    else if (style == ofxTableViewCellStyleRadio){
        
        
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
        
        dictionary[cell->referenceId]["array"].init_array();
        
        cell->dataSource = &dictionary[cell->referenceId]["array"];
        
    }
    
    else {
        
        dictionary[cell->referenceId]["text"] = "default";
        
        cell->dataSource = &dictionary[cell->referenceId]["text"];
        
    }
    
}

int* ofxTableViewCell::getIndexPath(){
    
    if (getParent() == getRoot()) {
        
        indexPath[0] = referenceId;
        indexPath[1] = 0;
        
        return indexPath;
    }
    
    else {
        indexPath[0] = _parent->referenceId;
        indexPath[1] = referenceId;
        
        return indexPath;
    }
    
}


void    ofxTableViewCell::draw()
{
   // ofLog(OF_LOG_NOTICE, "in ofxTableViewCell::draw");

    
    if (!hidden) {
        
        
        begin();
        
        
        ofRectangle d = getDrawFrame();
        
        if (cellStyle == ofxTableViewCellStyleText) {
            
            ofSetColorf(fgColor);
            
            ofPushMatrix();
            glTranslatef(0, 0, 1);
            sharedFont->drawString((string)*dataSource, -(sharedFont->stringWidth((string)*dataSource)/2.), (sharedFont->stringHeight((string)*dataSource)/2.));
            ofPopMatrix();
            
        }
        
        else if (cellStyle == ofxTableViewCellStyleGraph){
            
            if (dataSource) {
                
                if (dataSource->get_type() == uc_Array){
                    
                    ofFill();
                    ofSetColorf(fgColor);
                    ofPath path;
                    
                    path.moveTo(0, d.height);
                    
                    int max = 0;
                    for(int i = 0; i < dataSource->size(); i++){
                        if (max < (int)(*dataSource)[i]) max = (*dataSource)[i];
                    }
                    float yscale = (d.height) / max;
                    float xscale = (d.width/dataSource->size());
                    
                    for(int i = 0; i < dataSource->size(); i++){
                        
                        path.lineTo(i*xscale, (int)(*dataSource)[i] * yscale);
                        
                    }
                    
                    path.lineTo(d.width, d.height);
                    
                    
                    path.draw(d.x, d.y);
                    
                }
                
                
            }
            
        }
        
        else if (cellStyle == ofxTableViewCellStylePicture) {
            
            ofSetColorf(fgColor);
            
            if (!_image.isAllocated() && dataSource && dataSource->length() != 0) {
                _image.loadImage(*dataSource);
            }
            
            float scale = MIN(d.height / _image.height, d.width / _image.width);
            _image.draw(d.x + ((d.width - _image.width*scale) / 2.),d.y+((d.height - _image.height*scale) / 2.),_image.width*scale, _image.height*scale);
            
            
        }
        
        else if (cellStyle == ofxTableViewCellStyleModal){
            
//            for (int i = 0; i < children.size(); i++){
//                
//                if (!children[0]->_modalParent) {
//                    children[0]->hidden = true;
//                }
//                
//            }
            
        }
        
        //        else if (cellStyle == ofxTableViewCellStyleSlider) {
        //            drawSlider(rect);
        //        }
        
        //        if (customDrawFunction) {
        //            customDrawFunction(rect, customDrawData);
        //        }
        
        
        end();
        
    }
    
}

void ofxTableViewCell::begin(){
    ofxScrollView::begin();
}

void ofxTableViewCell::end(){
    
    if (!hidden && (!shouldRasterize || (shouldRasterize && dirty)))
    {
        
        ofRectangle d = getDrawFrame();
        
        for(int i = 0; i < children.size(); i++)
        {
            
            if (cellStyle == ofxTableViewCellStyleModal) {
                
                if (children[i]->isModal) {
                    
                    if (!getRoot()->_modalChild) {
                        
                        setChildFrame(children[i]);
                        
                        if (drawsModalChild) {
                            if (!children[i]->hidden) {
                                children[i]->draw();
                            }
                        }
                    }
                    
                }
                
                else {
                    setChildFrame(children[i]);
                    children[i]->draw();
                }
                
            }
            
            else {
                setChildFrame(children[i]);
                if (!children[i]->hidden) {
                    children[i]->draw();
                }
            }
            
        }
        
        if (drawsBorder) {
            ofNoFill();
            
            ofSetColorf(fgColor);
            ofSetLineWidth(2*getScreenScale());
            
            ofRect(d);
        }
        
        
        if (shouldRasterize) {
            
            raster.end();
            
            ofPushMatrix();
            ofMultMatrix( getLocalTransformMatrix() );
            
            raster.draw(d.x, d.y);
            
        }
        
        
        
        if (highlighted) {
            ofEnableBlendMode(OF_BLENDMODE_ADD);
            ofFill();
            ofSetColor(255,255,255,100);
            ofRect(d);
            ofEnableBlendMode(OF_BLENDMODE_ALPHA);
        }
        
        dirty = false;
        fdirty = false;
        
        ofPopMatrix();
        
    }
}

//void ofxTableViewCell::drawSlider(){
//
//    float percent = ((floatValue - minValue) / (maxValue - minValue));
//
//    int slideWidth = int(percent*(float)rect.width);
//
//    ofFill();
//
//    ofSetColorf(fgColor);
//
////    if (fgColor != 0) ofSetColor(fgColor);
////    else ofSetColor(parent->fgColor);
//
//    ofRect(rect.x, rect.y, slideWidth, rect.height);
//
//}

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

void toggleSelected(){
    
    
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

void ofxTableViewCell::setModalTable(ofxScrollView *modal){
    
    *dataSource = (void*)modal;
    NSLog(@"set nested table called: %s for cell %d",((ofxTableView*)dataSource)->displayName.c_str(), referenceId);
    
}


bool     ofxTableViewCell::touchUp(float x, float y, int touchId){
    
    if (cellStyle == ofxTableViewCellStyleModal) {
        if (!getRoot()->_modalChild){

                for (int i = 0; i < children.size(); i++) {
                    
                    if (children[i]->isModal) {
                        
                        ((ofxTableView*)getRoot())->pushModalView(children[i], transitionStyle, transitionTime);
                        
                        NSLog(@"presenting modal table");
                        i = children.size();
                        
                    }
                    
                   // NSLog(@"found type %s", typeid(children[i]).name());
                }
            
        }
        
        if (getRoot()->_modalParent) {
            getRoot()->_modalParent->popModalView(transitionStyle, transitionTime);
        }
        
    }
    
    else if (  ofxScrollView::touchUp(x, y, touchId) ){
        
        
        if (((ofxTableView*)getRoot())->delegate) {
            ((ofxTableView*)getRoot())->delegate->cellWasSelected(this);
            // logFrame(getGlobalFrame());
        }
        
        
        
        return true;
        
    }
    
    return false;
    
    
    
}

bool     ofxTableViewCell::touchDown(float x, float y, int touchId){
    
    return ofxScrollView::touchDown(x, y, touchId);
    
    
}

bool     ofxTableViewCell::touchMoved(float x, float y, int touchId){
    
    return ofxScrollView::touchMoved(x, y, touchId);
    
}

bool     ofxTableViewCell::touchDoubleTap(float x, float y, int touchId){
    
    return ofxScrollView::touchDoubleTap(x, y, touchId);
    
    
}



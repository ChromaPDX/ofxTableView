/***********************************************************************
 * Written by Leif Shackelford
 * Copyright (c) 2014 Chroma Games
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Chroma Games nor the names of its contributors
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ***********************************************************************/

#ifndef ofxTableViewCell_H_INCLUDED
#define ofxTableViewCell_H_INCLUDED

#include "ofxScrollView.h"
#include "ucontainer.h"

class ofxTableView;

using namespace JAD;

typedef enum ofxTableViewCellStyle {
    
    ofxTableViewCellStyleDefault,
    ofxTableViewCellStyleText,
    ofxTableViewCellStylePicture,
    ofxTableViewCellStyleSlider,
    ofxTableViewCellStyleModal,
    ofxTableViewCellStyleRadio,
    ofxTableViewCellStyleScroll,
    ofxTableViewCellStyleRadialPicker,
    ofxTableViewCellStyleGraph,
    ofxTableViewCellStyleCustom
    
} ofxTableViewCellStyle;

class   ofxTableViewCell : public ofxScrollView
{
    //Handles overall control of the User interface.
    
protected:
        ofImage         _image;
        int indexPath[2];
    
public:
    ofxTableViewCell();                           //constructor
    ~ofxTableViewCell();                          //destructor
    
    //METHODS:--------------------------------------------------------
    
    void initWithParent(ofxTableView *nparent, ofxTableViewCellStyle cellStyle, float autoSizePct);
    void initWithParent(ofxTableViewCell *nparent, ofxTableViewCellStyle ncellStyle, float nautoSizePct);
    ofxTableViewCell* addCell(ofxTableViewCellStyle ncellStyle, float nautoSizePct);
    void addCustomCell(ofxTableViewCell* custom, float nautoSizePct);
    
    void initStyle(ofxTableViewCellStyle cellStyle);

    
    void            draw();
    
    // DRAW STYLES
    

    // SUB VIEWS
    void addCell    (ofxTableViewCell *cell);
    void addDataSourceForCell(ofxTableViewCell *cell);
    

    void setString(string s);
    void setArray(vector<int> array);
    
    void setImageFromDisk(string filename);
    
    void setImage(ofImage image);
    
    void setModalTable(ofxScrollView *modal);
    
    int* getIndexPath();
    
    
    // CONFIGURABLE PROPERTIES
    

    ofxTableViewCellStyle          cellStyle;

    bool            myState;
    
    float           floatValue;
    float           minValue;
    float           maxValue;
    
    string          myText;
    bool            isDraggable;
    
    UniversalContainer *dataSource;

    void (*customDrawFunction)(ofRectangle rect, void* customDrawData) = NULL;
    
    void *customDrawData = NULL;
    
    bool            touchDown(float x, float y, int touchId);
    bool            touchMoved(float x, float y, int touchId);
    bool            touchUp(float x, float y, int touchId);
    bool            touchDoubleTap(float x, float y, int touchId);
    
};


#endif // ofxTableViewCell_H_INCLUDED

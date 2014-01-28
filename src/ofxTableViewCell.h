/***********************************************************************
 * Written by Leif Shackelford
 * Copyright (c) 2014 Chroma.io
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
 *     * Neither the name of MSA Visuals nor the names of its contributors
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
    
public:
    ofxTableViewCell();                           //constructor
    ~ofxTableViewCell();                          //destructor
    
    //METHODS:--------------------------------------------------------
    
    void initWithParent(ofxTableView *nparent, ofxTableViewCellStyle cellStyle, float heightPct);
    void initWithParent(ofxTableViewCell *nparent, ofxTableViewCellStyle ncellStyle, float nwidthPct);
    ofxTableViewCell* addCell(ofxTableViewCellStyle ncellStyle, float nWidthPct);
    void addCustomCell(ofxTableViewCell* custom, float nWidthPct);
    
    void initStyle(ofxTableViewCellStyle cellStyle);

    
    ofRectangle     getChildRect(ofxScrollView *v);
    void            draw(ofRectangle rect);
    
    // DRAW STYLES
    
    void            drawSlider(ofRectangle rect);

    // SUB VIEWS
    void addCell    (ofxTableViewCell *cell);
    void addDataSourceForCell(ofxTableViewCell *cell);
    

    void setString(string s);
    void setArray(vector<int> array);
    
    void setImageFromDisk(string filename);
    
    void setImage(ofImage image);
    
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
};


#endif // ofxTableViewCell_H_INCLUDED
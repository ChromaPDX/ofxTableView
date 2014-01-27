#ifndef ofxTableViewCell_H_INCLUDED
#define ofxTableViewCell_H_INCLUDED

#include "ofxScrollView.h"

class ofxTableView;

typedef enum ofxTableViewCellStyle {
    
    ofxTableViewCellStyleDefault,
    ofxTableViewCellStyleText,
    ofxTableViewCellStylePicture,
    ofxTableViewCellStyleSlider,
    ofxTableViewCellStyleRadio,
    ofxTableViewCellStyleScroll,
    ofxTableViewCellStyleCustom
    
} ofxTableViewCellStyle;

class   ofxTableViewCell : public ofxScrollView
{
    //Handles overall control of the User interface.
    
protected:

    int             referenceID;
    int             sortID;

public:
    ofxTableViewCell();                           //constructor
    ~ofxTableViewCell();                          //destructor
    
    //METHODS:--------------------------------------------------------
    
    void initWithParent(ofxTableView *nparent, ofxTableViewCellStyle cellStyle, float heightPct);
    void initWithParent(ofxTableViewCell *nparent, ofxTableViewCellStyle ncellStyle, float nwidthPct);
    ofxTableViewCell* addCell(ofxTableViewCellStyle ncellStyle, float nWidthPct);
    
    void initStyle(ofxTableViewCellStyle cellStyle);

    void            draw(ofRectangle rect);
    
    // DRAW STYLES
    
    void            drawSlider(ofRectangle rect);

    // SUB VIEWS
    void addCell    (ofxTableViewCell *cell);


    // CONFIGURABLE PROPERTIES
    

    ofxTableViewCellStyle          cellStyle;

    bool            myState;
    
    float           floatValue;
    float           minValue;
    float           maxValue;
    
    string          myText;
    bool            isDraggable;

    void (*customDrawFunction)(ofRectangle rect, void* customDrawData) = NULL;
    
    void *customDrawData = NULL;
};


#endif // ofxTableViewCell_H_INCLUDED

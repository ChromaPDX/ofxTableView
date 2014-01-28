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
